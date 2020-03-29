import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/count_button.dart';
import 'package:waitathome/ui/components/queue_button.dart';

class CustomerTracking extends StatefulWidget {
  @override
  _CustomerTrackingState createState() => _CustomerTrackingState();
}

class _CustomerTrackingState extends State<CustomerTracking> {
  Shop shop;
  ShopService shopService;

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;
    print('tracking start $shopId');
    shopService = Provider.of<ShopService>(context, listen: false);
    var shopStream = shopService.getShop(shopId);

    return StreamBuilder(
        stream: shopStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearProgressIndicator(),
            );
          }

          Map<String, dynamic> shopDto = snapshot.data.data;
          shop = Shop.fromJson(shopDto);
          // TODO: putIfAbsent is lazy? Other solution
          shop.id = snapshot.data.documentID;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${shop.name}',
                  style: TextStyle(
                    fontSize: 44,
                  ),
                ),
                Text(
                  '${shop.customerInStore}',
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildCountButtons(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Warteschlange',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildQueueButton(0, 'Kurz', 1),
                      buildQueueButton(1, 'Mittel', 2),
                      buildQueueButton(2, 'Lang', 3),
                    ],
                  ),
                ),
                InkWell(
                  child: Text(
                    'Ladenkapazität anpassen',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    var customers = shop.customerInStore;
                    createDialog(context).then((newLimit) {
                      if (newLimit != null) {
                        if (customers >= newLimit) {
                          enableQueue();
                          shopService.setConsumerInStore(shop.id, newLimit);
                        } else {
                          disableQueue();
                          shopService.setQueue(shop.id, 0);
                        }
                        shopService.setLimit(shop.id, newLimit);
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void disableQueue() {
    shopService.setQueueEnabled(shop.id, false);
    shopService.setActiveButton(shop.id, [false, false, false]);
  }

  Row _buildCountButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CountButton(
            label: '-',
            onPressed: () {
              decreaseCustomerCount();
            }),
        SizedBox(
          width: 20,
        ),
        CountButton(
            label: '+',
            onPressed: () {
              increaseCustomerCount();
            }),
      ],
    );
  }

  Future<int> createDialog(BuildContext context) {
    TextEditingController customController =
        TextEditingController(text: shop.limit.toString());

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ladenkapazität'),
            content: TextField(
              decoration: InputDecoration(
                labelText: "Geschäftskapazität",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ], // O
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Speichern'),
                onPressed: () {
                  var value = customController.text.toString();
                  final newLimit = value != '' ? int.parse(value) : shop.limit;
                  Navigator.of(context).pop(newLimit);
                },
              ),
            ],
          );
        });
  }

  QueueButton buildQueueButton(int index, String text, int numberOfPeople) {
    return QueueButton(
      label: text,
      active: shop.activeButton[index],
      onPressed: () {
        if (shop.queueEnabled) {
          setQueue(index, numberOfPeople);
        }
      },
    );
  }

  void decreaseCustomerCount() {
    var customers = shop.customerInStore;
    if (customers > 0 && shop.queue == 0) {
      shopService.setConsumerInStore(shop.id, --customers);
    }
    if (customers < shop.limit && shop.queueEnabled) {
      disableQueue();
    }
  }

  void increaseCustomerCount() {
    var customers = shop.customerInStore;
    if (customers < shop.limit) {
      shopService.setConsumerInStore(shop.id, ++customers);
    }
    if (customers == shop.limit) {
      enableQueue();
    }
  }

  void enableQueue() {
    shopService.setQueueEnabled(shop.id, true);
  }

  void setQueue(int index, int queueSize) {
    if (shop.queue == queueSize) {
      queueSize = 0;
    }
    shopService.setQueue(shop.id, queueSize);
    setActiveButton(index);
  }

  void setActiveButton(int index) {
    if (shop.activeButton[index]) {
      shopService.setActiveButton(shop.id, [false, false, false]);
    } else {
      var newActiveButton = [false, false, false];
      newActiveButton[index] = true;
      shopService.setActiveButton(shop.id, newActiveButton);
    }
  }
}

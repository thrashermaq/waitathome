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
  int limit = 10;
  int queue = 0;

  var activeButton = [false, false, false];
  bool queueEnabled = false;
  Shop shop;

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;
    print('tracking start $shopId');
    var shopService = Provider.of<ShopService>(context, listen: false);
    var shopStream = shopService.getShop(shopId);

    return StreamBuilder(
        stream: shopStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading'),
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
                    left: 20,
                    right: 20,
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
                          setState(() {
                            customers = newLimit;
                            queueEnabled = true;
                          });
                        } else {
                          setState(() {
                            queueEnabled = false;
                            queue = 0;
                            activeButton = [false, false, false];
                          });
                        }
                        setState(() {
                          limit = newLimit;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
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
        TextEditingController(text: limit.toString());

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
                  final newLimit = value != '' ? int.parse(value) : limit;
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
      active: activeButton[index],
      onPressed: () {
        if (queueEnabled) {
          setQueue(numberOfPeople);
          setActiveButton(index);
        }
      },
    );
  }

  void decreaseCustomerCount() {
    var customers = shop.customerInStore;
    if (customers > 0 && queue == 0) {
      var shopService = Provider.of<ShopService>(context, listen: false);
      shopService.setConsumerInStore(shop.id, --customers);
    }
    if (customers < limit && queueEnabled) {
      setState(() {
        queueEnabled = false;
      });
    }
  }

  void increaseCustomerCount() {
    var customers = shop.customerInStore;
    if (customers < limit) {
      var shopService = Provider.of<ShopService>(context, listen: false);
      shopService.setConsumerInStore(shop.id, ++customers);
    }
    if (customers == limit) {
      setState(() {
        queueEnabled = true;
      });
    }
  }

  void setQueue(int queueSize) {
    if (queue == queueSize) {
      queueSize = 0;
    }
    setState(() {
      queue = queueSize;
    });
  }

  void setActiveButton(int index) {
    if (activeButton[index]) {
      setState(() {
        activeButton = [false, false, false];
      });
    } else {
      setState(() {
        activeButton = [false, false, false];
        activeButton[index] = true;
      });
    }
  }
}

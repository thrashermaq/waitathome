import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/capacity_dialog.dart';
import 'package:waitathome/ui/components/count_button.dart';
import 'package:waitathome/ui/components/queue_button.dart';
import 'package:waitathome/ui/components/queue_types.dart';

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
    shopService = Provider.of<ShopService>(context, listen: false);

    return StreamBuilder(
        stream: shopService.getShop(shopId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearProgressIndicator(),
            );
          }

          shop = Shop.fromJson(snapshot.data.data);
          shop.id = snapshot.data.documentID;
          bool storeIsFull = shop.customerInStore >= shop.limit;
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
                _buildCountButtons(shop),
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
                      buildQueueButton(QueueTypes.SMALL, storeIsFull),
                      buildQueueButton(QueueTypes.MEDIUM, storeIsFull),
                      buildQueueButton(QueueTypes.BIG, storeIsFull),
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
                      _showCapacityDialog(context);
                    }),
              ],
            ),
          );
        });
  }

  Row _buildCountButtons(Shop shop) {
    var customerInStore = shop.customerInStore;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CountButton(
          label: '-',
          disabled: customerInStore <= 0 || shop.queue != null,
          onPressed: () {
            if (customerInStore < shop.limit && shop.queue != null) {
              shopService.setQueue(shop.id, null);
            }
            if (customerInStore > 0 && shop.queue == null) {
              shopService.setConsumerInStore(shop.id, --customerInStore);
            }
          },
        ),
        SizedBox(
          width: 20,
        ),
        CountButton(
            label: '+',
            disabled: customerInStore >= shop.limit,
            onPressed: () {
              if (customerInStore < shop.limit) {
                shopService.setConsumerInStore(shop.id, ++customerInStore);
              }
            }),
      ],
    );
  }

  QueueButton buildQueueButton(QueueTypes queueType, bool isStoreFull) {
    return QueueButton(
      label: queueType.buttonText,
      active: isActive(shop.queue, queueType.value),
      disabled: !isStoreFull,
      onPressed: () {
        if (shop.queue != queueType.value) {
          shopService.setQueue(shop.id, queueType.value);
        } else {
          shopService.setQueue(shop.id, null);
        }
      },
    );
  }

  void _showCapacityDialog(BuildContext context) {
    var customers = shop.customerInStore;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CapacityDialog(shop.limit, (newLimit) {
          if (newLimit != null) {
            if (customers >= newLimit) {
              shopService.setConsumerInStore(shop.id, newLimit);
            } else {
              shopService.setQueue(shop.id, null);
            }
            shopService.setLimit(shop.id, newLimit);
          }
        });
      },
    );
  }

  isActive(int queue, int index) {
    if (queue == null) {
      return false;
    }
    return queue == index;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/queue_types.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/capacity_dialog.dart';
import 'package:waitathome/ui/components/count_button.dart';
import 'package:waitathome/ui/components/queue_button.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Shop shop;
  ShopService shopService;

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;
    shopService = Provider.of<ShopService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: _buildCustomerTracker(shopId),
        ),
      ),
    );
  }

  StreamBuilder<DocumentSnapshot> _buildCustomerTracker(String shopId) {
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              _buildHeader(),
              _buildCounterDisplay(),
              _buildCountButtons(shop),
              SizedBox(
                height: 50,
              ),
              _buildFooter(storeIsFull, context),
            ],
          );
        });
  }

  Column _buildFooter(bool storeIsFull, BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Queuesize',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildQueueButton(QueueTypes.SMALL, storeIsFull),
              _buildQueueButton(QueueTypes.MEDIUM, storeIsFull),
              _buildQueueButton(QueueTypes.BIG, storeIsFull),
            ],
          ),
        ),
        InkWell(
          child: Text(
            'Change shop capacity',
            style: TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
              color: Colors.deepOrangeAccent,
            ),
          ),
          onTap: () {
            _showCapacityDialog(context);
          },
        ),
      ],
    );
  }

  Padding _buildCounterDisplay() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '${shop.customerInStore}',
        style: TextStyle(
          fontSize: 130,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: <Widget>[
        Text(
          '${shop.name}',
          style: TextStyle(
            fontSize: 44,
          ),
        ),
        Text(
          'Customers in shop',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
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
          width: 30,
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

  QueueButton _buildQueueButton(QueueTypes queueType, bool isStoreFull) {
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

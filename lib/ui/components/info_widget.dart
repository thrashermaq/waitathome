import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';

class InfoWidget extends StatefulWidget {
  final double position;
  final String shopId;

  InfoWidget({this.position, this.shopId});

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  // TODO: Load favourite from local store
  bool isFavourite = false;
  Shop shop;

  @override
  Widget build(BuildContext context) {
    var shopService = Provider.of<ShopService>(context, listen: false);
    var shopStream = shopService.getShop(widget.shopId);

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

          return AnimatedPositioned(
            bottom: widget.position,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 70,
                decoration: circularBoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildStatusCircle(shop),
                      _buildShopInfo(shop),
                      _buildFavouriteButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  IconButton _buildFavouriteButton() => IconButton(
        icon: Icon(
          isFavourite ? Icons.star : Icons.star_border,
          color: Colors.orange,
        ),
        onPressed: () {
          setState(() {
            isFavourite = !isFavourite;
            // TODO: Safe state to local store
          });
        },
      );

  Expanded _buildShopInfo(Shop shop) => Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                shop.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Personen: ${shop.customerInStore}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Container _buildStatusCircle(Shop shop) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: _getStatusColor(shop.customerInStore),
        shape: BoxShape.circle,
      ),
    );
  }

  BoxDecoration circularBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(50)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          blurRadius: 20,
          offset: Offset.zero,
          color: Colors.grey.withOpacity(0.5),
        )
      ],
    );
  }

  Color _getStatusColor(int customerInStore) {
    if (customerInStore < 25) {
      return Colors.green;
    } else if (customerInStore < 50) {
      return Colors.orange;
    }
    return Colors.red;
  }
}

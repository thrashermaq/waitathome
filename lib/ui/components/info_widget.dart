import 'package:flutter/material.dart';
import 'package:waitathome/core/model/shop.dart';

class InfoWidget extends StatefulWidget {
  final double position;
  final Shop shop;

  InfoWidget({this.position, this.shop});

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  // TODO: Load favourite from local store
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return widget.shop != null
        ? AnimatedPositioned(
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
                      _buildStatusCircle(),
                      _buildShopInfo(),
                      _buildFavouriteButton(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
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

  Expanded _buildShopInfo() => Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.shop.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Personen: ${widget.shop.customerInStore}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Container _buildStatusCircle() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: _getStatusColor(),
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

  Color _getStatusColor() {
    var customer = widget.shop.customerInStore;
    if (customer < 25) {
      return Colors.green;
    } else if (customer < 50) {
      return Colors.orange;
    }
    return Colors.red;
  }
}

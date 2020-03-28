import 'package:flutter/material.dart';
import 'package:waitathome/core/model/marker_data.dart';

class InfoWidget extends StatefulWidget {
  final double position;
  final MarkerData markerData;

  InfoWidget({this.position, this.markerData});

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
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
                _buildStatusCircle(),
                _buildShopInfo(),
                _buildFavouriteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton _buildFavouriteButton() => IconButton(
        icon: Icon(
          widget.markerData.isFavourite ? Icons.star : Icons.star_border,
          color: Colors.orange,
        ),
        onPressed: () {
          setState(() {
            widget.markerData.isFavourite = !widget.markerData.isFavourite;
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
                widget.markerData.shopName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Personen: ${widget.markerData.peopleCount}, Schlange: ${widget.markerData.queueCount}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Container _buildStatusCircle() => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );

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
        ]);
  }
}

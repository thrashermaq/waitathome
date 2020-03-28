import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/ui/components/info_widget.dart';

const double CAMERA_ZOOM = 15;
const LatLng START_LOCATION = LatLng(46.94809, 7.44744);

/// TODO: Package for search: https://pub.dev/packages/search_map_place
class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _mapStyle;
  GoogleMapController mapController;
  BitmapDescriptor greenMarker;
  BitmapDescriptor orangeMarker;
  BitmapDescriptor redMarker;

  final LatLng _center = START_LOCATION;
  Set<Marker> _markers = new Set();

  double infoWidgetPosition = -100;
  Shop selectedShop;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    loadCustomMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(),
          InfoWidget(
            position: infoWidgetPosition,
            shop: selectedShop,
          ),
        ],
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      markers: _markers,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      onTap: (LatLng location) {
        setState(() {
          // reset info widget and trigger animation
          infoWidgetPosition = -100;
        });
      },
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: CAMERA_ZOOM,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
    setState(() {
      loadMarkers();
    });
  }

  void loadMarkers() {
    // TODO: Get shops from firebase
    List<Shop> shops = new List();
    shops.add(Shop(1, 'Coop Bern', null, 46.94709, 7.44944, 10));
    shops.add(Shop(2, 'Migros Aare', null, 46.94850, 7.44784, 20));
    shops.add(Shop(3, 'Denner', null, 46.94971, 7.44700, 40));
    shops.add(Shop(4, 'Gemüseladen', null, 46.94809, 7.44602, 50));

    shops.forEach((shop) {
      _markers.add(
        Marker(
          markerId: MarkerId(shop.id.toString()),
          position: LatLng(shop.lat, shop.long),
          icon: getMarker(shop),
          onTap: () {
            setState(() {
              infoWidgetPosition = 0;
              selectedShop = shop;
              log(shop.toString());
            });
          },
        ),
      );
    });
  }

  getMarker(Shop shop) {
    var customer = shop.customerInStore;
    if (customer < 25) {
      return greenMarker;
    } else if (customer < 50) {
      return orangeMarker;
    }
    return redMarker;
  }

  loadCustomMarkers() async {
    var config = ImageConfiguration(devicePixelRatio: 2);
    greenMarker = await BitmapDescriptor.fromAssetImage(
        config, 'assets/images/marker_green.png');
    orangeMarker = await BitmapDescriptor.fromAssetImage(
        config, 'assets/images/marker_orange.png');
    redMarker = await BitmapDescriptor.fromAssetImage(
        config, 'assets/images/marker_red.png');
  }
}

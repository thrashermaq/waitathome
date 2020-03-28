import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waitathome/core/model/marker_data.dart';
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

  MarkerData selectedPin = MarkerData(
      shopName: 'Coop Bern',
      statusColor: Colors.orange,
      peopleCount: 37,
      queueCount: 0,
      isFavourite: false);

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    loadCustomMarkers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _markers,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
              setState(() {
                loadMarkers();
              });
            },
            onTap: (LatLng location) {
              // reset info widget
              setState(() {
                infoWidgetPosition = -100;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: CAMERA_ZOOM,
            ),
          ),
          InfoWidget(
            position: infoWidgetPosition,
            markerData: selectedPin,
          ),
        ],
      ),
    );
  }

  void loadMarkers() {
    addMarker(MarkerId('1'), LatLng(46.94709, 7.44944), greenMarker);
    addMarker(MarkerId('2'), LatLng(46.94850, 7.44784), greenMarker);
    addMarker(MarkerId('3'), LatLng(46.94971, 7.44700), orangeMarker);
    addMarker(MarkerId('4'), LatLng(46.94809, 7.44602), redMarker);
  }

  void addMarker(MarkerId id, LatLng latLng, BitmapDescriptor icon) {
    _markers.add(
      Marker(
        markerId: id,
        position: latLng,
        icon: icon,
        onTap: () {
          setState(() {
            // TODO: selectedPin = sourcePinInfo;
            infoWidgetPosition = 0;
          });
        },
      ),
    );
  }
}

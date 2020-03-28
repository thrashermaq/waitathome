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
  BitmapDescriptor markerIcon;

  final LatLng _center = START_LOCATION;
  Set<Marker> _markers = new Set();

  double pinPillPosition = -100;

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

    setCustomMapPin();
  }

  void setCustomMapPin() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/marker.png');
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
                _markers.add(Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(46.94809, 7.44744),
                  icon: markerIcon,
                  onTap: () {
                    setState(() {
                      // TODO: selectedPin = sourcePinInfo;
                      pinPillPosition = 0;
                    });
                  },
                ));
              });
            },
            onTap: (LatLng location) {
              // reset info widget
              setState(() {
                pinPillPosition = -100;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: CAMERA_ZOOM,
            ),
          ),
          InfoWidget(
            position: pinPillPosition,
            markerData: selectedPin,
          ),
        ],
      ),
    );
  }
}

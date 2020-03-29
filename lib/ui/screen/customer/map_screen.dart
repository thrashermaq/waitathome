import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';
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
    Permission.location.request().then((onValue) => print(onValue));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(),
          (selectedShop != null)
              ? InfoWidget(
                  position: infoWidgetPosition,
                  shopId: selectedShop.id,
                )
              : Container(),
        ],
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
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
    loadMarkers();
  }

  void loadMarkers() {
    print('Load markers');
    var shopService = Provider.of<ShopService>(context, listen: false);
    shopService.loadAll((shops) => addMarkers(shops));
  }

  void addMarkers(List<Shop> shops) {
    shops.forEach((shop) {
      print('Shop $shop');
      if (isValid(shop)) {
        print('Name ${shop.name}');
        print('addMarker ${shop.location}');
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(shop.id.toString()),
              position: LatLng(
                  shop.location.latitude ?? 0, shop.location.longitude ?? 0),
              icon: getMarker(shop),
              onTap: () {
                setState(() {
                  infoWidgetPosition = 0;
                  selectedShop = shop;
                });
              },
            ),
          );
        });
      }
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

  bool isValid(Shop shop) {
    return shop != null && shop.location != null;
  }
}

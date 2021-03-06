import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/info_widget.dart';

const double CAMERA_ZOOM = 15;
const LatLng START_LOCATION = LatLng(46.94367, 7.40598);

/// TODO: Package for search: https://pub.dev/packages/search_map_place
class MapScreen extends StatefulWidget {
  MapScreen({@required Key key});

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
    var shopService = Provider.of<ShopService>(context, listen: false);
    shopService.getShops().listen((snapshot) {
      List<Shop> shops = snapshot.documents.map((document) {
        var shop = Shop.fromJson(document.data);
        shop.id = document.documentID;
        return shop;
      }).toList();
      addMarkers(shops);
    });
  }

  void addMarkers(List<Shop> shops) {
    _markers.clear();
    shops.forEach((shop) {
      if (isValid(shop)) {
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
      }
    });
    // trigger rebuild
    setState(() {});
  }

  getMarker(Shop shop) {
    var limit = shop.limit;
    var customerInStore = shop.customerInStore;
    if (customerInStore < (limit / 2)) {
      return greenMarker;
    } else if (customerInStore < limit) {
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

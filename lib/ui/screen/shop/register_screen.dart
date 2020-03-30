import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/model/shop_identifier.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/save_button.dart';
import 'package:waitathome/ui/screen/shop/register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/shop/register';

  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  int shopLimit = 50;
  String selectedAddress = 'Please choose the address of your store';
  GeoPoint selectedGeoPoint = null;

  RegisterFormState() {
    Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((pos) {
      Geolocator()
          .placemarkFromCoordinates(pos.latitude, pos.longitude)
          .then((placemark) {
        if (placemark.isNotEmpty) {
          setState(() {
            selectedGeoPoint = new GeoPoint(pos.latitude, pos.longitude);
            selectedAddress =
                '${placemark[0].thoroughfare} ${placemark[0].subThoroughfare.toString()}, ${placemark[0].postalCode} ${placemark[0].locality}';
          });
        }
      });

      print('position loaded $pos');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            child: new Column(children: <Widget>[
              Image(
                image: AssetImage('assets/images/register_image.png'),
                height: 225,
                width: 225,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    _buildNameColumn(),
                    _buildEmailColumn(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: _buildLimitColumn(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: _buildPositionColumn(context),
                    ),
                  ],
                ),
              ),
              new SaveButton(
                label: 'Create',
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    var shopService =
                        Provider.of<ShopService>(context, listen: false);
                    shopService
                        .register(nameController.text, emailController.text,
                            selectedGeoPoint, shopLimit)
                        .then((ShopIdentifier shopIdentifier) {
                      print(
                          'shop saved with loginCode ${shopIdentifier.loginCode}');
                      Navigator.pushNamed(
                        context,
                        RegisterSuccessScreen.routeName,
                        arguments: shopIdentifier,
                      );
                    });
                  }
                },
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _showNumberPickerDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
              minValue: 1,
              maxValue: 1000,
              title: new Text('Pick a new limit'),
              initialIntegerValue: shopLimit);
        }).then((int value) {
      if (value != null) {
        setState(() => shopLimit = value);
      }
    });
  }

  ListTile _buildEmailColumn() {
    return new ListTile(
      leading: const Icon(
        Icons.email,
        color: Colors.orange,
      ), // shopping_cart
      title: new TextFormField(
        controller: emailController,
        decoration: new InputDecoration(
          hintText: 'Email (optional)',
        ),
      ),
    );
  }

  ListTile _buildNameColumn() {
    return new ListTile(
      leading: const Icon(
        Icons.account_circle,
        color: Colors.orange,
      ), // shopping_cart
      title: new TextFormField(
        controller: nameController,
        decoration: new InputDecoration(
          hintText: 'Name',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please insert a name';
          }
          return null;
        },
      ),
    );
  }

  ListTile _buildLimitColumn() {
    return new ListTile(
      leading: const Icon(
        Icons.people,
        color: Colors.orange,
      ), // shopping_cart
      title: Row(
        children: <Widget>[
          Text('Max.  '),
          GestureDetector(
            child: Text(
              shopLimit.toString(),
              style: TextStyle(
                  decoration: TextDecoration.underline, fontSize: 25.0),
            ),
            onTap: () => _showNumberPickerDialog(),
          ),
          Text('  customers allowed in store')
        ],
      ),
    );
  }

  ListTile _buildPositionColumn(BuildContext context) {
    return new ListTile(
      leading: const Icon(
        Icons.location_on,
        color: Colors.orange,
      ), // shopping_cart
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: new Text(this.selectedAddress)),
          FloatingActionButton(
            backgroundColor: Colors.orange[100],
            child: const Icon(
              Icons.map,
              color: Colors.deepOrangeAccent,
            ),
            elevation: 0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlacePicker(
                  apiKey: 'AIzaSyBug5lCh-t9AxVNFQM5wq-3bnq8SLRcWcA',
                  // Put YOUR OWN KEY here.
                  onPlacePicked: (result) {
                    var selectedLocation = result.geometry.location;
                    this.selectedAddress = result.formattedAddress;
                    this.selectedGeoPoint =
                        GeoPoint(selectedLocation.lat, selectedLocation.lng);

                    Navigator.of(context).pop();
                  },
                  initialPosition: initialPosition(),
                  useCurrentLocation: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng initialPosition() {
    if (selectedGeoPoint != null) {
      return LatLng(selectedGeoPoint.latitude, selectedGeoPoint.longitude);
    }
    return LatLng(46.94709, 7.44944);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

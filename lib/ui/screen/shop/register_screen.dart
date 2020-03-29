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
  String selectedAddress = ""; // TODO start with current position
  GeoPoint selectedGeoPoint = null;

  Position position = null;

  @override
  Widget build(BuildContext context) {
    print("run build method");
    Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((pos) {
      position = pos;

      Geolocator()
          .placemarkFromCoordinates(pos.latitude, pos.longitude)
          .then((placemark) {
            print("placemark loaded");

        if (placemark.isNotEmpty) {
          selectedAddress =
              "${placemark[0].thoroughfare} ${placemark[0].subThoroughfare.toString()}, ${placemark[0].postalCode} ${placemark[0].locality}";
          print(selectedAddress);
        }
      });

      print("position loaded $pos");
    });

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
              new SaveButton(
                label: "Speichern",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    var shopService =
                        Provider.of<ShopService>(context, listen: false);
                    shopService
                        .register(nameController.text, emailController.text,
                            selectedGeoPoint, shopLimit)
                        .then((ShopIdentifier shopIdentifier) {
                      print(
                          "shop saved with loginCode ${shopIdentifier.loginCode}");
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
              title: new Text("Pick a new price"),
              initialIntegerValue: shopLimit);
        }).then((int value) {
      if (value != null) {
        setState(() => shopLimit = value);
      }
    });
  }

  ListTile _buildEmailColumn() {
    return new ListTile(
      leading: const Icon(Icons.email), // shopping_cart
      title: new TextFormField(
        controller: emailController,
        decoration: new InputDecoration(
          hintText: "Email (optional)",
        ),
      ),
    );
  }

  ListTile _buildNameColumn() {
    return new ListTile(
      leading: const Icon(Icons.account_circle), // shopping_cart
      title: new TextFormField(
        controller: nameController,
        decoration: new InputDecoration(
          hintText: "Name",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Bitte geben Sie einen Namen an';
          }
          return null;
        },
      ),
    );
  }

  ListTile _buildLimitColumn() {
    return new ListTile(
      leading: const Icon(Icons.av_timer), // shopping_cart
      title: Row(
        children: <Widget>[
          Text("Max. "),
          GestureDetector(
            child: Text(
              shopLimit.toString(),
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () => _showNumberPickerDialog(),
          ),
          Text(" Kunden im Laden erlaubt")
        ],
      ),
    );
  }

  ListTile _buildPositionColumn(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.location_on), // shopping_cart
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: new Text(this.selectedAddress)),
          FloatingActionButton(
            backgroundColor: Colors.black26,
            child: const Icon(Icons.map),
            elevation: 0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlacePicker(
                  apiKey: "AIzaSyBug5lCh-t9AxVNFQM5wq-3bnq8SLRcWcA",
                  // Put YOUR OWN KEY here.
                  onPlacePicked: (result) {
                    var selectedLocation = result.geometry.location;
                    this.selectedAddress = result.formattedAddress;
                    this.selectedGeoPoint =
                        GeoPoint(selectedLocation.lat, selectedLocation.lng);

                    Navigator.of(context).pop();
                  },
                  initialPosition:
                      LatLng(position.latitude, position.longitude),
                  useCurrentLocation: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

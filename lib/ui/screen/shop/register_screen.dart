import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/custom_button.dart';

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
  String selectedAddress = ""; // TODO start with current position
  GeoPoint selectedGeoPoint = null;

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
              nameColumn(),
              emailColumn(),
              positionColumn(context),
              new CustomButton(
                label: "Speichern",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    var shopService =
                        Provider.of<ShopService>(context, listen: false);
                    shopService
                        .register(nameController.text, emailController.text)
                        .then((shopId) {
                      print("shop saved with id $shopId");
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

  ListTile emailColumn() {
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

  ListTile nameColumn() {
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

  ListTile positionColumn(BuildContext context) {
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
                    print("place picked ${selectedLocation}");
                    print("place picked ${result.formattedAddress}");
                    print("place picked ${result.adrAddress}");
                    print("place picked ${result.icon}");
                    print("place picked ${result.name}");
                    this.selectedAddress = result.formattedAddress;
                    this.selectedGeoPoint =
                        GeoPoint(selectedLocation.lat, selectedLocation.lng);

                    Navigator.of(context).pop();
                  },
                  initialPosition: LatLng(46.94709, 7.44944),
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

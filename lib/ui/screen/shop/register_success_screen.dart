import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waitathome/core/model/shop_identifier.dart';
import 'package:waitathome/ui/components/save_button.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  static const routeName = '/registerSuccess';

  @override
  Widget build(BuildContext context) {
    final ShopIdentifier shopIdentifier =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/register_success.png'),
                height: 260,
                width: 260,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Logincode",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                shopIdentifier.loginCode,
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    "Schreiben Sie sich den Login Code auf und legen Sie den Zettel an einem für alle Mitarbeiter erreichbaren Ort ab.",
                  )),
              SaveButton(
                  label: "Kunden zählen starten",
                  onPressed: () => Navigator.pushNamed(
                        context,
                        ShopScreen.routeName,
                        arguments: shopIdentifier.shopId,
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:waitathome/ui/screen/customer/map_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_login.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Who are you?',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 48.0, bottom: 16.0),
                  child: _IntroScreenButton(
                    label: 'Shop associate',
                    imagePath: 'assets/images/intro_shop.png',
                    onPressed: () {
                      Navigator.pushNamed(context, ShopLoginScreen.routeName);
                    },
                  ),
                ),
                _IntroScreenButton(
                  label: 'Customer',
                  imagePath: 'assets/images/intro_customer.png',
                  onPressed: () {
                    Navigator.pushNamed(context, MapScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TODO create clean separate widget in components directory when we decided for a design
class _IntroScreenButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  _IntroScreenButton({this.label, this.imagePath, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.teal,
      textColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(imagePath),
            height: 115,
            width: 115,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

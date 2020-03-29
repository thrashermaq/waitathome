import 'package:flutter/material.dart';
import 'package:waitathome/ui/screen/customer/map_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_login.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    'Who are you?',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: FlatButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    Navigator.pushNamed(context, ShopLoginScreen.routeName);
                  },
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/intro_shop.png'),
                        height: 115,
                        width: 115,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Shop associate",
                            style: TextStyle(
                              fontSize: 36.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 16.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: FlatButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    Navigator.pushNamed(context, MapScreen.routeName);
                  },
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/intro_customer.png'),
                        height: 115,
                        width: 115,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Customer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroScreenButton extends StatelessWidget {
  IntroScreenButton({this.label, this.onPressed});

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: double.infinity,
          color: Color.fromARGB(255, 191, 231, 226),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              this.label,
              style: TextStyle(
                fontSize: 48.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

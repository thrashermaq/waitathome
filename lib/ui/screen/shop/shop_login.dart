import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/screen/shop/register_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  static const routeName = '/shopLogin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: LoginScreen(),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin;

  @override
  void initState() {
    _pin = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Enter your code',
            style: TextStyle(
              fontSize: 48.0,
              height: 1.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48.0, bottom: 48.0),
          child: PinCodeTextField(
            length: 6,
            obsecureText: false,
            animationType: AnimationType.fade,
            shape: PinCodeFieldShape.box,
            animationDuration: Duration(milliseconds: 150),
            borderRadius: BorderRadius.circular(6),
            fieldHeight: 50,
            textStyle: TextStyle(
              fontSize: 32.0,
              fontStyle: FontStyle.normal,
            ),
            backgroundColor: Colors.transparent,
            onCompleted: (value) {
              setState(() {
                _pin = value;
              });
            },
            onChanged: (value) {},
          ),
        ),
        FlatButton(
          child: Text(
            'Login',
          ),
          color: Colors.teal,
          disabledColor: Colors.grey,
          onPressed: onPressed(),
        ),
        GestureDetector(
          child: Text("Register", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
          onTap: () {
            Navigator.pushNamed(context, RegisterScreen.routeName);
          },
        )
      ],
    );
  }

  Function onPressed() {
    if (_pin == null) {
      return null;
    }
    return () {
      Provider.of<ShopService>(context, listen: false).login(_pin, (shopId) {
        Navigator.pushNamed(context, ShopScreen.routeName);
      }, () {
        setState(() {
          _pin = null;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Login failed"),
              content: new Text("Check if the entered pin is correct."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    };
  }
}

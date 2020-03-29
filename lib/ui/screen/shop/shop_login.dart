import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
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

  bool hasError = false;
  TextEditingController controller = TextEditingController(text: "");

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
            autofocus: true,
            controller: controller,
            highlight: true,
            highlightColor: Colors.blue,
            defaultBorderColor: Colors.black,
            hasTextBorderColor: Colors.green,
            maxLength: 6,
            hasError: hasError,
            onTextChanged: (text) {
              setState(() {
                hasError = false;
              });
            },
            onDone: (text) {
              setState(() {
                _pin = text;
              });
            },
            wrapAlignment: WrapAlignment.spaceAround,
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: 16.0),
            highlightAnimationBeginColor: Colors.black,
            highlightAnimationEndColor: Colors.white12,
            keyboardType: TextInputType.number,
            pinBoxWidth: 40,
            pinBoxHeight: 40,
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
    var loginPin = _pin;
    return () {
      Provider.of<ShopService>(context, listen: false).login(loginPin, (shopId) {
        setState(() {
          controller.text = '';
          _pin = null;
        });
        Navigator.pushNamed(context, ShopScreen.routeName);
      }, () {
        setState(() {
          controller.text = '';
          _pin = null;
          hasError = true;
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

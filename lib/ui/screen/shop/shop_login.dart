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
  bool _pinError = false;
  TextEditingController _controller = TextEditingController(text: '');

  @override
  void initState() {
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
        Image(
          image: AssetImage('assets/images/vault_bank_safe.png'),
          height: 300,
          width: 300,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 48.0, bottom: 48.0),
          child: PinCodeTextField(
            pinBoxRadius: 5,
            autofocus: true,
            controller: _controller,
            highlight: true,
            highlightColor: Colors.orange[300],
            defaultBorderColor: Colors.black,
            hasTextBorderColor: Colors.orange,
            maxLength: 6,
            hasError: _pinError,
            onTextChanged: (text) {
              setState(() {
                _pinError = false;
              });
            },
            onDone: (text) {
              Provider.of<ShopService>(context, listen: false).login(text,
                  (shopId) {
                setState(() {
                  _controller.text = '';
                });
                Navigator.pushNamed(
                  context,
                  ShopScreen.routeName,
                  arguments: shopId,
                );
              }, () {
                setState(() {
                  _controller.text = '';
                  _pinError = true;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text('Login failed'),
                      content: new Text('Check if the entered pin is correct.'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
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
        GestureDetector(
          child: Text('Register new store',
              style: TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
                color: Colors.deepOrangeAccent,
              )),
          onTap: () {
            Navigator.pushNamed(
              context,
              RegisterScreen.routeName,
            );
          },
        ),
      ],
    );
  }
}

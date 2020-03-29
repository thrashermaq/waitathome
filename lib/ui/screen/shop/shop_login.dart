import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';

class ShopLoginScreen extends StatelessWidget {
  static const routeName = '/shopLogin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
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
                padding: const EdgeInsets.only(top: 48.0, bottom: 100.0),
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
                    print(value);
                    Provider.of<ShopService>(context, listen: false).login(value, (shopId) {
                      // TODO go to expected page
                      print('logged in with $shopId');
                    }, () {
                      // TODO error handling
                      print('login failed');
                    });
                  },
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

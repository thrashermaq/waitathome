import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('Shop'),
              onPressed: () {},
            ),
            FlatButton(
              child: Text('Customer'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

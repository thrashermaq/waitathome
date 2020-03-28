import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  static const routeName = '/shop';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Shop'),
        ),
      ),
    );
  }
}

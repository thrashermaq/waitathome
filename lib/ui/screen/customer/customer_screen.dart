import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  static const routeName = '/customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Customer'),
        ),
      ),
    );
  }
}

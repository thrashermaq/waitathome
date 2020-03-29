import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterSuccessScreen extends StatelessWidget {
  static const routeName = '/registerSuccess';

  @override
  Widget build(BuildContext context) {

    final String loginCode = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Text("HALLO $loginCode"),
        ),
      ),
    );
  }
}
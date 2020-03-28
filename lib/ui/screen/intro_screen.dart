import 'package:flutter/material.dart';
import 'package:waitathome/ui/components/custom_button.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              label: 'Shop',
              onPressed: () {},
            ),
            CustomButton(
              label: 'Customer',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

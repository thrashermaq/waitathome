import 'package:flutter/material.dart';
import 'package:waitathome/ui/components/custom_button.dart';
import 'package:waitathome/ui/screen/customer/customer_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

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
              onPressed: () {
                Navigator.pushNamed(context, ShopScreen.routeName);
              },
            ),
            CustomButton(
              label: 'Customer',
              onPressed: () {
                Navigator.pushNamed(context, CustomerScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

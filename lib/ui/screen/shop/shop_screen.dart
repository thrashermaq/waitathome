import 'package:flutter/material.dart';
import 'package:waitathome/ui/components/customer_tracking.dart';

class ShopScreen extends StatelessWidget {
  static const routeName = '/shop';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomerTracking(),
      ),
    );
  }
}

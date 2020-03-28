import 'package:flutter/material.dart';
import 'package:waitathome/ui/screen/customer/customer_screen.dart';
import 'package:waitathome/ui/screen/customer/map_screen.dart';
import 'package:waitathome/ui/screen/intro_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

void main() => runApp(MyApp());

// TODO: Add key to Ios: https://developers.google.com/maps/documentation/ios-sdk/get-api-key
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        IntroScreen.routeName: (context) => IntroScreen(),
        CustomerScreen.routeName: (context) => CustomerScreen(),
        ShopScreen.routeName: (context) => ShopScreen(),
        MapScreen.routeName: (context) => MapScreen(),
      },
    );
  }
}

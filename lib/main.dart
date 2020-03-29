import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/screen/customer/map_screen.dart';
import 'package:waitathome/ui/screen/intro_screen.dart';
import 'package:waitathome/ui/screen/shop/register_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_login.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

void main() => runApp(MyApp());

// TODO: Add key to Ios: https://developers.google.com/maps/documentation/ios-sdk/get-api-key
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ShopService>(create: (_) => new ShopService()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          ShopScreen.routeName: (context) => ShopScreen(),
          ShopLoginScreen.routeName: (context) => ShopLoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          MapScreen.routeName: (context) => MapScreen(key: UniqueKey()),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/screen/customer/customer_screen.dart';
import 'package:waitathome/ui/screen/intro_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ShopService>(create: (_) => new ShopService())
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          CustomerScreen.routeName: (context) => CustomerScreen(),
          ShopScreen.routeName: (context) => ShopScreen(),
        },
      ),
    );
  }
}

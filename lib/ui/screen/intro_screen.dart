import 'package:flutter/material.dart';
import 'package:waitathome/ui/components/custom_button.dart';
import 'package:waitathome/ui/components/intro_button.dart';
import 'package:waitathome/ui/screen/customer/map_screen.dart';
import 'package:waitathome/ui/screen/shop/shop_login.dart';

class IntroScreen extends StatefulWidget {
  static const routeName = '/intro';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool isCustomer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: _buildIntroButtons(context),
                ),
                CustomButton(
                  label:
                      'Continue as ${isCustomer ? 'Customer' : 'Shop Associate'}',
                  disabled: false,
                  onPressed: () {
                    var route = isCustomer
                        ? MapScreen.routeName
                        : ShopLoginScreen.routeName;
                    Navigator.pushNamed(context, route);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: 100,
            width: 100,
          ),
        ),
        Text(
          'WaitAtHome',
          style: TextStyle(
            fontSize: 35.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Reduces the waiting time in front of your shops!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Column _buildIntroButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        IntroButton(
          label: 'Customer',
          description:
              'See the capacity of your favourite shops and wait at home.',
          imagePath: 'assets/images/intro_customer.png',
          active: isCustomer,
          onPressed: () {
            setState(() {
              isCustomer = true;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        IntroButton(
          label: 'Shop associate',
          description: 'Register your shop and start counting your customers.',
          imagePath: 'assets/images/intro_shop.png',
          active: !isCustomer,
          onPressed: () {
            setState(() {
              isCustomer = false;
            });
          },
        ),
      ],
    );
  }
}

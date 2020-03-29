import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waitathome/core/service/shop_service.dart';
import 'package:waitathome/ui/components/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/shop/register';

  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: new Form(
          key: _formKey,
          child: new Column(children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.account_circle), // shopping_cart
              title: new TextFormField(
                controller: nameController,
                decoration: new InputDecoration(
                  hintText: "Name",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte geben Sie einen Namen an';
                  }
                  return null;
                },
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.email), // shopping_cart
              title: new TextFormField(
                controller: emailController,
                decoration: new InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            new CustomButton(
              label: "Speichern",
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var shopService =
                      Provider.of<ShopService>(context, listen: false);
                  shopService.register(nameController.text, emailController.text).then((shopId) {
                    print("shop saved with id $shopId");
                  });
                }
              },
            )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

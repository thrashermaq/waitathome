import 'package:flutter/material.dart';

/// TODO: Remove. Just for showcase.
class CustomButton extends StatelessWidget {
  CustomButton({this.label, this.onPressed});

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(label),
      onPressed: onPressed,
    );
  }
}

import 'package:flutter/material.dart';

/// TODO: Remove. Just for showcase.
class CustomButton extends StatelessWidget {
  CustomButton({this.label, this.onPressed});

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: RaisedButton(
        child: Text(
          this.label,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        color: Colors.blueAccent,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.label, this.onPressed, this.disabled});

  final String label;
  final Function() onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      minWidth: double.infinity,
      child: RaisedButton(
        color: Colors.orangeAccent,
        textColor: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: Text(label),
        onPressed: disabled ? null : onPressed,
      ),
    );
  }
}

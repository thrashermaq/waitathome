import 'package:flutter/material.dart';

class CountButton extends StatelessWidget {
  CountButton({this.label, this.onPressed});

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 100,
      height: 100,
      child: FlatButton(
        color: Colors.grey[200],
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 50,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

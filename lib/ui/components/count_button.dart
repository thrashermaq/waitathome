import 'package:flutter/material.dart';

class CountButton extends StatelessWidget {
  CountButton({this.label, this.disabled, this.onPressed});

  final String label;
  final bool disabled;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 100,
      height: 100,
      child: FlatButton(
        disabledColor: Colors.orange[100],
        color: Colors.orange,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
          ),
        ),
        onPressed: disabled ? null : onPressed,
      ),
    );
  }
}

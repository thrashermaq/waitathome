import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  SaveButton({this.label, this.onPressed});

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

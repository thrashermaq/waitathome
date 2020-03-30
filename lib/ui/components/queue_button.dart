import 'package:flutter/material.dart';

class QueueButton extends StatelessWidget {
  QueueButton({this.label, this.onPressed, this.active, this.disabled});

  final String label;
  final Function() onPressed;
  final bool active;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      disabledColor: Colors.orange[100],
      color: active ? Colors.deepOrangeAccent : Colors.orange,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: disabled ? null : onPressed,
    );
  }
}

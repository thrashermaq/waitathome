import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapacityDialog extends StatefulWidget {
  CapacityDialog(this.currentLimit, this.onSave);

  final Function(int list) onSave;
  final int currentLimit;

  @override
  _CapacityDialogState createState() => _CapacityDialogState();
}

class _CapacityDialogState extends State<CapacityDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController customController =
        TextEditingController(text: widget.currentLimit.toString());
    return AlertDialog(
      title: Text('Shop capacity'),
      content: TextField(
        decoration: InputDecoration(
          labelText: 'Limit',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ], // O
        controller: customController,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
          textColor: Colors.grey[600],
        ),
        FlatButton(
          child: Text('Save'),
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: () {
            var value = customController.text.toString();
            final newLimit =
                value != '' ? int.parse(value) : widget.currentLimit;
            widget.onSave(newLimit);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

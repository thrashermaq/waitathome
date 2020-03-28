import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomerTracking extends StatefulWidget {
  @override
  _CustomerTrackingState createState() => _CustomerTrackingState();
}

class _CustomerTrackingState extends State<CustomerTracking> {
  int customers = 0;
  int limit = 10;
  int queue = 0;
  String storeName = 'Coop Europaplatz';

  var activeButton = [false, false, false];
  bool queueEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$storeName',
          style: TextStyle(
            fontSize: 44,
          ),
        ),
        Text(
          '$customers',
          style: TextStyle(
            fontSize: 200,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildCountButton('-', () {
              decreaseCustomerCount();
            }),
            SizedBox(
              width: 20,
            ),
            buildCountButton('+', () {
              increaseCustomerCount();
            }),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Warteschlange',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildQueueButton(0, 'Kurz', 5),
              buildQueueButton(1, 'Mittel', 10),
              buildQueueButton(2, 'Lang', 15),
            ],
          ),
        ),
        InkWell(
          child: Text(
            'Ladenkapazität anpassen',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          onTap: () {
            createDialog(context).then((newLimit) {
              if (customers > newLimit) {
                setState(() {
                  customers = newLimit;
                  queueEnabled = true;
                });
              } else {
                setState(() {
                  queueEnabled = false;
                  activeButton = [false, false, false];
                });
              }
              setState(() {
                limit = newLimit;
              });
            });
          },
        ),
      ],
    );
  }

  Future<int> createDialog(BuildContext context) {
    TextEditingController customController =
        TextEditingController(text: limit.toString());

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ladenkapazität'),
            content: TextField(
              decoration: InputDecoration(
                labelText: "Geschäftskapazität",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ], // O
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Speichern'),
                onPressed: () {
                  final newLimit = int.parse(customController.text.toString());
                  Navigator.of(context).pop(newLimit);
                },
              ),
            ],
          );
        });
  }

  ButtonTheme buildCountButton(String text, VoidCallback onPressedAction) {
    return ButtonTheme(
      minWidth: 100,
      height: 100,
      child: FlatButton(
        color: Colors.grey[200],
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 50,
          ),
        ),
        onPressed: onPressedAction,
      ),
    );
  }

  FlatButton buildQueueButton(int index, String text, int numberOfPeople) {
    return FlatButton(
      disabledColor: Colors.grey[200],
      color: activeButton[index] ? Colors.red[300] : Colors.grey[300],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text(text),
      onPressed: queueEnabled
          ? () {
              setQueue(numberOfPeople);
              setActiveButton(index);
            }
          : null,
    );
  }

  void decreaseCustomerCount() {
    if (customers > 0 && queue == 0) {
      setState(() {
        customers = customers - 1;
      });
    }
    if (customers < limit && queueEnabled) {
      setState(() {
        queueEnabled = false;
      });
    }
  }

  void increaseCustomerCount() {
    if (customers < limit) {
      setState(() {
        customers = customers + 1;
      });
    }
    if (customers == limit) {
      setState(() {
        queueEnabled = true;
      });
    }
  }

  void setQueue(int queueSize) {
    if (queue == queueSize) {
      queueSize = 0;
    }
    setState(() {
      queue = queueSize;
    });
  }

  void setActiveButton(int index) {
    if (activeButton[index]) {
      setState(() {
        activeButton = [false, false, false];
      });
    } else {
      setState(() {
        activeButton = [false, false, false];
        activeButton[index] = true;
      });
    }
  }
}

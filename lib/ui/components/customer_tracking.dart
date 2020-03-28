import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomerTracking extends StatefulWidget {
  @override
  _CustomerTrackingState createState() => _CustomerTrackingState();
}

class _CustomerTrackingState extends State<CustomerTracking> {
  int customers = 0;
  int limit = 10;
  int queue = 0;

  var activeButton = [false, false, false];
  bool queueEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Kundentracking',
          style: TextStyle(
            fontSize: 44,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$customers',
              style: TextStyle(
                fontSize: 76,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '($queue)',
              style: TextStyle(
                fontSize: 36,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              child: Text('-'),
              onPressed: () {
                decreaseCustomerCount();
              },
            ),
            FlatButton(
              color: Colors.red,
              child: Text('+'),
              onPressed: () {
                increaseCustomerCount();
              },
            )
          ],
        ),
        Text('Warteschlange'),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildQueueButton(0, '5', 5),
              buildQueueButton(1, '10', 10),
              buildQueueButton(2, '15+', 15),
            ],
          ),
        )
      ],
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

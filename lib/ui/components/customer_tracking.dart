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
            Text('($queue)'),
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                color: Colors.grey[200],
                child: Text('5'),
                onPressed: queueEnabled
                    ? () {
                        setQueue(5);
                      }
                    : null,
              ),
              FlatButton(
                color: Colors.grey[200],
                child: Text('10'),
                onPressed: queueEnabled
                    ? () {
                        setQueue(10);
                      }
                    : null,
              ),
              FlatButton(
                color: Colors.grey[200],
                child: Text('15+'),
                onPressed: queueEnabled
                    ? () {
                        setQueue(15);
                      }
                    : null,
              ),
            ],
          ),
        )
      ],
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
    setState(() {
      queue = queueSize;
    });
  }
}

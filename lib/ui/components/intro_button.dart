import 'package:flutter/material.dart';

class IntroButton extends StatelessWidget {
  IntroButton(
      {this.label,
      this.description,
      this.active,
      this.imagePath,
      this.onPressed});

  final String label;
  final String description;
  final String imagePath;
  final Function() onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: active ? Colors.white : Colors.grey[200],
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: active ? Colors.orange[100] : Colors.grey[200],
            width: active ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Image(
                image: AssetImage(imagePath),
                height: 90,
                width: 90,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 15.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

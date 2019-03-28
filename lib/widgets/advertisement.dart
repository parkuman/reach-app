import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2.0,
      child: Container(
        color: Colors.lightBlue,
        height: 250.0,
        child: Center(
          child: Text('ADVERTISEMENT'),
        ),
      ),
    );
  }
}

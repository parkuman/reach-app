import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  Advertisement({this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        color: color,
        height: height,
        width: width,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/clark_ad_1.jpg'),
            ),
          ),
          // child: Text('ADVERTISEMENT'),
        ),
      ),
    );
  }
}

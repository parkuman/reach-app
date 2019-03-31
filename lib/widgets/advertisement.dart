import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String imagePath;
  final Widget child;
  Advertisement({this.height, this.width, this.color, this.imagePath, this.child});

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
              image: AssetImage(imagePath),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

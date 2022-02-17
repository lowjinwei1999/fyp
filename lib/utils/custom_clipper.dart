import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {
    Path path =  Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 120);
    path.lineTo(0, size.height);
    return path;
    }
  
    @override
    bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
      return true;
  }
  
}
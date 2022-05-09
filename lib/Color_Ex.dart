import 'package:flutter/material.dart';
class Ex_Color
{
  static const Color primary = Color(0xff6d1aa4);
  static const Color secondary = Color(0xff9c3bab);
  static const Color background = Color(0xfff5f5f5);

  static const LinearGradient gradientMain = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerLeft,
    colors: [primary,secondary]
  );
}

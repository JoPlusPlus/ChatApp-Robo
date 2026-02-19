import 'package:flutter/material.dart';

enum AppColors {
  // Primary Colors
  primary(Color(0xff7c71f4)),
  primaryLight(Color(0xff8176f4)),

  // Background Colors
  backgroundStart(Color(0xffeeeff8)),
  backgroundEnd(Color(0xfff3f4f9)),
  white(Color(0xFFFFFFFF)),

  // Text Colors
  textPrimary(Color(0xFF000000)),
  textSecondary(Color(0xFF666666)),
  textGrey(Color(0xFF9E9E9E)),

  // UI Elements like shadow, border, etc.
  grey(Color(0xFF9E9E9E)),
  shadow(Color(0x1A000000)),
  border(Color(0xFFE0E0E0)),

  // Tag Colors
  tagRed(Color(0xFFFF0000)),
  tagOrange(Color(0xFFFFA500)),
  tagYellow(Color(0xFFFFD700)),
  tagGreen(Color.fromARGB(255, 96, 189, 96)),
  tagBlue(Color(0xFF0000FF)),
  tagIndigo(Color(0xFF4B0082)),
  tagViolet(Color(0xFF8B00FF));

  const AppColors(this.color);

  final Color color;
}

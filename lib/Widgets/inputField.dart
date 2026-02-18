import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {

  final String hintText;
  final bool isPassword;

  const Inputfield({
    super.key,
    required this.hintText,
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
        return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    );
  }
  }
import 'package:flutter/material.dart';

class LoginInputDecoration {
  static InputDecoration inputDecoration(
      {required String hintText,
      required String labelText,
      IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      alignLabelWithHint: true,
      hintStyle: TextStyle(color: Colors.grey[500]),
      labelStyle: TextStyle(color: Colors.grey[500]),
      // suffixIcon: Icon(suffixIcon, color: Colors.grey[500]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

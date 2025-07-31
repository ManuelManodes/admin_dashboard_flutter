import 'package:flutter/material.dart';

class CustomInputs {
  static InputDecoration loginInputDecoration({
    required String hint,
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
      ),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
    );
  }
}

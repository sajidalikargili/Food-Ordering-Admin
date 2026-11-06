import 'package:flutter/material.dart';
Widget buildLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );
}
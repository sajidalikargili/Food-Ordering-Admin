import 'package:flutter/cupertino.dart';

class QuickActionModel {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  QuickActionModel({
    required this.title,
    required this.icon,
    required this.color,
    required this.route
  });
}
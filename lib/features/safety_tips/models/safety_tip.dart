import 'package:flutter/material.dart';

class SafetyTip {
  final IconData icon;
  final String title;
  final String priority;
  final Color priorityColor;
  final String description;

  const SafetyTip({
    required this.icon,
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.description,
  });
}
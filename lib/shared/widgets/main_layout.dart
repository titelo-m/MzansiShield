import 'package:flutter/material.dart';
import 'top_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopNavBar(currentPath: currentPath),
          Expanded(child: child),
        ],
      ),
    );
  }
}
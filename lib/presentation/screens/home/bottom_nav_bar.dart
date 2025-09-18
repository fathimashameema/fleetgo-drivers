import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('bottom nav bar'),
      ),
      // bottomNavigationBar: BottomNavigationBar.new
    );
  }
}

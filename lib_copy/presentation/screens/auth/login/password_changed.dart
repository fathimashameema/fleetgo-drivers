import '../../../../resources/images/images.dart';
import 'package:flutter/material.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              TImages.checkMark,
              width: screenWidth * 0.7,
            ),
            Text(
              'Password changed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Password changed successfully!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

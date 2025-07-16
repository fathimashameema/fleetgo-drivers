import '../../resources/colors/colors.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Join the Fast Lane to ',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                TextSpan(
                  text: 'Financial ',
                  style: const TextStyle().copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: TColors.headingTexts,
                    fontFamily: 'adlam',
                  ),
                ),
                TextSpan(
                  text: 'Freedom!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

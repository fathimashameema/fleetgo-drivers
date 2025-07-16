import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(children: [
              TextSpan(
                text: 'Join the fast lane to ',
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
                text: 'freedom',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ]),
          ),
        )
      ],
    );
  }
}

import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class CompleteProfileSubheading extends StatelessWidget {
  final String subHeading;
  const CompleteProfileSubheading({
    super.key, required this.subHeading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_rounded,
          size: 20,
          color: TColors.themeGreen,
        ),
        const SizedBox(width: 13),
         Text(
          subHeading,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  final Color? color;
  const CircularIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: color ?? TColors.textWhite,
          strokeWidth: 1,
        ));
  }
}

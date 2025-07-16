import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class VehicleNameChip extends StatelessWidget {
  final String vehicle;
  final bool isSelected;
  const VehicleNameChip({
    super.key,
    required this.vehicle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TColors.headingTexts.withAlpha(74),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? TColors.headingTexts : Colors.transparent)),
      alignment: Alignment.center,
      child: Text(
        vehicle,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

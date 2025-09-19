import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      HugeIcons.strokeRoundedHome04,
      HugeIcons.strokeRoundedNotification01,
      HugeIcons.strokeRoundedNote,
      HugeIcons.strokeRoundedMessage01,
      HugeIcons.strokeRoundedWallet03,
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Theme.of(context).highlightColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            final isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 300),
                tween: ColorTween(
                  begin: Theme.of(context).primaryColorLight,
                  end: isSelected
                      ? TColors.headingTexts
                      : Theme.of(context).primaryColorLight,
                ),
                builder: (context, color, child) {
                  return HugeIcon(
                    icon: icons[index],
                    size: 24,
                    color: color!,
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

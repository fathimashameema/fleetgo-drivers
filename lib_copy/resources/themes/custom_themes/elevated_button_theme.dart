import '../../colors/colors.dart';
import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: TColors.textWhite,
          backgroundColor: TColors.headingTexts,
          disabledBackgroundColor: TColors.headingTexts,
          disabledForegroundColor: TColors.headingTexts,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400)));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: TColors.textWhite,
          backgroundColor: TColors.headingTexts,
          disabledBackgroundColor: TColors.headingTexts,
          disabledForegroundColor: TColors.headingTexts,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400)));
}

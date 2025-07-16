
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/themes/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TSnackBarTheme {
  TSnackBarTheme._();

  static SnackBarThemeData lightSnackBarTheme = SnackBarThemeData(
      backgroundColor: TColors.headingTexts,
      elevation: 3,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentTextStyle: TTexttheme.lightTextTheme.bodyMedium,
      insetPadding: const EdgeInsets.symmetric(horizontal: 5));
  static SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
      backgroundColor: TColors.headingTexts,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentTextStyle: TTexttheme.darkTextTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.symmetric(horizontal: 5));
}

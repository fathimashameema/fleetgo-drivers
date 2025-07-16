import '../../colors/colors.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';

class TInputDecorationTheme {
  TInputDecorationTheme._();

  static InputDecorationTheme lightInputdecorationTheme = InputDecorationTheme(
    focusColor: TColors.liightGrey,
    hintStyle: TTexttheme.lightTextTheme.titleMedium,
    contentPadding: const EdgeInsets.all(12),
    labelStyle: TTexttheme.lightTextTheme.titleMedium,
    outlineBorder: BorderSide(color: TColors.grey),
    filled: true,
    fillColor: Colors.transparent,
    suffixIconColor: TColors.grey,
    prefixIconColor: TColors.grey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: TColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: TColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: TColors.darkgGey,
      ),
    ),
  );

  static InputDecorationTheme darkInputdecorationTheme = InputDecorationTheme(
    hintStyle: TTexttheme.darkTextTheme.titleMedium,

    contentPadding: const EdgeInsets.all(12),
    labelStyle: TTexttheme.darkTextTheme.titleMedium,
    focusColor: TColors.darkgGey,

    filled: true,
    fillColor: Colors.transparent, // Transparent background
    suffixIconColor: TColors.grey,
    prefixIconColor: TColors.grey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: TColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: TColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: TColors.liightGrey),
    ),
  );
}

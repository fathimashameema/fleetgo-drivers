import '../../colors/colors.dart';
import 'package:flutter/material.dart';

class TTexttheme {
  TTexttheme._();
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'adlam',
    ),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: TColors.headingTexts,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelLarge: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: TColors.headingTexts,
      decoration: TextDecoration.underline,
      decorationColor: TColors.headingTexts,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  );
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontFamily: 'adlam',
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: TColors.headingTexts,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    labelLarge: const TextStyle().copyWith(
      fontFamily: 'arimo',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: TColors.headingTexts,
      decoration: TextDecoration.underline,
      decorationColor: TColors.headingTexts,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );
}

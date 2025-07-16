import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class TAlertDialogueTheme {
  TAlertDialogueTheme._();
  static DialogTheme lightAlertDialogue = DialogTheme(
    backgroundColor: TColors.textWhite,
    titleTextStyle: TextStyle(
      color: TColors.textBlack,
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    contentTextStyle: TextStyle(
      color: TColors.textBlack,
      fontSize: 15,
    ),
  );
  static DialogTheme darkAlertDialogue = DialogTheme(
    backgroundColor: TColors.textBlack,
    titleTextStyle: TextStyle(
      color: TColors.textWhite,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    contentTextStyle: TextStyle(
      color: TColors.textWhite,
      fontSize: 15,
    ),
  );
}

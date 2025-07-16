
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/themes/custom_themes/icons_theme.dart';
import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: TColors.transparent,
    toolbarHeight: 80,
    titleSpacing: 2,
    iconTheme: TIconsTheme.lightIconTheme,
  );
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: TColors.transparent,
    toolbarHeight: 80,
    titleSpacing: 2,
    iconTheme: TIconsTheme.darkIconTheme,
  );
}

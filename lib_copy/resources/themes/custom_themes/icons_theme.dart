import '../../colors/colors.dart';
import 'package:flutter/material.dart';

class TIconsTheme {
  TIconsTheme._();

  static IconThemeData lightIconTheme = IconThemeData(
    size: 15,
    color: TColors.textBlack,
  );
  static IconThemeData darkIconTheme = IconThemeData(
    size: 15,
    color: TColors.textWhite,
  );
}

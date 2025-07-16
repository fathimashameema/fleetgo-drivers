import '../colors/colors.dart';
import 'package:flutter/material.dart';

class TIcons {
  TIcons._();
  static Widget backButton = const Padding(
    padding: EdgeInsets.only(left: 20.0),
    child: Icon(Icons.arrow_back_ios_new),
  );

  static Widget checkMark = Icon(
    Icons.check,
    color: TColors.headingTexts,
    size: 20,
  );
  static Widget dashMark = Icon(
    Icons.remove,
    color: TColors.headingTexts,
    size: 20,
  );
}

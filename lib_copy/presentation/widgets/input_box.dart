import '../../resources/colors/colors.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final FormFieldValidator? validator;
  final TextInputType? keyboard;
  final TextEditingController textController;
  final Widget? iconPrefix;
  final Widget? iconSuffix;
  final String? labelText;
  final String hintText;
  final bool obscureText;
  const InputBox(
      {super.key,
      this.obscureText = false,
      required this.hintText,
      this.labelText,
      this.iconPrefix,
      this.iconSuffix,
      required this.textController,
      this.keyboard,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        obscuringCharacter: '*',
        keyboardType: keyboard,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: iconPrefix,
          suffixIcon: iconSuffix,
          hintText: hintText,
          labelText: labelText,
        ),
        obscureText: obscureText,
        cursorColor: TColors.grey,
      ),
    );
  }
}

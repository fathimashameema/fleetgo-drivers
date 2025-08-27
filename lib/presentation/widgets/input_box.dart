import 'package:fleetgo_drivers/resources/colors/colors.dart';
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
  final String? prefixText;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  const InputBox(
      {super.key,
      this.obscureText = false,
      required this.hintText,
      this.labelText,
      this.iconPrefix,
      this.iconSuffix,
      required this.textController,
      this.keyboard,
      this.validator,
      this.prefixText,
      this.onSubmit,
      this.onChanged,
      this.padding,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
      child: TextFormField(
        
        onChanged: onChanged,
        onFieldSubmitted: onSubmit,
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: validator,
        obscuringCharacter: '*',
        keyboardType: keyboard,
        controller: textController,
        decoration: InputDecoration(
            prefixText: prefixText,
            prefixIcon: iconPrefix,
            suffixIcon: iconSuffix,
            hintText: hintText,
            labelText: labelText,
            contentPadding:
                contentPadding ?? const EdgeInsets.fromLTRB(20, 8, 0, 8)),
        obscureText: obscureText,
        cursorColor: TColors.grey,
      ),
    );
  }
}

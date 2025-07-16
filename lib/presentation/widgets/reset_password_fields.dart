
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class ResetPasswordFields extends StatelessWidget {
  const ResetPasswordFields({
    super.key,
    required this.usernameController,
    required this.screenWidth,
    required this.hintText,
    required this.alternative,
    required this.mailOrSms,
    required this.navigateTo,
    this.keyboardType,
  });

  final TextEditingController usernameController;
  final double screenWidth;
  final String hintText;
  final String alternative;
  final String mailOrSms;
  final Widget navigateTo;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputBox(
          hintText: hintText,
          textController: usernameController,
          keyboard: keyboardType,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
            ),
            child: SizedBox(
              width: screenWidth * 0.8,
              child: Text(
                'We will send you an $mailOrSms with link to reset your password.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: TColors.grey,
                  thickness: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("or"),
              ),
              Expanded(
                child: Divider(
                  color: TColors.grey,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.8,
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => navigateTo));
              },
              child: Text(alternative)),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

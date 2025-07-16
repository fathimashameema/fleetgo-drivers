import 'package:fleetgo_drivers/presentation/screens/auth/signup/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinPut extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const PinPut({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Pinput(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter your OTP';
          }
          return null;
        },
        controller: pinPutController,
        length: 6,
        defaultPinTheme: PinTheme(
          width: 50,
          height: 50,
          textStyle: Theme.of(context).textTheme.headlineSmall,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

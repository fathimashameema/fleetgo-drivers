import 'otp_verified.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/icons/icons.dart';
import '../../../../resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: TIcons.backButton,
                  ),
                  Image.asset(
                    TImages.otpVerify,
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.5,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'OTP verification',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Enter the OTP sent to +91 1234567890',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 4,
                    defaultPinTheme: PinTheme(
                      margin: const EdgeInsets.all(3),
                      width: 50,
                      height: 50,
                      textStyle: Theme.of(context).textTheme.headlineSmall,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Resend OTP',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: TColors.headingTexts,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const OtpVerified(),
                          ),
                        );
                      },
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

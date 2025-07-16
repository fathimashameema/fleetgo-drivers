import 'complete_profile.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/images/images.dart';
import 'package:flutter/material.dart';

class OtpVerified extends StatelessWidget {
  const OtpVerified({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text: '@user',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: TColors.headingTexts),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      TImages.checkMark,
                      width: screenWidth * 0.7,
                      // height: screenHeight * 0.5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const CompleteProfile(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: screenWidth * 0.8,
                        child: Text(
                          'Successfully verified your OTP. Proceed to complete your sign up.',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

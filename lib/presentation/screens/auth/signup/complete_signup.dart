import 'package:fleetgo_drivers/presentation/screens/auth/registration/driver_or_renter.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class CompleteSignup extends StatelessWidget {
  final String userName;

  const CompleteSignup({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future.delayed(const Duration(seconds: 3), () {  
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const DriverOrRenter()),
        (route) => false,
      );
    }); 

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
                      text: 'Welcome ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text: userName,
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
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Text(
                        'Successfully verified your OTP. Proceed to complete your sign up.',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
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

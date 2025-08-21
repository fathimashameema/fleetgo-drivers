import 'package:fleetgo_drivers/presentation/screens/auth/registration/add_profile.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class RequestSend extends StatelessWidget {
  const RequestSend({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const AddProfile()),
          (route) => false);
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Request sent to Admin',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Image.asset(
            TImages.checkMark,
            width: screenWidth * 0.7,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              'Congratulation on your sign up. Wait for Admin to approve your request.!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

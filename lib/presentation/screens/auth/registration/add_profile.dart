import 'package:fleetgo_drivers/presentation/screens/auth/registration/reviewing_request.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Add profile picture',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Show your identity to customers',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                      radius: 92,
                      backgroundColor: TColors.grey,
                      child: Image.asset(TImages.addProfile)),
                  Spacer(),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => const ReviewingRequest()));
                        },
                        child: const Text('Add')),
                  ),
                  Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

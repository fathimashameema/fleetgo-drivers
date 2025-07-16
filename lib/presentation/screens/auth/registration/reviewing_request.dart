import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class ReviewingRequest extends StatelessWidget {
  const ReviewingRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            TImages.requestReviewing,
            height: 252,
            width: 236,
          ),
          Text(
            'Reviewing your request!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              textAlign: TextAlign.center,
              'Admin is currently reviewing your request. please wait for the updation.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }
}

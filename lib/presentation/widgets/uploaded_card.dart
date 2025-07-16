import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class UploadedCard extends StatelessWidget {
  const UploadedCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 20, 20, 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Row(
          children: [
            Image.asset(TImages.simpleCheckMark),
            const SizedBox(
              width: 20,
            ),
            Text('Uploaded',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark.withAlpha(175))),
          ],
        ),
      ),
    );
  }
}

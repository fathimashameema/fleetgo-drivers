import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';

class UploadFileCard extends StatelessWidget {
  const UploadFileCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          children: [
            SizedBox(height: 40, width: 51, child: Image.asset(TImages.upload)),
            Text(
              'Tap here to upload',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark.withAlpha(175)),
            ),
          ],
        ),
      ),
    );
  }
}

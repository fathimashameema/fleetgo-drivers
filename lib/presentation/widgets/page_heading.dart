import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  final String mainHeading;
  final String? subHeading;
  final CrossAxisAlignment? alignment;
  const PageHeading(
      {super.key, required this.mainHeading, this.subHeading, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20),
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
        children: [
          Text(
            mainHeading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          subHeading != null
              ? Text(
                  subHeading!,
                  style: Theme.of(context).textTheme.titleMedium,
                  softWrap: true,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RideStatCard extends StatelessWidget {
  final String title;
  final Widget data;
  const RideStatCard({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark.withAlpha(200),
              fontSize: 18,
            ),
          ),
          data
        ],
      ),
    );
  }
}

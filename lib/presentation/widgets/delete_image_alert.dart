import 'package:flutter/material.dart';

class DeleteImageAlert {
  Future<bool?> deleteImage(
    BuildContext context,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        // title: const Text('Delete profile picture?'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:fleetgo_drivers/presentation/widgets/camera_screen.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet {
  final ImagePicker picker = ImagePicker();

  Future<bool> requestCameraPermission() async {
    try {
      var status = await Permission.camera.request();
      if (status.isDenied) {
        return false;
      }
      return status.isGranted;
    } catch (e) {
      log('Camera permission error: $e');
      return false;
    }
  }

  Future<bool> requestGalleryPermission() async {
    try {
      var status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      if (status.isDenied) {
        return false;
      }
      return status.isGranted;
    } catch (e) {
      log('Gallery permission error: $e');
      return false;
    }
  }

  Future<File?> bottomSheet(
      BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet<File>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(20),
        height: screenHeight * 0.3,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add image',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: TColors.darkgGey,
                    size: 20,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: screenWidth * 0.7,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // try {
                  //   if (await requestCameraPermission()) {
                  //     final XFile? image =
                  //         await picker.pickImage(
                  //           source: ImageSource.camera,
                  //           imageQuality: 80, // Reduce quality to prevent crashes
                  //           maxWidth: 1024, // Limit max width
                  //           maxHeight: 1024, // Limit max height
                  //         );
                  //     if (image != null && ctx.mounted) {
                  //       Navigator.of(ctx).pop(File(image.path));
                  //     }
                  //   } else {
                  //     if (ctx.mounted) {
                  //       _showPermissionDialog(ctx, 'Camera Permission',
                  //         'Camera permission is required to take photos. Please enable it in app settings.');
                  //     }
                  //   }
                  // } catch (e) {
                  //   log('Camera error: $e');
                  //   if (ctx.mounted) {
                  //     _showErrorDialog(ctx, 'Camera Error',
                  //       'Failed to open camera. Please try again or use gallery instead.');
                  // }
                  // }

                  final File? capturedImage = await Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const CameraScreen(), 
                    ),
                  );

                  if (capturedImage != null && ctx.mounted) {
                    Navigator.of(ctx)
                        .pop(capturedImage);  
                  }
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take a photo'),
              ),
            ),
            const SizedBox(height: 10),

            // 🖼️ Choose from gallery
            SizedBox(
              width: screenWidth * 0.7,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    if (await requestGalleryPermission()) {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                        maxWidth: 1024,
                        maxHeight: 1024,
                      );
                      if (image != null && ctx.mounted) {
                        Navigator.of(ctx).pop(File(image.path));
                      }
                    } else {
                      if (ctx.mounted) {
                        _showPermissionDialog(ctx, 'Gallery Permission',
                            'Gallery permission is required to select images. Please enable it in app settings.');
                      }
                    }
                  } catch (e) {
                    log('Gallery error: $e');
                    if (ctx.mounted) {
                      _showErrorDialog(ctx, 'Gallery Error',
                          'Failed to open gallery. Please try again.');
                    }
                  }
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Choose from device'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

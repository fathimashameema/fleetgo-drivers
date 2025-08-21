// import 'dart:developer';
// import 'dart:io';

// import 'package:fleetgo_drivers/resources/colors/colors.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:flutter/material.dart';

// class CustomBottomSheet {
//   Future<bool> requestCameraPermission() async {
//     var status = await Permission.camera.request();
//     return status.isGranted;
//   }

//   Future<File?> bottomSheet(
//       BuildContext context, double screenHeight, double screenWidth) {
//     final ImagePicker picker = ImagePicker();

//     return showModalBottomSheet(
//         context: context,
//         builder: (ctx) => Container(
//               margin: const EdgeInsets.all(20),
//               height: screenHeight * 0.25,
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Add image',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             Navigator.of(ctx).pop();
//                           },
//                           icon: Icon(
//                             Icons.close,
//                             color: TColors.darkgGey,
//                             size: 20,
//                           ))
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     width: screenWidth * 0.7,
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           if (await requestCameraPermission()) {
//                             final XFile? image = await picker.pickImage(
//                                 source: ImageSource.camera);
//                             // if (image != null) {
//                             //   Navigator.of(ctx).pop(File(image.path));
//                             // }
//                           } else {
//                             log('permission error camera');
//                           }
//                         },
//                         child: const Text('Take a photo')),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     width: screenWidth * 0.7,
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           if (await requestCameraPermission()) {
//                             final XFile? image = await picker.pickImage(
//                                 source: ImageSource.gallery);
//                             if (image != null) {
//                               Navigator.of(ctx).pop(File(image.path));
//                             }
//                           } else {
//                             log('permission issue gallery');
//                           }
//                         },
//                         child: const Text('Choose from device')),
//                   )
//                 ],
//               ),
//             ));
//   }
// }
import 'dart:developer';
import 'dart:io';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera_screen.dart';

class CustomBottomSheet {
  final ImagePicker picker = ImagePicker();

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.photos.request();
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<File?> bottomSheet(
      BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet<File>(
      context: context,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(20),
        height: screenHeight * 0.25,
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
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: Icon(Icons.close, color: TColors.darkgGey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📸 Take a photo (in-app)
            SizedBox(
              width: screenWidth * 0.7,
              child: ElevatedButton(
                onPressed: () async {
                  if (await requestCameraPermission()) {
                    final File? file = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CameraScreen(),
                      ),
                    );
                    if (file != null) {
                      Navigator.of(ctx).pop(file);
                    }
                  } else {
                    log('permission error camera');
                  }
                },
                child: const Text('Take a photo'),
              ),
            ),
            const SizedBox(height: 10),

            // 🖼️ Choose from gallery
            SizedBox(
              width: screenWidth * 0.7,
              child: ElevatedButton(
                onPressed: () async {
                  if (await requestGalleryPermission()) {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      Navigator.of(ctx).pop(File(image.path));
                    }
                  } else {
                    log('permission issue gallery');
                  }
                },
                child: const Text('Choose from device'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

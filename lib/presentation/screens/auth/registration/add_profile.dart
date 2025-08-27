// import 'package:fleetgo_drivers/presentation/screens/auth/registration/reviewing_request.dart';
// import 'package:fleetgo_drivers/resources/colors/colors.dart';
// import 'package:fleetgo_drivers/resources/images/images.dart';
// import 'package:flutter/material.dart';

// class AddProfile extends StatelessWidget {
//   const AddProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Align(
//                 alignment: Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Text(
//                     'Skip',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 )),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Spacer(),
//                   Column(
//                     children: [
//                       Text(
//                         'Add profile picture',
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       Text(
//                         'Show your identity to customers',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       )
//                     ],
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: (){

//                     },
//                     child: CircleAvatar(
//                         radius: 92,
//                         backgroundColor: TColors.grey,
//                         child: Image.asset(TImages.addProfile)),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     width: screenWidth * 0.3,
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (ctx) => const ReviewingRequest()));
//                         },
//                         child: const Text('Add')),
//                   ),
//                   const Spacer()
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:fleetgo_drivers/bloc/store_documents_bloc/store_documents_bloc.dart';
import 'package:fleetgo_drivers/data/models/documents_state.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/reviewing_request.dart';
import 'package:fleetgo_drivers/presentation/widgets/custom_bottom_sheet.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
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
                  const Spacer(),

                  // 👇 BlocBuilder to handle profile pic state
                  BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                    builder: (context, state) {
                      final fieldState = state.documents['profilePic'];

                      if (fieldState == null ||
                          fieldState.status == DocumentStatus.initial) {
                        // Initial state → show default avatar
                        return GestureDetector(
                          onTap: () async {
                            final File? pickedImage =
                                await CustomBottomSheet().bottomSheet(
                              context,
                              screenHeight,
                              screenWidth,
                            );
                            if (pickedImage != null) {
                              context.read<StoreDocumentsBloc>().add(
                                    UploadImage(
                                      file: pickedImage,
                                      folder: "Driver_Profile",
                                      fileName:
                                          "profile_${DateTime.now().microsecondsSinceEpoch}.jpg",
                                      field: 'profilePic',
                                      fileField: 'profileFile',
                                    ),
                                  );
                            }
                          },
                          child: CircleAvatar(
                            radius: 92,
                            backgroundColor: Colors.grey,
                            child: Image.asset(TImages.addProfile),
                          ),
                        );
                      } else if (fieldState.status == DocumentStatus.loading) {
                        // Uploading
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SpinKitThreeInOut(
                              color: TColors.headingTexts, size: 30.0),
                        );
                      } else if (fieldState.status == DocumentStatus.deleting) {
                        // 🔥 Deleting
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child:
                              SpinKitThreeInOut(color: Colors.red, size: 30.0),
                        );
                      } else if (fieldState.status == DocumentStatus.success) {
                        // ✅ Show uploaded profile image
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              radius: 92,
                              backgroundImage: NetworkImage(fieldState.url!),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).highlightColor,
                                child: const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 20),
                              ),
                              onPressed: () async {
                                final shouldDelete =
                                    await deleteProfile(context);
                                if (shouldDelete == true) {
                                  context.read<StoreDocumentsBloc>().add(
                                        DeleteDocument(
                                          folder: "Driver_Profile",
                                          field: 'profilePic',
                                          fileField: 'profileFile',
                                          fileName: fieldState.fileName!,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Text("Error uploading profile picture");
                      }
                    },
                  ),

                  const Spacer(),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => const ReviewingRequest(),
                          ),
                        );
                      },
                      child: const Text('Add'),
                    ),
                  ),
                  const Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> deleteProfile(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete profile picture?'),
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

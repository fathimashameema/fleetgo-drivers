import 'dart:io';

import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/store_documents_bloc/store_documents_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/data/models/documents_state.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/delete_image_alert.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/upload_file_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/uploaded_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController experienceController = TextEditingController();

  @override
  void dispose() {
    experienceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<StoreDocumentsBloc>().add(const GetDocument());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 180,
          child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
              builder: (context, checkBoxState) {
            return BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, docState) {
              return ElevatedButton(
                onPressed: () {
                  final addressProof = docState.documents['addressProof'];
                  final licence = docState.documents['licence'];
                  final pvc = docState.documents['pvc'];
                  final experience = experienceController.text.trim();

                  if (addressProof?.url == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please upload Address Proof")),
                    );
                    return;
                  }
                  if (licence?.url == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please upload Licence")),
                    );
                    return;
                  }
                  if (pvc?.url == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Please upload Police Verification Certificate")),
                    );
                    return;
                  }
                  if (experience.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter your experience")),
                    );
                    return;
                  }

                  // Save experience to Firestore
                  context.read<StoreDocumentsBloc>().add(
                        UploadData(field: 'experience', value: experience),
                      );

                  // Move to next page
                  context
                      .read<AuthenticationBloc>()
                      .add(const SetRegistrationProgress(2));
                  if (checkBoxState is SelectedRole) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return VehicleRegistration(
                          driverOrRenter: checkBoxState.selectedValue == 0
                              ? 'Taxi'
                              : 'Vehicle',
                        );
                      }),
                    );
                  }
                },
                child: const Text('Submit'),
              );
            });
          })),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const PageHeading(
          mainHeading: 'Complete profile',
          subHeading: 'Provide necessary documents.',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8.0),
          child: Column(
            children: [
              const CompleteProfileSubheading(
                  subHeading: 'Address proof(Aadhaar,PAN / Voter id)'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['addressProof'];

                  if (fieldState == null ||
                      fieldState.status == DocumentStatus.initial) {
                    return UploadFileCard(
                      onTap: () async {
                        final File? pickedImage = await CustomBottomSheet()
                            .bottomSheet(context, screenHeight, screenWidth);
                        if (pickedImage != null) {
                          context.read<StoreDocumentsBloc>().add(
                                UploadImage(
                                  file: pickedImage,
                                  folder: "Driver_Documents",
                                  fileName:
                                      "address_proof${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'addressProof',
                                  fileField: 'addressProofFile',
                                ),
                              );
                        }
                      },
                    );
                  } else if (fieldState.status == DocumentStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.white, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.deleting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.red, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.success) {
                    return UploadSuccessCard(
                      imagePath: fieldState.url!,
                      onClose: () async {
                        final shouldDelete =
                            await DeleteImageAlert().deleteImage(context);
                        if (shouldDelete == true) {
                          context.read<StoreDocumentsBloc>().add(
                                DeleteDocument(
                                  folder: "Driver_Documents",
                                  field: 'addressProof',
                                  fileField: 'addressProofFile',
                                  fileName: fieldState.fileName!,
                                ),
                              );
                        }
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
              const CompleteProfileSubheading(subHeading: 'Driver Licence'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['licence'];

                  if (fieldState == null ||
                      fieldState.status == DocumentStatus.initial) {
                    return UploadFileCard(
                      onTap: () async {
                        final File? pickedImage = await CustomBottomSheet()
                            .bottomSheet(context, screenHeight, screenWidth);
                        if (pickedImage != null) {
                          context.read<StoreDocumentsBloc>().add(
                                UploadImage(
                                  file: pickedImage,
                                  folder: "Driver_Documents",
                                  fileName:
                                      "licence${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'licence',
                                  fileField: 'licenceFile',
                                ),
                              );
                        }
                      },
                    );
                  } else if (fieldState.status == DocumentStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.white, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.deleting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.red, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.success) {
                    return UploadSuccessCard(
                      imagePath: fieldState.url!,
                      onClose: () async {
                        final shouldDelete =
                            await DeleteImageAlert().deleteImage(context);
                        if (shouldDelete == true) {
                          context.read<StoreDocumentsBloc>().add(
                                DeleteDocument(
                                  folder: "Driver_Documents",
                                  field: 'licence',
                                  fileField: 'licenceFile',
                                  fileName: fieldState.fileName!,
                                ),
                              );
                        }
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
              const CompleteProfileSubheading(
                  subHeading: 'Police Verification certificate.'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['pvc'];

                  if (fieldState == null ||
                      fieldState.status == DocumentStatus.initial) {
                    return UploadFileCard(
                      onTap: () async {
                        final File? pickedImage = await CustomBottomSheet()
                            .bottomSheet(context, screenHeight, screenWidth);
                        if (pickedImage != null) {
                          context.read<StoreDocumentsBloc>().add(
                                UploadImage(
                                  file: pickedImage,
                                  folder: "Driver_Documents",
                                  fileName:
                                      "pvc${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'pvc',
                                  fileField: 'pvcFile',
                                ),
                              );
                        }
                      },
                    );
                  } else if (fieldState.status == DocumentStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.white, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.deleting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitThreeInOut(color: Colors.red, size: 20.0),
                    );
                  } else if (fieldState.status == DocumentStatus.success) {
                    return UploadSuccessCard(
                      imagePath: fieldState.url!,
                      onClose: () async {
                        final shouldDelete =
                            await DeleteImageAlert().deleteImage(context);
                        if (shouldDelete == true) {
                          context.read<StoreDocumentsBloc>().add(
                                DeleteDocument(
                                  folder: "Driver_Documents",
                                  field: 'pvc',
                                  fileField: 'pvcFile',
                                  fileName: fieldState.fileName!,
                                ),
                              );
                        }
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
              const CompleteProfileSubheading(
                  subHeading: 'Enter your driving experience(In year)'),
              InputBox(
                  hintText: 'Experience', textController: experienceController),
              SizedBox(
                height: screenHeight * 0.1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

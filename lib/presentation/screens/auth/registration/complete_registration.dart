import 'dart:io';

import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/store_documents_bloc/store_documents_bloc.dart';
import 'package:fleetgo_drivers/data/models/documents_state.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/request_send.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/custom_bottom_sheet.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/upload_file_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/uploaded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({super.key});

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
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
        child: BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
          builder: (context, docState) {
            return ElevatedButton(
              onPressed: () {
                final rc = docState.documents['rc'];
                final insurance = docState.documents['insurance'];
                final permit = docState.documents['permit'];

                if (rc?.url == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Please upload Vehicle Registration Certificate")),
                  );
                  return;
                }
                if (insurance?.url == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please upload Insurence Certificate")),
                  );
                  return;
                }
                if (permit?.url == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please upload Permit")),
                  );
                  return;
                }

                context
                    .read<AuthenticationBloc>()
                    .add(const SetRegistrationProgress(4));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const RequestSend()));
              },
              child: const Text('Submit'),
            );
          },
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const PageHeading(
          mainHeading: 'Vehicle registration',
          subHeading: 'Provide necessary documents.',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8.0),
          child: Column(
            children: [
              const CompleteProfileSubheading(
                  subHeading: 'Vehicle Registration Certificate(RC)'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['rc'];

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
                                      "rc${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'rc',
                                  fileField: 'rcFile',
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
                      onClose: () {
                        context.read<StoreDocumentsBloc>().add(
                              DeleteDocument(
                                folder: "Driver_Documents",
                                field: 'rc',
                                fileField: 'rcFile',
                                fileName: fieldState.fileName!,
                              ),
                            );
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
              const CompleteProfileSubheading(
                  subHeading: 'Insurance Certificate'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['insurance'];

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
                                      "insurance${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'insurance',
                                  fileField: 'insuranceFile',
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
                      onClose: () {
                        context.read<StoreDocumentsBloc>().add(
                              DeleteDocument(
                                folder: "Driver_Documents",
                                field: 'insurance',
                                fileField: 'insuranceFile',
                                fileName: fieldState.fileName!,
                              ),
                            );
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
              const CompleteProfileSubheading(
                  subHeading: 'Taxi Permit / Commercial Permit'),
              BlocBuilder<StoreDocumentsBloc, StoreDocumentsState>(
                builder: (context, state) {
                  final fieldState = state.documents['permit'];

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
                                      "permit${DateTime.now().microsecondsSinceEpoch}.jpg",
                                  field: 'permit',
                                  fileField: 'permitFile',
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
                      onClose: () {
                        context.read<StoreDocumentsBloc>().add(
                              DeleteDocument(
                                folder: "Driver_Documents",
                                field: 'permit',
                                fileField: 'permitFile',
                                fileName: fieldState.fileName!,
                              ),
                            );
                      },
                    );
                  } else {
                    return const Text("Error uploading file");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

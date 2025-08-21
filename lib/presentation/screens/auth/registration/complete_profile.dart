import 'dart:developer';
import 'dart:io';

import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/store_documents_bloc/store_documents_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/upload_file_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/uploaded_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 180,
          child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
            builder: (context, checkBoxState) {
              return ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(const SetRegistrationProgress(2));
                  checkBoxState is SelectedRole
                      ? Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                          return VehicleRegistration(
                            driverOrRenter: checkBoxState.selectedValue == 0
                                ? 'Taxi'
                                : 'Vehicle',
                          );
                        }))
                      : null;
                },
                child: const Text('Submit'),
              );
            },
          )),
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
                  return state is UploadLoading
                      ? CircularIndicator()
                      : state is UploadSuccess
                          // ? Image.network(state.downloadUrl)
                          ? UploadSuccessCard(
                              imagePath: state.downloadUrl,
                              // onClose: () {},
                            )
                          : UploadFileCard(
                              onTap: () async {
                                final File? pickedImage =
                                    await CustomBottomSheet().bottomSheet(
                                        context, screenHeight, screenWidth);
                                log('image file :$pickedImage');

                                if (pickedImage != null) {
                                  context.read<StoreDocumentsBloc>().add(
                                        UploadFile(
                                          file: pickedImage,
                                          folder:
                                              "Driver_Documents", // 👈 or "profile_images" / "vehicle_images"
                                          fileName:
                                              "user_${DateTime.now().millisecondsSinceEpoch}.jpg",
                                        ),
                                      );
                                }
                              },
                            );
                },
              ),
              const CompleteProfileSubheading(subHeading: 'Driver License'),
              // const UploadSuccessCard(),
              const CompleteProfileSubheading(
                  subHeading: 'Police Verification certificate.'),
              const UploadFileCard(),
              const CompleteProfileSubheading(
                  subHeading: 'Enter your driving experience(In year)'),
              InputBox(
                  hintText: 'Experience', textController: experienceController)
            ],
          ),
        ),
      ),
    );
  }
}

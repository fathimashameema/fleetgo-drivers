import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/upload_file_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/uploaded_card.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 180,
          child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  state is SelectedRole
                      ? Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                          return VehicleRegistration(
                            driverOrRenter:
                                state.selectedValue == 0 ? 'Taxi' : 'Vehicle',
                          );
                        }))
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Select your role to continue')));
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
              const UploadedCard(),
              const CompleteProfileSubheading(subHeading: 'Driver License'),
              const UploadFileCard(),
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

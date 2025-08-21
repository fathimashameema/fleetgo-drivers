import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/request_send.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/upload_file_card.dart';
import 'package:fleetgo_drivers/presentation/widgets/uploaded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({super.key});

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  @override
  Widget build(BuildContext context) {
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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 8.0),
          child: Column(
            children: [
              CompleteProfileSubheading(
                  subHeading: 'Vehicle Registration Certificate(RC)'),
              // UploadSuccessCard(),
              CompleteProfileSubheading(subHeading: 'Insurance Certificate'),
              UploadFileCard(),
              CompleteProfileSubheading(
                  subHeading: 'Taxi Permit / Commercial Permit'),
              UploadFileCard(),
            ],
          ),
        ),
      ),
    );
  }
}

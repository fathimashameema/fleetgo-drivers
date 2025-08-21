import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_profile.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/role_card.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverOrRenter extends StatelessWidget {
  const DriverOrRenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PageHeading(
              alignment: CrossAxisAlignment.center,
              mainHeading: 'Which describes you well?',
              subHeading: 'Choose your role to continue.',
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                child: RoleCard(
                  image: TImages.taxiDriver,
                  role: 'Taxi driver',
                  description:
                      'Drive and earn by providing safe, reliable rides to passengers.',
                  value: 0,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                child: RoleCard(
                  space: 15,
                  image: TImages.vehicleRenter,
                  role: 'Vehicle renter',
                  description:
                      'Put your idle vehicle to work and generate passive income.',
                  value: 1,
                )),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 180,
              child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
                builder: (context, checkBoxState) {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(const SetRegistrationProgress(1));

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => const CompleteProfile()));
                    },
                    child: checkBoxState is CheckBoxLoading
                        ? const CircularIndicator()
                        : const Text('continue'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

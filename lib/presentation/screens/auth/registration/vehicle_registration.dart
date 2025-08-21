
import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_registration.dart';
import 'package:fleetgo_drivers/presentation/widgets/complete_profile_subheading.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/vehicle_name_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleRegistration extends StatefulWidget {
  final String driverOrRenter;
  const VehicleRegistration({super.key, required this.driverOrRenter});

  @override
  State<VehicleRegistration> createState() => _VehicleRegistrationState();
}

class _VehicleRegistrationState extends State<VehicleRegistration> {
  String? selectedUserType;
  String? selectedVehicleType;
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController seatingCapacityController =
      TextEditingController();
  final TextEditingController baseFareController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();

  @override
  void dispose() {
    modelNameController.dispose();
    seatingCapacityController.dispose();
    baseFareController.dispose();
    additionalDetailsController.dispose();
    super.dispose();
  }

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
                          .add(const SetRegistrationProgress(3));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const CompleteRegistration()));
                    },
                    child: const Text('Continue'),
                  );
                },
              ),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: PageHeading(
          mainHeading: '${widget.driverOrRenter} Registration',
          subHeading: 'Complete the process details.',
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompleteProfileSubheading(
                    subHeading: 'Select your vehicle'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
                    builder: (context, state) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3,
                          ),
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<CheckBoxBloc>()
                                    .add(SelectVehicle(selectedValue: index));
                              },
                              child: VehicleNameChip(
                                isSelected: state is SelectedVehicle
                                    ? state.selectedValue == index
                                    : false,
                                vehicle: 'Vehicle ${index + 1}',
                              ),
                            );
                          });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const CompleteProfileSubheading(
                    subHeading: 'Details about your vehicle'),
                InputBox(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    hintText: 'Model name',
                    textController: modelNameController),
                InputBox(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    hintText: 'Seating capacity',
                    textController: seatingCapacityController),
                InputBox(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    hintText: 'Base fare',
                    textController: baseFareController),
                const SizedBox(height: 20),
                const CompleteProfileSubheading(subHeading: 'Tell us more'),
                InputBox(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    hintText: 'Eg, Ac/non Ac , extra luggage capacity....',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    textController: additionalDetailsController),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

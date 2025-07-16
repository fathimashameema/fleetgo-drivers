
import 'package:fleetgo_drivers/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/login/forgot_password_email.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/login/get_code.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/presentation/widgets/reset_password_fields.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPhone extends StatefulWidget {
  const ForgotPasswordPhone({super.key});

  @override
  State<ForgotPasswordPhone> createState() => _ForgotPasswordPhoneState();
}

class _ForgotPasswordPhoneState extends State<ForgotPasswordPhone> {
  final TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: TIcons.backButton),
        title: const PageHeading(
          mainHeading: 'Forgot password?!',
          subHeading: 'Restore your account',
        ),
      ),
      body: SafeArea(
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is ResetCodeSent) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => GetCode(
                  email: state.email,
                  phone: state.phone,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              const SizedBox(
                height: 80,
              ),
              ResetPasswordFields(
                keyboardType: TextInputType.phone,
                usernameController: numberController,
                screenWidth: screenWidth,
                hintText: 'Mobile number',
                alternative: 'Search by Email or Username ',
                mailOrSms: 'SMS',
                navigateTo: const ForgotPasswordEmail(),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      if (numberController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text('Enter a response'),
                                content: const Text(
                                    'Please enter a Username,Email address or search by Email address to continue.'),
                                actions: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          side: BorderSide(
                                              color: TColors.transparent)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Try again'))
                                ],
                              );
                            });
                      } else {
                        context.read<ForgotPasswordBloc>().add(
                              SendResetCodeRequested(
                                  numberController.text.trim(),
                                  'Please enter this code to continue resetting your password.'),
                            );
                      }
                    },
                    child: state is ForgotPasswordLoading
                        ? const CircularIndicator()
                        : const Text('Continue'),
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}

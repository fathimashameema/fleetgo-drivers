import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/login/forgot_password_email.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_profile.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_registration.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/driver_or_renter.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/reviewing_request.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/welcome.dart';
import 'package:fleetgo_drivers/presentation/screens/home/home_page.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/login_form.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: TIcons.backButton),
          title: const PageHeading(
            mainHeading: 'Login',
            subHeading: 'Provide your info',
          )),
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 80,
          ),
          LoginForm(
              formKey: formKey,
              identifierController: identifierController,
              passwordController: passwordController),
          Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const ForgotPasswordEmail()));
              },
              child: Text(
                'Forgot password?',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: TColors.headingTexts),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: 180,
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    return BlocConsumer<SignInBloc, SignInState>(
                      listener: (context, state) {
                        if (state is SignInFailure) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text(state.message!)));
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Failed to login!'),
                                  content: Text(state.message!),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ok'))
                                  ],
                                );
                              });
                        }
                        if (state is SignInSuccess) {
                          final authState =
                              context.read<AuthenticationBloc>().state;

                          switch (authState.status) {
                            case AuthenticationStatus.profileIncomplete:
                              final progress = authState.registrationProgress;

                              if (progress == 0) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) => const DriverOrRenter()),
                                );
                              } else if (progress == 1) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CompleteProfile()),
                                );
                              } else if (progress == 2) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) => const VehicleRegistration(
                                        driverOrRenter: 'taxi'),
                                  ),
                                );
                              } else if (progress == 3) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CompleteRegistration()),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const ReviewingRequest()),
                                );
                              }
                              break;

                            case AuthenticationStatus.authenticated:
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const HomePage()),
                              );
                              break;

                            case AuthenticationStatus.loading:
                              Shimmer.fromColors(
                                baseColor: TColors.darkgGey,
                                highlightColor: TColors.grey,
                                child: const DriverOrRenter(),
                              );
                              break;

                            case AuthenticationStatus.unauthenticated:
                            default:
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const Welcome()),
                              );
                              break;
                          }
                        }
                      },
                      // Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (ctx) => const HomePage()));
                      //   }
                      // },
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              } else {
                                context.read<SignInBloc>().add(SignInRequired(
                                    identifierController.text,
                                    passwordController.text));
                              }
                            },
                            child: state is SignInProcess
                                ? const CircularIndicator()
                                : const Text('Login'));
                      },
                    );
                  },
                )),
          )
        ],
      )),
    );
  }
}

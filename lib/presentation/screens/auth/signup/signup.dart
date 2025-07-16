import 'dart:math' as math;

import 'package:driver_repository/driver_repository.dart';
import 'package:fleetgo_drivers/bloc/email_verification_bloc/email_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/mobile_verififcation_bloc/mobile_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:fleetgo_drivers/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:fleetgo_drivers/bloc/sms_email_checkBox_bloc/sms_email_check_box_bloc.dart';
import 'package:fleetgo_drivers/bloc/driver_exist_bloc/is_driver_exist_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/signup/otp_verification.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/signup/sign_up_fields.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/otp_check_boxes.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    numberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  late final int otp;
  FirestoreRepo firestoreRepo = FirestoreDriverRepository();

  @override
  Widget build(BuildContext context) {
    context.read<SmsEmailCheckBoxBloc>().add(SelectSmsEvent());

    // Reset password visibility when form is loaded
    String signupPasswordFieldId = 'signup_password';
    String signupConfirmPasswordFieldId = 'signup_confirm_password';
    context
        .read<PasswordVisibilityBloc>()
        .add(ResetPasswordVisibility(signupPasswordFieldId));
    context
        .read<PasswordVisibilityBloc>()
        .add(ResetPasswordVisibility(signupConfirmPasswordFieldId));

    final formFields = signupFormFields(
      usernameController: usernameController,
      numberController: numberController,
      emailController: emailController,
      passwordController: passwordController,
      confirmPassController: confirmPassController,
      onUserChange: (value) {
        if (value.isNotEmpty) {
          context.read<IsDriverExistBloc>().add(ClearDriverExistState());
        }
        context.read<IsDriverExistBloc>().add(IsDriverExist(
            userName: usernameController.text,
            email: emailController.text,
            number: numberController.text));
      },
    );
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: TIcons.backButton),
        title: const PageHeading(
          mainHeading: 'Create Account',
          subHeading: 'Provide your info',
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            Form(
              key: formKey,
              child: Column(
                children: formFields.map((field) {
                  if (field.containsKey('id')) {
                    return BlocBuilder<PasswordVisibilityBloc,
                        PasswordVisibilityChange>(
                      builder: (context, state) {
                        String fieldId = field['id'];

                        return InputBox(
                          iconSuffix: GestureDetector(
                            onTap: () => context
                                .read<PasswordVisibilityBloc>()
                                .add(TogglePasswordVisibility(fieldId)),
                            child: Icon(
                              context
                                      .read<PasswordVisibilityBloc>()
                                      .isFieldVisible(fieldId)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 15,
                            ),
                          ),
                          iconPrefix: field['prefixIcon'],
                          keyboard: field['keyBoard'],
                          validator: field['validator'],
                          obscureText: !context
                              .read<PasswordVisibilityBloc>()
                              .isFieldVisible(fieldId),
                          textController: field['controller'],
                          hintText: field['hintText'],
                          prefixText: field['prefixText'],
                          onChanged: field['onChanged'],
                        );
                      },
                    );
                  } else {
                    return InputBox(
                      iconSuffix: field['suffixIcon'],
                      iconPrefix: field['prefixIcon'],
                      keyboard: field['keyBoard'],
                      validator: field['validator'],
                      obscureText: field['obscureText'],
                      textController: field['controller'],
                      hintText: field['hintText'],
                      prefixText: field['prefixText'],
                      onChanged: field['onChanged'],
                    );
                  }
                }).toList(),
              ),
            ),
            const OtpCheckBoxes(),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 180,
                child: BlocBuilder<IsDriverExistBloc, IsDriverExistState>(
                  builder: (context, userExistState) {
                    return BlocBuilder<SmsEmailCheckBoxBloc,
                        SmsEmailCheckBoxState>(
                      builder: (context, smsEmailState) {
                        return ElevatedButton(onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          } else {
                            if (userExistState is DriverExist) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(userExistState.error)),
                              );
                            } else if (smsEmailState.selectedValue == 'email') {
                              final random = math.Random();
                              otp = 100000 + random.nextInt(900000);

                              context.read<EmailVerificationBloc>().add(VerifyEmail(
                                  otp: otp,
                                  email: emailController.text,
                                  message:
                                      'Please enter this code to complete your verification process.'));
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => OtpVerification(
                                            isMail: true,
                                            mailOrPhone: emailController.text,
                                            email: emailController.text,
                                            phone: numberController.text,
                                            password: passwordController.text,
                                            username: usernameController.text,
                                          )));
                            } else {
                              context
                                  .read<MobileVerificationBloc>()
                                  .add(VerifyPhone(
                                    numberController.text,
                                  ));
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => OtpVerification(
                                            isMail: false,
                                            mailOrPhone: numberController.text,
                                            email: emailController.text,
                                            phone: numberController.text,
                                            password: passwordController.text,
                                            username: usernameController.text,
                                          )));
                            }
                          }
                        }, child: BlocBuilder<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                            return state is SignUpProcess
                                ? const CircularIndicator()
                                : const Text('Get OTP');
                          },
                        ));
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

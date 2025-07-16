import 'dart:math';

import 'package:driver_repository/driver_repository.dart';
import 'package:fleetgo_drivers/bloc/email_verification_bloc/email_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/mobile_verififcation_bloc/mobile_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/signup/complete_signup.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/pinput.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_resend_timer/otp_resend_timer.dart';

class OtpVerification extends StatefulWidget {
  final String? verificationId;
  final String mailOrPhone;
  final String email;
  final String phone;
  final String username;
  final String password;
  final bool isMail;

  const OtpVerification(
      {super.key,
      required this.mailOrPhone,
      required this.email,
      required this.phone,
      required this.username,
      required this.password,
      this.verificationId,
      required this.isMail});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

late OtpResendTimerController _controller;
final TextEditingController pinPutController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _OtpVerificationState extends State<OtpVerification> {
  @override
  void initState() {
    super.initState();
    _controller = OtpResendTimerController(initialTime: 60);
  }

  void _onResendClicked(String mail) {
    final random = Random();
    int otp = 100000 + random.nextInt(900000);
    context.read<EmailVerificationBloc>().add(ResentOtp(
        otp: otp,
        mailOrPhone: mail,
        message:
            'Please enter this code to complete your verification process.'));
  }

  void smsOtpResend(String number) {
    context.read<MobileVerificationBloc>().add(VerifyPhone(
          number,
        ));
  }

  Future<void> verifyDriver(String mailOrPhone, int otp) async {
    context
        .read<EmailVerificationBloc>()
        .add(VerifyOtp(mailOrPhone: mailOrPhone, otp: otp));
  }

  Future<void> driverSignUpEmail(
      String email, String phone, String password, String username) async {
    Driver driver = Driver.emptyUser;
    driver = driver.copyWith(
      email: email,
      name: username,
      number: phone,
      password: password,
    );
    context.read<SignUpBloc>().add(SignUpEmail(driver, password, email));
  }

  Future<void> driverSignUpPhone(String email, String phone, String password,
      String username, String smsOtp) async {
    Driver driver = Driver.emptyUser;
    driver = driver.copyWith(
      email: email,
      name: username,
      number: phone,
      password: password,
    );
    context.read<SignUpBloc>().add(SignUpPhone(user: driver, smsOtp: smsOtp));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: TIcons.backButton),
                  Image.asset(
                    TImages.otpVerify,
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.5,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'OTP verification',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(
                    width: screenWidth * 0.93,
                    child: Text(
                      'Enter the OTP sent to ${widget.mailOrPhone}',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinPut(
                    formKey: _formKey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OtpResendTimer(
                    controller: _controller,
                    onResendClicked: () => widget.isMail
                        ? _onResendClicked(widget.mailOrPhone)
                        : smsOtpResend(widget.phone),
                    autoStart: true,
                    timerMessage: 'Resend OTP in ',
                    readyMessage: "Didn't get the code yet?",
                    holdMessage: 'Start timer to enable resend',
                    resendMessage: 'Resend',
                    timerMessageStyle: Theme.of(context).textTheme.labelMedium,
                    resendMessageStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  widget.isMail
                      ? BlocConsumer<EmailVerificationBloc,
                          EmailVerificationState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  verifyDriver(widget.mailOrPhone,
                                      int.parse(pinPutController.text));
                                },
                                child: state is EmailVerificationLoading
                                    ? const CircularIndicator()
                                    : const Text('Verify'),
                              ),
                            );
                          },
                          listener: (context, state) async {
                            if (state is EmailVerificationFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            } else if (state is EmailVerificationSuccess) {
                              await driverSignUpEmail(
                                widget.email,
                                widget.phone,
                                widget.password,
                                widget.username,
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CompleteSignup(
                                  userName: widget.username,
                                ),
                              ));
                            }
                          },
                        )
                      : BlocConsumer<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                            return SizedBox(  
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  driverSignUpPhone(
                                    widget.email,
                                    widget.phone,
                                    widget.password,
                                    widget.username,
                                    pinPutController.text,
                                  ); 
                                },       
                                child: state is SignUpProcess 
                                    ? const CircularIndicator()
                                    : const Text('Verify'),
                              ),
                            );
                          },
                          listener: (context, state) {
                            if (state is SignUpFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Incorrect OTP , Please try again!')),
                              );
                            } else if (state is SignUpSuccess) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CompleteSignup(
                                  userName: widget.username,
                                ),
                              ));
                            }
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:fleetgo_drivers/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/login/set_new_pass.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCode extends StatefulWidget {
  final String? email;
  final String? phone;
  const GetCode({super.key, this.email, this.phone});

  @override
  State<GetCode> createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is ResetCodeVerified) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (ctx) => SetNewPass(email: widget.email, phone: widget.phone),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: TIcons.backButton,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          widget.email != null
                              ? 'We\'ve sent a code to your email. Enter that code to confirm your account'
                              : 'We\'ve sent an SMS code to your phone. Enter that code to confirm your account',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  TImages.verifyCode,
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.4,
                ),
                InputBox(
                  hintText: 'Enter code',
                  textController: _codeController,
                  keyboard: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter verification code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'It may take few minutes to get this code.',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<ForgotPasswordBloc>().add(
                            SendResetCodeRequested(
                              widget.email ?? widget.phone!,
                              'Please enter this code to continue resetting your password.',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New code sent successfully!'),
                            ),
                          );
                        },
                        child: Text(
                          'Get a new code',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: TColors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ForgotPasswordBloc>().add(
                                VerifyResetCode(
                                  _codeController.text.trim(),
                                  email: widget.email,
                                  phone: widget.phone,
                                ),
                              );
                            }
                          },
                          child:
                              state is ForgotPasswordLoading
                                  ? const CircularIndicator()
                                  : const Text('Continue'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}

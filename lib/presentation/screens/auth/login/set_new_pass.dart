import 'package:fleetgo_drivers/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:fleetgo_drivers/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/login/password_changed.dart';
import 'package:fleetgo_drivers/presentation/widgets/circular_indicator.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:fleetgo_drivers/presentation/widgets/page_heading.dart';
import 'package:fleetgo_drivers/resources/icons/icons.dart';
import 'package:fleetgo_drivers/resources/regx/regexp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPass extends StatefulWidget {
  final String? phone;
  final String? email;
  const SetNewPass({super.key, this.phone, this.email});

  @override
  State<SetNewPass> createState() => _SetNewPassState();
}

class _SetNewPassState extends State<SetNewPass> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Define unique field IDs for each password field
  static const String currentPasswordFieldId = 'current_password';
  static const String newPasswordFieldId = 'new_password';
  static const String confirmPasswordFieldId = 'confirm_password';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reset password visibility when form is loaded
    context
        .read<PasswordVisibilityBloc>()
        .add(const ResetPasswordVisibility(currentPasswordFieldId));
    context
        .read<PasswordVisibilityBloc>()
        .add(const ResetPasswordVisibility(newPasswordFieldId));
    context
        .read<PasswordVisibilityBloc>()
        .add(const ResetPasswordVisibility(confirmPasswordFieldId));

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const PasswordChanged()),
            (route) => route.isFirst,
          );
        }
        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: TIcons.backButton,
          ),
          title: const PageHeading(
            mainHeading: 'Create new password',
            subHeading: 'Reset your password',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Current password',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityChange>(
                  builder: (context, state) {
                    return InputBox(
                      hintText: 'Current password',
                      textController: _currentPasswordController,
                      obscureText: !context
                          .read<PasswordVisibilityBloc>()
                          .isFieldVisible(currentPasswordFieldId),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      iconSuffix: IconButton(
                        icon: Icon(
                          context
                                  .read<PasswordVisibilityBloc>()
                                  .isFieldVisible(currentPasswordFieldId)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 15,
                        ),
                        onPressed: () {
                          context.read<PasswordVisibilityBloc>().add(
                                const TogglePasswordVisibility(
                                    currentPasswordFieldId),
                              );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    'New password',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityChange>(
                  builder: (context, state) {
                    return InputBox(
                      hintText: 'Password',
                      textController: _passwordController,
                      obscureText: !context
                          .read<PasswordVisibilityBloc>()
                          .isFieldVisible(newPasswordFieldId),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (!Regexp.digitExp.hasMatch(value)) {
                          return 'Your password should contain at least one digit.';
                        } else if (!Regexp.lowercaseExp.hasMatch(value)) {
                          return 'Your password should contain at least one lowercase letter.';
                        } else if (!Regexp.uppercaseExp.hasMatch(value)) {
                          return 'Your password should contain at least one uppercase letter.';
                        } else if (!Regexp.minimumCharExp.hasMatch(value)) {
                          return 'Your password should contain minimum 8 characters';
                        }
                        return null;
                      },
                      iconSuffix: IconButton(
                        icon: Icon(
                          context
                                  .read<PasswordVisibilityBloc>()
                                  .isFieldVisible(newPasswordFieldId)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 15,
                        ),
                        onPressed: () {
                          context.read<PasswordVisibilityBloc>().add(
                                const TogglePasswordVisibility(
                                    newPasswordFieldId),
                              );
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityChange>(
                  builder: (context, state) {
                    return InputBox(
                      hintText: 'Confirm password',
                      textController: _confirmPasswordController,
                      obscureText: !context
                          .read<PasswordVisibilityBloc>()
                          .isFieldVisible(confirmPasswordFieldId),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      iconSuffix: IconButton(
                        icon: Icon(
                          context
                                  .read<PasswordVisibilityBloc>()
                                  .isFieldVisible(confirmPasswordFieldId)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 15,
                        ),
                        onPressed: () {
                          context.read<PasswordVisibilityBloc>().add(
                                const TogglePasswordVisibility(
                                    confirmPasswordFieldId),
                              );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    'Both passwords must match',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.start,
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
                                    PasswordResetRequested(
                                      _passwordController.text,
                                      currentPassword:
                                          _currentPasswordController.text,
                                      email: widget.email,
                                      phone: widget.phone,
                                    ),
                                  );
                            }
                          },
                          child: state is ForgotPasswordLoading
                              ? const CircularIndicator()
                              : const Text('Reset'),
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
}

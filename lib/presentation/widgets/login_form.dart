
import 'package:fleetgo_drivers/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:fleetgo_drivers/presentation/widgets/input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;

  static const String loginPasswordFieldId = 'login_password';

  @override
  Widget build(BuildContext context) {
    context
        .read<PasswordVisibilityBloc>()
        .add(const ResetPasswordVisibility(loginPasswordFieldId));

    return Form(
      key: formKey,
      child: Column(
        children: [
          InputBox(
              keyboard: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Username,Email or Mobile number to login';
                }
                return null;
              },
              hintText: 'User name,Email or Mobile number',
              textController: identifierController),
          BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityChange>(
            builder: (context, state) {
              return InputBox(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Password to login';
                  }
                  return null;
                },
                obscureText: !context
                    .read<PasswordVisibilityBloc>()
                    .isFieldVisible(loginPasswordFieldId),
                hintText: 'Password',
                textController: passwordController,
                iconSuffix: GestureDetector(
                  onTap: () => context.read<PasswordVisibilityBloc>().add(
                      const TogglePasswordVisibility(loginPasswordFieldId)),
                  child: Icon(
                    context
                            .read<PasswordVisibilityBloc>()
                            .isFieldVisible(loginPasswordFieldId)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 15,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

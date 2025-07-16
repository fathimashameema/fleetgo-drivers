
import 'forgot_password.dart';
import '../../../widgets/input_box.dart';
import '../../../widgets/page_heading.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/icons/icons.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: TIcons.backButton),
              const PageHeading(
                mainHeading: 'Login',
                subHeading: 'Provide your info',
              )
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          InputBox(
              hintText: 'User name,Email or Mobile number',
              textController: usernameController),
          InputBox(hintText: 'Password', textController: passwordController),
          Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const ForgotPassword()));
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
                width: 120,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Login'))),
          )
        ],
      )),
    );
  }
}

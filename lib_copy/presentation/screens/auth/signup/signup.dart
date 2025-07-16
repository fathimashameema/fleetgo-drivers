
import 'otp_verification.dart';
import '../../../widgets/input_box.dart';
import '../../../widgets/page_heading.dart';
import '../../../../resources/icons/icons.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();

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
                  mainHeading: 'Create Account',
                  subHeading: 'Provide your info',
                )
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Column(
              children: [
                InputBox(
                  textController: usernameController,
                  hintText: 'User name',
                ),
                InputBox(
                  textController: numberController,
                  hintText: 'Mobile number',
                ),
                InputBox(
                  textController: emailController,
                  hintText: 'Email address',
                ),
                InputBox(
                  textController: passwordController,
                  hintText: 'Password',
                ),
                InputBox(
                  textController: confirmPassController,
                  hintText: 'Confirm password',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Text(
                        'Get OTP via SMS',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text(
                        'Get OTP via Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )
                ],
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const OtpVerification()));
                      },
                      child: const Text('Get OTP'))),
            )
          ],
        ),
      ),
    );
  }
}

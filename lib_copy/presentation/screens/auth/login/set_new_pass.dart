
import 'forgot_password.dart';
import 'password_changed.dart';
import '../../../widgets/input_box.dart';
import '../../../widgets/page_heading.dart';
import '../../../../resources/icons/icons.dart';
import 'package:flutter/material.dart';

class SetNewPass extends StatelessWidget {
  const SetNewPass({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: TIcons.backButton),
              ),
              const Expanded(
                child: PageHeading(
                  mainHeading: 'Create new password',
                  subHeading:
                      'Create a new password which is different from the old ones.',
                ),
              )
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          InputBox(hintText: 'Password', textController: usernameController),
          InputBox(
              hintText: 'Confirm password', textController: passwordController),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const ForgotPassword()));
              },
              child: Text(
                'Both passwords must match',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.start,
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
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const PasswordChanged()));
                    },
                    child: const Text('Reset'))),
          )
        ],
      )),
    );
  }
}

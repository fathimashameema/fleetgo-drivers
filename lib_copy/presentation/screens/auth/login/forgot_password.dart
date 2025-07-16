
import 'get_code.dart';
import '../../../widgets/input_box.dart';
import '../../../widgets/page_heading.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/icons/icons.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();

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
                mainHeading: 'Forgot password?!',
                subHeading: 'Restore your account',
              )
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          InputBox(
              hintText: 'Email or Username',
              textController: usernameController),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
              ),
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'We will send you an email with link to reset your password.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: TColors.grey,
                    thickness: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or"),
                ),
                Expanded(
                  child: Divider(
                    color: TColors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          InputBox(
              hintText: 'Use Mobile number instead',
              textController: numberController),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const GetCode()));
                    },
                    child: const Text('Continue'))),
          )
        ],
      )),
    );
  }
}

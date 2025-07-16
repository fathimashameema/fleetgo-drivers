
import 'set_new_pass.dart';
import '../../../widgets/input_box.dart';
import '../../../../resources/icons/icons.dart';
import '../../../../resources/images/images.dart';
import 'package:flutter/material.dart';

class GetCode extends StatelessWidget {
  const GetCode({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: TIcons.backButton),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    'We’ve sent a code to your email.Enter that code to confirm your account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 20),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Image.asset(
            TImages.verifyCode,
            width: screenWidth * 0.4,
            height: screenHeight * 0.4,
          ),
          InputBox(hintText: 'Enter code', textController: codeController),
          Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'It may take few minutes to get this code.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Get a new code',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
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
                          builder: (ctx) => const SetNewPass()));
                    },
                    child: const Text('Continue'))),
          )
        ],
      )),
    );
  }
}

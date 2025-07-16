import 'login/login.dart';
import 'signup/signup.dart';
import '../../widgets/welcome_text.dart';
import '../../../resources/colors/colors.dart';
import '../../../resources/images/images.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const WelcomeText(),
            Image.asset(TImages.welcomeImage),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextButton.icon(
                      icon: Image.asset(
                        TImages.googleLogo,
                        width: 25,
                        height: 25,
                      ),
                      onPressed: () {},
                      label: Text(
                        'Sign in with Google',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextButton.icon(
                      icon: Image.asset(TImages.logo, width: 30, height: 30),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const Signup()),
                        );
                      },
                      label: Text(
                        'Create an Account',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => const Login()),
                          );
                        },
                        child: Text(
                          'sign in',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            color: TColors.headingTexts,
                            decoration: TextDecoration.underline,
                            decorationColor: TColors.headingTexts,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    children: [
                      Text(
                        'By using this app, you agree to our ',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'privacy policy ',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            color: TColors.headingTexts,
                            decoration: TextDecoration.underline,
                            decorationColor: TColors.headingTexts,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Text(
                        'and ',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'terms and conditions ',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            color: TColors.headingTexts,
                            decoration: TextDecoration.underline,
                            decorationColor: TColors.headingTexts,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

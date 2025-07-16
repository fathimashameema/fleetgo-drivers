import 'package:fleetgo_drivers/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('driver home page'),
            ElevatedButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutRequired());
                },
                child: const Text('sign out')),
          ],
        ),
      ),
    );
  }
}

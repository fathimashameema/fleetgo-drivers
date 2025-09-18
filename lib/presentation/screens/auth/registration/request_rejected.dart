import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/welcome.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestRejected extends StatelessWidget {
  const RequestRejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            TImages.requestRejected,
            height: 252,
            width: 236,
          ),
          Text(
            'Oops!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              textAlign: TextAlign.center,
              'Admin suggest that you can\'t onboard with us now. Please recheck your documents or try to register with a new account. ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
              width: 100,
              child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationBloc>().add(const DeleteUser());

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const Welcome()));
                  },
                  child: const Text('Try again')))
        ],
      ),
    );
  }
}

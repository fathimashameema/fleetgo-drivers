import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetgo_drivers/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:fleetgo_drivers/bloc/store_documents_bloc/store_documents_bloc.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/bloc/email_verification_bloc/email_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:fleetgo_drivers/bloc/mobile_verififcation_bloc/mobile_verification_bloc.dart';
import 'package:fleetgo_drivers/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:fleetgo_drivers/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:fleetgo_drivers/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:fleetgo_drivers/bloc/sms_email_checkBox_bloc/sms_email_check_box_bloc.dart';
import 'package:fleetgo_drivers/bloc/driver_exist_bloc/is_driver_exist_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_profile.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/complete_registration.dart';

import 'package:fleetgo_drivers/presentation/screens/auth/registration/driver_or_renter.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/reviewing_request.dart';
import 'package:fleetgo_drivers/presentation/screens/auth/registration/vehicle_registration.dart';

import 'package:fleetgo_drivers/presentation/screens/auth/welcome.dart';
import 'package:fleetgo_drivers/presentation/screens/home/home_page.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:shimmer/shimmer.dart';

class MyApp extends StatelessWidget {
  final DriverRepo driverRepository;
  final FirestoreRepo firestoreRepository;
  final FirebaseStorageRepository storageRepository;
  final User? currentUser;
  const MyApp({
    super.key,
    required this.driverRepository,
    required this.firestoreRepository,
    required this.storageRepository,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
              driverResporitory: driverRepository,
              firestoreRepository: firestoreRepository,
              currentUser: currentUser),
        ),
        BlocProvider(
          create: (context) => SignInBloc(driverRepository: driverRepository),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(
            driverRepository: driverRepository,
            firestoreRepository: firestoreRepository,
          ),
        ),
        BlocProvider(create: (context) => PasswordVisibilityBloc()),
        BlocProvider(
          create: (context) => EmailVerificationBloc(
            firestoreRepository: firestoreRepository,
            driverRepository: driverRepository,
          ),
        ),
        BlocProvider(
          create: (context) =>
              MobileVerificationBloc(myUserRepository: driverRepository),
        ),
        BlocProvider(create: (context) => SmsEmailCheckBoxBloc()),
        BlocProvider(
          create: (context) =>
              IsDriverExistBloc(firestoreRepository: firestoreRepository),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordBloc(
            driverRepository: driverRepository,
            firestoreRepo: firestoreRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CheckBoxBloc(firestoreRepository),
        ),
        BlocProvider(
          create: (context) => StoreDocumentsBloc(
              storageRepository, firestoreRepository, currentUser),
        ),
      ],
      child: MaterialApp(
        theme: TAppTheme.lightTheme,
        themeMode: ThemeMode.system,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        // home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        //   builder: (context, state) {
        //     // if (state.status == AuthenticationStatus.profileIncomplete) {
        //     //   return const CompleteProfile();
        //     // } else if (state.status == AuthenticationStatus.authenticated) {
        //     //   return const HomePage();
        //     // }  else {
        //     //   return const Welcome();
        //     // }

        //     switch (state.status) {
        //       case AuthenticationStatus.loading:
        //         return Shimmer.fromColors(
        //             baseColor: TColors.darkgGey,
        //             highlightColor: TColors.grey,
        //             child: const DriverOrRenter());
        //       case AuthenticationStatus.profileIncomplete:
        //         return const DriverOrRenter();
        //       case AuthenticationStatus.authenticated:
        //         return const HomePage();
        //       case AuthenticationStatus.unauthenticated:
        //         return const Welcome();
        //       default:
        //         return Shimmer.fromColors(
        //             baseColor: TColors.darkgGey,
        //             highlightColor: TColors.grey,
        //             child: const DriverOrRenter());
        //     }
        //   },
        // ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.loading) {
              return Shimmer.fromColors(
                baseColor: TColors.darkgGey,
                highlightColor: TColors.grey,
                child: const DriverOrRenter(),
              );
            }

            if (state.status == AuthenticationStatus.unauthenticated ||
                state.status == AuthenticationStatus.unknown) {
              return const Welcome();
            }

            if (state.status == AuthenticationStatus.profileIncomplete ||
                state.status == AuthenticationStatus.authenticated) {
              final progress = state.registrationProgress;

              if (progress == 0) {
                return const DriverOrRenter();
              } else if (progress == 1) {
                return const CompleteProfile(); // Next step
              } else if (progress == 2) {
                return const VehicleRegistration(
                  driverOrRenter: 'taxi',
                ); // Last step
              } else if (progress == 3) {
                return const CompleteRegistration();
              } else {
                return const ReviewingRequest(); // Fully registered
              }
            }

            return const Welcome(); // fallback
          },
        ),
      ),
    );
  }
}

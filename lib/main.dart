import 'package:driver_repository/driver_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleetgo_drivers/my_app.dart';
import 'package:fleetgo_drivers/simple_bloc_observer.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA48zEzLIHjMau1fOjRkq1T3ROQF6JIKnI",
            authDomain: "fleetgo-c76c3.firebaseapp.com",
            projectId: "fleetgo-c76c3",
            storageBucket: "fleetgo-c76c3.firebasestorage.app",
            messagingSenderId: "1097929083749",
            appId: "1:1097929083749:web:d646269fc7b87a6eca2f8c",
            measurementId: "G-7W87ZGVRH5"));
  } else {
    await Firebase.initializeApp();
  }
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(
    driverRepository: FirebaseDriverRepository(),
    firestoreRepository: FirestoreDriverRepository(),
  ));
}

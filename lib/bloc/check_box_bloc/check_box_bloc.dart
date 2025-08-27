import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'check_box_event.dart';
part 'check_box_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  final FirestoreRepo _firestoreRepo;
  CheckBoxBloc(FirestoreRepo firestoreRepository)
      : _firestoreRepo = firestoreRepository,
        super(const SelectedRole(0)) {
    on<SelectRole>((event, emit) async {
      emit(CheckBoxLoading());
      try {
        log('check box clicked');
        User? user = FirebaseAuth.instance.currentUser;
        // Wait briefly for auth state if not immediately available
        if (user == null) {
          try {
            user = await FirebaseAuth.instance
                .authStateChanges()
                .firstWhere((u) => u != null)
                .timeout(const Duration(seconds: 2));
          } catch (_) {
            // ignore timeout and handle as failure below
          }
        }

        final uid = user?.uid;
        if (uid == null) {
          throw Exception('No authenticated user found');
        }

        log(uid);
        await _firestoreRepo.setRole(
            uid, event.selectedValue == 0 ? 'Driver' : 'Renter');
        emit(SelectedRole(event.selectedValue));
      } catch (e) {
        log(e.toString());
        emit(CheckBoxFailed());
      }
    });

    on<SelectVehicle>((event, emit) {
      log('check box clicked');
      emit(SelectedVehicle(event.selectedValue));
    });
  }
}

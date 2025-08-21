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
        final uid = FirebaseAuth.instance.currentUser!.uid;
        log(uid);
        await firestoreRepository.setRole(
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

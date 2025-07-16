import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'is_driver_exist_event.dart';
part 'is_driver_exist_state.dart';

class IsDriverExistBloc extends Bloc<IsDriverExistEvent, IsDriverExistState> {
  final FirestoreRepo _firestoreRepo;
  IsDriverExistBloc({required FirestoreRepo firestoreRepository})
      : _firestoreRepo = firestoreRepository,
        super(IsDriverExistInitial()) {
    on<IsDriverExist>((event, emit) async {
      log('isDriverExist called');
      try {
        log('isDriverExist called in try');

        bool isNameExist = await _firestoreRepo.isUsernameExit(event.userName);
        bool isEmailExist = await _firestoreRepo.isEmailExit(event.email);
        bool isNumberExist = await _firestoreRepo.isPhoneExit(event.number);

        log('driver exist value in bloc $isNameExist');

        if (isNameExist == true) {
          emit(DriverExist(isNameExist,
              'Username already exist. Try using a different one!'));
          log('emited driver exist state');
        } else if (isEmailExist) {
          emit(DriverExist(isEmailExist,
              'An account is already registered with this Email.'));
          log('emited driver exist state');
        } else if (isNumberExist) {
          emit(DriverExist(isNumberExist,
              'Mobile number is already registered with an account.'));
          log('emited driver exist state');
        }
      } catch (e) {
        log('error in checking if driver exist : ${e.toString()}');
      }
    });
    on<ClearDriverExistState>((event, emit) {
      emit(IsDriverExistInitial());
    });
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'mobile_verification_event.dart';
part 'mobile_verification_state.dart';

class MobileVerificationBloc
    extends Bloc<MobileVerificationEvent, MobileVerificationState> {
  final DriverRepo _driverRepository;
  MobileVerificationBloc({
    required DriverRepo myUserRepository,
  })  : _driverRepository = myUserRepository,
        super(MobileVerificationInitial()) {
    on<VerifyPhone>((event, emit) async {
      emit(MobileVerificationLoading());
      try {
        await _driverRepository.verifyPhone(event.phone);
        emit(MobileVerificationSuccess());
      } catch (e) {
        log(e.toString());
        emit(MobileVerificationFailure());
      }
    });
  }
}

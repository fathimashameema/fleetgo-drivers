import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_box_event.dart';
part 'check_box_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc() : super(const SelectedRole(0)) {
    on<SelectRole>((event, emit) {
      log('check box clicked');
      emit(SelectedRole(event.selectedValue));
    });

    on<SelectVehicle>((event, emit) {
      log('check box clicked');
      emit(SelectedVehicle(event.selectedValue));
    });
  }
}

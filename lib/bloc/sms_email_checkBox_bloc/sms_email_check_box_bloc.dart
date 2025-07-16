import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sms_email_check_box_event.dart';
part 'sms_email_check_box_state.dart';

class SmsEmailCheckBoxBloc
    extends Bloc<SmsEmailCheckBoxEvent, SmsEmailCheckBoxState> {
  
  SmsEmailCheckBoxBloc(
      )
      : 
        super(SmsEmailCheckBoxState.initial()) {
    on<SelectSmsEvent>((event, emit) {
      emit(const SmsEmailCheckBoxState(
        isSmsSelected: true,
        isEmailSelected: false,
        selectedValue: 'sms',
      ));
    });

    on<SelectEmailEvent>((event, emit) {
      emit(const SmsEmailCheckBoxState(
        isSmsSelected: false,
        isEmailSelected: true,
        selectedValue: 'email',
      ));
    });

    
  }
}

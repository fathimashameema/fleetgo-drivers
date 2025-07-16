part of 'sms_email_check_box_bloc.dart';

abstract class SmsEmailCheckBoxEvent extends Equatable {
  const SmsEmailCheckBoxEvent();

  @override
  List<Object> get props => [];
}

class SelectSmsEvent extends SmsEmailCheckBoxEvent {}

class SelectEmailEvent extends SmsEmailCheckBoxEvent {}



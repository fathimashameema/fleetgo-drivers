part of 'sms_email_check_box_bloc.dart';

class SmsEmailCheckBoxState extends Equatable {
  final bool isSmsSelected;
  final bool isEmailSelected;
  final String selectedValue;

  const SmsEmailCheckBoxState({
    required this.isSmsSelected,
    required this.isEmailSelected,
    required this.selectedValue,
  });

  factory SmsEmailCheckBoxState.initial() {
    return const SmsEmailCheckBoxState(
      isSmsSelected: false,
      isEmailSelected: false,
      selectedValue: '',
    );
  }

  @override
  List<Object> get props => [isSmsSelected, isEmailSelected, selectedValue];
}



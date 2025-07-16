part of 'check_box_bloc.dart';

abstract class CheckBoxEvent extends Equatable {
  const CheckBoxEvent();

  @override
  List<Object> get props => [];
}

class SelectRole extends CheckBoxEvent {
  final int selectedValue;
  const SelectRole({
    required this.selectedValue,
  });
}

class SelectVehicle extends CheckBoxEvent {
  final int selectedValue;
  const SelectVehicle({
    required this.selectedValue,
  });
}

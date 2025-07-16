part of 'check_box_bloc.dart';

abstract class CheckBoxState extends Equatable {
  const CheckBoxState();

  @override
  List<Object> get props => [];
}

final class CheckBoxInitial extends CheckBoxState {}

final class SelectedRole extends CheckBoxState {
  final int selectedValue;

  const SelectedRole(this.selectedValue);
  @override
  List<Object> get props => [selectedValue];
}

final class SelectedVehicle extends CheckBoxState {
  final int selectedValue;

  const SelectedVehicle(this.selectedValue);
  @override
  List<Object> get props => [selectedValue];
}

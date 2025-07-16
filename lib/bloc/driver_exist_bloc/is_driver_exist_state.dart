part of 'is_driver_exist_bloc.dart';

sealed class IsDriverExistState extends Equatable {
  const IsDriverExistState();

  @override
  List<Object> get props => [];
}

final class IsDriverExistInitial extends IsDriverExistState {}

class DriverExist extends IsDriverExistState {
  final bool isDriverExist;
  final String error;
  const DriverExist(this.isDriverExist, this.error);
}

part of 'is_driver_exist_bloc.dart';

abstract class IsDriverExistEvent extends Equatable {
  const IsDriverExistEvent();

  @override
  List<Object> get props => [];
}

class IsDriverExist extends IsDriverExistEvent {
  final String userName;
  final String email;
  final String number;
  const IsDriverExist({
    required this.userName,
    required this.email,
    required this.number,
  });
}

class ClearDriverExistState extends IsDriverExistEvent {}

part of 'password_visibility_bloc.dart';

abstract class PasswordVisibilityState extends Equatable {
  const PasswordVisibilityState();

  @override
  List<Object> get props => [];
}

final class PasswordVisibilityInitial extends PasswordVisibilityState {}

class PasswordVisibilityChange extends Equatable {
  final Map<String, bool> fieldVisibility;

  const PasswordVisibilityChange({
    required this.fieldVisibility,
  });

  PasswordVisibilityChange copyWith({
    Map<String, bool>? fieldVisibility,
  }) {
    return PasswordVisibilityChange(
      fieldVisibility: fieldVisibility ?? this.fieldVisibility,
    );
  }

  @override
  List<Object?> get props => [fieldVisibility];
}

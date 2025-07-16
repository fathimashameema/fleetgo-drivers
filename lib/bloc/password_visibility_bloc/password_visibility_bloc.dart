import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_visibility_event.dart';
part 'password_visibility_state.dart';

class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityChange> {
  PasswordVisibilityBloc()
      : super(const PasswordVisibilityChange(fieldVisibility: {})) {
    on<TogglePasswordVisibility>((event, emit) {
      final currentState = state;
      final updatedVisibility =
          Map<String, bool>.from(currentState.fieldVisibility);
      updatedVisibility[event.fieldId] =
          !(updatedVisibility[event.fieldId] ?? false);
      emit(PasswordVisibilityChange(fieldVisibility: updatedVisibility));
    });

    on<ResetPasswordVisibility>((event, emit) {
      final currentState = state;
      final updatedVisibility = Map<String, bool>.from(currentState.fieldVisibility);
      updatedVisibility[event.fieldId] = false; // Reset to default (hidden)
      emit(PasswordVisibilityChange(fieldVisibility: updatedVisibility));
    });
  }

  bool isFieldVisible(String fieldId) {
    return state.fieldVisibility[fieldId] ?? true;
  }
}

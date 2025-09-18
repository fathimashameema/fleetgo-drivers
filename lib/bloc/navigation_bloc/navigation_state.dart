part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  final int selectedIndex;
  const NavigationState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0); // default = first tab
}

class NavigationUpdated extends NavigationState {
  const NavigationUpdated(super.index);
}

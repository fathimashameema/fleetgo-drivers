part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavItemSelected extends NavigationEvent {
  final int index;
  const NavItemSelected(this.index);

  @override
  List<Object?> get props => [index];
}

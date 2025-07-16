import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String email;
  final String name;
  final String number;
  final String? profile;
  final String password;
  final bool isProfileComplete;

  const Driver({
    required this.id,
    required this.email,
    required this.name,
    required this.number,
    this.profile,
    required this.password,
    this.isProfileComplete = false,
  });

  static const emptyUser = Driver(
      id: '',
      email: '',
      name: '',
      number: '',
      profile: '',
      password: '',
      isProfileComplete: false);

  Driver copyWith({
    String? id,
    String? email,
    String? name,
    String? number,
    String? profile,
    String? password,
    bool? isProfileComplete,
  }) {
    return Driver(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      number: number ?? this.number,
      password: password ?? this.password,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  bool get isEmpty => this == Driver.emptyUser;
  bool get isNotEmpty => this != Driver.emptyUser;

  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      email: email,
      name: name,
      number: number,
      profile: profile,
      password: password,
      isProfileComplete: isProfileComplete,
    );
  }

  static Driver fromEntity(DriverEntity entity) {
    return Driver(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      profile: entity.profile,
      number: entity.number,
      password: entity.password,
      isProfileComplete: entity.isProfileComplete,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        number,
        profile,
        password,
        isProfileComplete,
      ];
}

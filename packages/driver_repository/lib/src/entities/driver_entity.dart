import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String number;
  final String? profile;
  final String password;
  final bool isProfileComplete;
  final int registrationProgress;
  final String role;

  const DriverEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.number,
    this.profile,
    required this.password,
    this.isProfileComplete = false,
    required this.registrationProgress,
    required this.role,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'number': number,
      'profile': profile,
      'password': password,
      'isProfileComplete': isProfileComplete,
      'registrationProgress': registrationProgress,
      'role': role,
    };
  }

  static DriverEntity fromDocument(Map<String, Object?> doc) {
    return DriverEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      profile: doc['profile'] as String,
      number: doc['number'] as String,
      password: doc['password'] as String,
      isProfileComplete: doc['isProfileComplete'] as bool,
      registrationProgress: doc['registrationProgress'] as int,
      role: doc['role'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        profile,
        password,
        isProfileComplete,
        registrationProgress,
        role
      ];

  @override
  String toString() {
    return 'DriverEntity(id: $id, email: $email, name: $name,number:$number, profile: $profile , password:$password , isProfileComplete:$isProfileComplete, registrationProgress:$registrationProgress, role:$role)';
  }
}

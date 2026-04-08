import 'package:equatable/equatable.dart';

class UserAuthEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;
  final DateTime? birthDate;
  final int? age;
  final String? gender;
  final String? phoneNumber;

  const UserAuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    this.birthDate,
    this.age,
    this.gender,
    this.phoneNumber,
  });

  UserAuthEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? token,
    DateTime? birthDate,
    int? age,
    String? gender,
    String? phoneNumber,
  }) {
    return UserAuthEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    password,
    token,
    birthDate,
    age,
    gender,
    phoneNumber,
  ];
}

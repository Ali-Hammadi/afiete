import 'package:equatable/equatable.dart';

class UserAuthEntity extends Equatable {
  final String username;
  final String nickname;
  final String email;
  final String password;
  final String token;
  final bool isVerified;
  final DateTime? birthDate;
  final int? age;
  final String? gender;
  final String? phoneNumber;

  const UserAuthEntity({
    this.username = '',
    required this.nickname,
    required this.email,
    required this.password,
    required this.token,
    this.isVerified = true,
    this.birthDate,
    this.age,
    this.gender,
    this.phoneNumber,
  });

  UserAuthEntity copyWith({
    String? id,
    String? username,
    String? nickname,
    String? email,
    String? password,
    String? token,
    bool? isVerified,
    DateTime? birthDate,
    int? age,
    String? gender,
    String? phoneNumber,
  }) {
    return UserAuthEntity(
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      isVerified: isVerified ?? this.isVerified,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    username,
    nickname,
    email,
    password,
    token,
    isVerified,
    birthDate,
    age,
    gender,
    phoneNumber,
  ];
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String? nickname;
  final String email;
  final String password;
  final String token;
  final bool isVerified;
  final DateTime? birthDate;
  final int? age;
  final String? gender;
  final String? phoneNumber;

  const UserModel({
    required this.id,
    this.username = '',
    this.nickname,
    required this.email,
    required this.password,
    required this.token,
    this.isVerified = true,
    this.birthDate,
    this.age,
    this.gender,
    this.phoneNumber,
  });

  static Map<String, dynamic> signupRequestBody({
    required String nickname,
    required String email,
    required String password,
  }) {
    return {
      'user': {'nickname': nickname, 'email': email, 'password': password},
    };
  }

  UserModel copyWith({
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
    return UserModel(
      id: id ?? this.id,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = (json['user'] as Map<String, dynamic>?) ?? json;
    final mergedJson = <String, dynamic>{...json, ...userJson};
    final birthDateValue = (mergedJson['birthDate'] ?? mergedJson['birth_date'])
        ?.toString();
    final birthDate = birthDateValue != null
        ? DateTime.tryParse(birthDateValue)
        : null;

    return UserModel(
      id: (mergedJson['id'] ?? mergedJson['user_id'] ?? '').toString(),
      username:
          (mergedJson['username'] ??
                  mergedJson['nickname'] ??
                  mergedJson['name'] ??
                  '')
              .toString()
              .trim(),
      name:
          (mergedJson['name'] ??
                  mergedJson['nickname'] ??
                  '${mergedJson['first_name'] ?? ''} ${mergedJson['last_name'] ?? ''}')
              .toString()
              .trim(),
      nickname: mergedJson['nickname'] ?? "".toString(),
      email: (mergedJson['email'] ?? '').toString(),
      password: (mergedJson['password'] ?? '').toString(),
      token: (mergedJson['token'] ?? mergedJson['access'] ?? '').toString(),
      isVerified:
          (mergedJson['is_verified'] ?? mergedJson['isVerified'])
              ?.toString()
              .toLowerCase() ==
          'true',
      birthDate: birthDate,
      age: mergedJson['age'] is int
          ? mergedJson['age'] as int
          : int.tryParse('${mergedJson['age'] ?? ''}'),
      gender: mergedJson['gender']?.toString(),
      phoneNumber: (mergedJson['phoneNumber'] ?? mergedJson['phone'])
          ?.toString(),
    );
  }

  UserAuthEntity toEntity() => UserAuthEntity(
    id: id,
    username: username,
    nickname: nickname,
    email: email,
    password: password,
    token: token,
    isVerified: isVerified,
    birthDate: birthDate,
    age: age,
    gender: gender,
    phoneNumber: phoneNumber,
  );

  @override
  List<Object?> get props => [
    id,
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

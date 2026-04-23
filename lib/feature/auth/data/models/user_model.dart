import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;
  final DateTime? birthDate;
  final int? age;
  final String? gender;
  final String? phoneNumber;

  const UserModel({
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

  UserModel copyWith({
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
    return UserModel(
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: (json['id'] ?? json['user_id'] ?? '').toString(),
    name:
      (json['name'] ??
          json['nickname'] ??
          '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}')
        .toString()
        .trim(),
    email: (json['email'] ?? '').toString(),
    password: (json['password'] ?? '').toString(),
    token: (json['token'] ?? json['access'] ?? '').toString(),
    birthDate: (json['birthDate'] ?? json['birth_date']) != null
      ? DateTime.tryParse((json['birthDate'] ?? json['birth_date']).toString())
        : null,
    age: json['age'] is int
        ? json['age'] as int
        : int.tryParse('${json['age'] ?? ''}'),
    gender: json['gender']?.toString(),
    phoneNumber: (json['phoneNumber'] ?? json['phone'])?.toString(),
  );

  UserAuthEntity toEntity() => UserAuthEntity(
    id: id,
    name: name,
    email: email,
    password: password,
    token: token,
    birthDate: birthDate,
    age: age,
    gender: gender,
    phoneNumber: phoneNumber,
  );

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

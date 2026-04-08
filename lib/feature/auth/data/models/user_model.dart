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
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    token: json['token'] ?? '',
    birthDate: json['birthDate'] != null
        ? DateTime.tryParse(json['birthDate'].toString())
        : null,
    age: json['age'] is int ? json['age'] as int : int.tryParse('${json['age'] ?? ''}'),
    gender: json['gender']?.toString(),
    phoneNumber: json['phoneNumber']?.toString(),
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

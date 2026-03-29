import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    token: json['token'] ?? '',
  );

  UserAuthEntity toEntity() => UserAuthEntity(
    id: id,
    name: name,
    email: email,
    password: password,
    token: token,
  );

  @override
  List<Object?> get props => [id, name, email, password, token];
}

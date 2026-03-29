import 'package:equatable/equatable.dart';

class UserAuthEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;

  const UserAuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, password, token];
}

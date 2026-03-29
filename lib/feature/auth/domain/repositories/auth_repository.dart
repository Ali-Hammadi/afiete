import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserAuthEntity>> login(String email, String password);
  Future<Either<Failure, UserAuthEntity>> signup(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, UserAuthEntity>> logout(String email, String password);
  Future<Either<Failure, UserAuthEntity>> deleteAccount(
    String email,
    String password,
  );
  Future<Either<Failure, UserAuthEntity>> googleSignIn();
}

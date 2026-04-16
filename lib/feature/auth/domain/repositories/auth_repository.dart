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
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  });

  Future<Either<Failure, String>> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  });

  Future<Either<Failure, UserAuthEntity>> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  });
}

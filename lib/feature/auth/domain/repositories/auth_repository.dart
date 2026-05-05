import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserAuthEntity>> login(String email, String password);
  Future<Either<Failure, UserAuthEntity>> fetchProfile();
  Future<void> cacheSession(UserAuthEntity user);
  Future<UserAuthEntity?> getCachedSession();
  Future<void> clearCachedSession();
  Future<Either<Failure, UserAuthEntity>> signup(
    String nickname,
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
    String? nickname,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  });

  Future<Either<Failure, String>> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  });

  Future<Either<Failure, String>> requestEmailChangeWithPassword({
    required String email,
    required String password,
    required String newEmail,
  });

  /// Verifies OTP for authentication/login purposes (SEPARATE from email change verification).
  /// Used when user logs in with OTP instead of password.
  Future<Either<Failure, UserAuthEntity>> verifyOtp(String email, String otp);

  /// Confirms email change by verifying OTP (SEPARATE from login verification).
  /// Used when user changes their email address.
  Future<Either<Failure, UserAuthEntity>> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  });

  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [AuthRepository] that wraps [AuthRemoteDataSource] with error handling.
/// All DioException are caught and converted to ServerFailure.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  // ==================== SIGNUP FLOW ====================

  @override
  Future<Either<Failure, OtpEntity>> signup({
    required String nickname,
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signup(nickname, email, password);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> verifySignupOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final model = await _remoteDataSource.verifySignupOtp(email, otpCode);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== LOGIN ====================

  @override
  Future<Either<Failure, UserAuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(email, password);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== PROFILE ====================

  @override
  Future<Either<Failure, UserAuthEntity>> fetchProfile() async {
    try {
      final model = await _remoteDataSource.fetchProfile();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfileInfo(
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== PASSWORD RECOVERY ====================

  @override
  Future<Either<Failure, OtpEntity>> requestForgotPasswordOtp({
    required String email,
  }) async {
    try {
      final model = await _remoteDataSource.requestForgotPasswordOtp(email);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpEntity>> verifyForgotPasswordOtp({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final model = await _remoteDataSource.verifyForgotPasswordOtp(
        email,
        otpCode,
        newPassword,
        confirmPassword,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String password,
  }) async {
    try {
      await _remoteDataSource.deleteAccount(password);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final model = await _remoteDataSource.verifyOtp(email, otpCode);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpEntity>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final model = await _remoteDataSource.verifyForgotPasswordOtp(
        email,
        otpCode,
        newPassword,
        confirmPassword,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== LOCAL CACHE HELPERS ====================

  static const String _cachedUserKey = 'auth_cached_user';

  @override
  Future<void> cacheSession(UserAuthEntity user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_cachedUserKey, jsonEncode(_encodeUser(user)));
  }

  @override
  Future<UserAuthEntity?> getCachedSession() async {
    final preferences = await SharedPreferences.getInstance();
    final cached = preferences.getString(_cachedUserKey);
    if (cached == null || cached.isEmpty) return null;
    try {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      return _decodeUser(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCachedSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cachedUserKey);
  }

  Map<String, dynamic> _encodeUser(UserAuthEntity user) {
    return {
      'username': user.username,
      'nickname': user.nickname,
      'email': user.email,
      'birthDate': user.birthDate?.toIso8601String(),
      'gender': user.gender,
      'phoneNumber': user.phoneNumber,
      'isVerified': user.isVerified,
      'accessToken': user.accessToken,
      'refreshToken': user.refreshToken,
      'password': user.password,
    };
  }

  UserAuthEntity _decodeUser(Map<String, dynamic> json) {
    return UserAuthEntity(
      username: json['username']?.toString() ?? '',
      nickname: json['nickname']?.toString(),
      email: json['email']?.toString() ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      gender: json['gender']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      isVerified: json['isVerified'] == true || json['is_verified'] == true,
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      password: json['password']?.toString(),
    );
  }

  // ==================== SENSITIVE UPDATES ====================

  @override
  Future<Either<Failure, UserAuthEntity>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final model = await _remoteDataSource.updatePassword(
        currentPassword,
        newPassword,
        confirmPassword,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== OAUTH ====================

  @override
  Future<Either<Failure, UserAuthEntity>> googleSignIn({
    required String idToken,
  }) async {
    try {
      final model = await _remoteDataSource.googleSignIn(idToken);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

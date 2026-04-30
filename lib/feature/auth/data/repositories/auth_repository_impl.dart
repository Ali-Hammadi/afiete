import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _cachedUserKey = 'auth_cached_user';
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserAuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.login(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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
      'nickName': user.nickname,
      'email': user.email,
      'password': user.password,
      'token': user.token,
      'isVerified': user.isVerified,
      'birthDate': user.birthDate?.toIso8601String(),
      'age': user.age,
      'gender': user.gender,
      'phoneNumber': user.phoneNumber,
    };
  }

  UserAuthEntity _decodeUser(Map<String, dynamic> json) {
    return UserAuthEntity(
      username: json['username']?.toString() ?? '',

      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      isVerified:
          json['isVerified'] == true ||
          json['is_verified'] == true ||
          json['isVerified']?.toString().toLowerCase() == 'true',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse('${json['age'] ?? ''}'),
      gender: json['gender']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      nickname: json['nickname']?.toString() ?? '',
    );
  }

  @override
  Future<Either<Failure, UserAuthEntity>> deleteAccount(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.deleteAccount(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> logout(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.logout(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> signup(
    String nickname,
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.signup(
        nickname,
        email,
        password,
      );
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> googleSignIn() async {
    try {
      final remoteUser = await remoteDataSource.googleSignIn();
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    required String userId,
    String? nickname,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  }) async {
    try {
      final remoteUser = await remoteDataSource.updateProfileInfo(
        userId: userId,
        nickname: nickname,
        birthDate: birthDate,
        gender: gender,
        phoneNumber: phoneNumber,
      );
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  }) async {
    try {
      final result = await remoteDataSource.requestEmailChangeOtp(
        userId: userId,
        newEmail: newEmail,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> verifyOtp(
    String email,
    String code,
  ) async {
    try {
      final remoteUser = await remoteDataSource.verifyOtp(email, code);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  }) async {
    try {
      final remoteUser = await remoteDataSource.confirmEmailChange(
        userId: userId,
        newEmail: newEmail,
        otp: otp,
      );
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final message = await remoteDataSource.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final message = await remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/network/token_storage.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afiete/core/utils/logger.dart';

/// Implementation of [AuthRepository] that wraps [AuthRemoteDataSource] with error handling.
/// All DioException are caught and converted to ServerFailure.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final _log = loggerFor('AuthRepository');

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  // ==================== SIGNUP FLOW ====================

  @override
  Future<Either<Failure, OtpEntity>> signup({
    required String nickname,
    required String email,
    required String password,
    String? correlationId,
  }) async {
    _log.info(
      'signup:start',
      data: {'cid': correlationId, 'email': email, 'nickname': nickname},
    );
    try {
      final model = await _remoteDataSource.signup(
        nickname,
        email,
        password,
        correlationId: correlationId,
      );
      _log.info('signup:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'signup:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'signup:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> verifySignupOtp({
    required String email,
    required String otpCode,
    String? password,
    String? correlationId,
  }) async {
    _log.info(
      'verifySignupOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final model = await _remoteDataSource.verifySignupOtp(
        email,
        otpCode,
        password: password,
        correlationId: correlationId,
      );
      _log.info('verifySignupOtp:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'verifySignupOtp:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'verifySignupOtp:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpEntity>> resendSignupOtp({
    required String email,
    String? correlationId,
  }) async {
    _log.info(
      'resendSignupOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final model = await _remoteDataSource.resendSignupOtp(
        email,
        correlationId: correlationId,
      );
      _log.info('resendSignupOtp:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'resendSignupOtp:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'resendSignupOtp:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== LOGIN ====================

  @override
  Future<Either<Failure, UserAuthEntity>> login({
    required String email,
    required String password,
    String? correlationId,
  }) async {
    _log.info('login:start', data: {'cid': correlationId, 'email': email});
    try {
      final model = await _remoteDataSource.login(
        email,
        password,
        correlationId: correlationId,
      );
      _log.info('login:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'login:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'login:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== PROFILE ====================

  @override
  Future<Either<Failure, UserAuthEntity>> fetchProfile({
    String? correlationId,
  }) async {
    _log.info('fetchProfile:start', data: {'cid': correlationId});
    try {
      final model = await _remoteDataSource.fetchProfile(
        correlationId: correlationId,
      );
      _log.info('fetchProfile:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'fetchProfile:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'fetchProfile:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? psychologicalHistory,
    String? nickname,
    String? correlationId,
  }) async {
    _log.info(
      'updateProfileInfo:start',
      data: {
        'cid': correlationId,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'phoneLength': phoneNumber?.length ?? 0,
        'hasPsychologicalHistory': psychologicalHistory != null,
        'nickname': nickname,
      },
    );
    try {
      final model = await _remoteDataSource.updateProfileInfo(
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        psychologicalHistory: psychologicalHistory,
        nickname: nickname,
        correlationId: correlationId,
      );
      _log.info(
        'updateProfileInfo:success',
        data: {
          'cid': correlationId,
          'hasBirthDate': model.dateOfBirth != null,
          'hasGender': model.gender != null,
          'hasPhoneNumber': model.phoneNumber != null,
        },
      );
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'updateProfileInfo:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'phoneLength': phoneNumber?.length ?? 0,
          'hasPsychologicalHistory': psychologicalHistory != null,
          'nickname': nickname,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'updateProfileInfo:exception',
        data: {
          'cid': correlationId,
          'error': e.toString(),
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'phoneLength': phoneNumber?.length ?? 0,
          'hasPsychologicalHistory': psychologicalHistory != null,
          'nickname': nickname,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== PASSWORD RECOVERY ====================

  @override
  Future<Either<Failure, OtpEntity>> requestForgotPasswordOtp({
    required String email,
    String? correlationId,
  }) async {
    _log.info(
      'requestForgotPasswordOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final model = await _remoteDataSource.requestForgotPasswordOtp(
        email,
        correlationId: correlationId,
      );
      _log.info(
        'requestForgotPasswordOtp:success',
        data: {'cid': correlationId},
      );
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'requestForgotPasswordOtp:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'requestForgotPasswordOtp:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpEntity>> verifyForgotPasswordOtp({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
    String? correlationId,
  }) async {
    _log.info(
      'verifyForgotPasswordOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final model = await _remoteDataSource.verifyForgotPasswordOtp(
        email,
        otpCode,
        newPassword,
        confirmPassword,
        correlationId: correlationId,
      );
      _log.info(
        'verifyForgotPasswordOtp:success',
        data: {'cid': correlationId},
      );
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'verifyForgotPasswordOtp:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'verifyForgotPasswordOtp:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  @override
  Future<Either<Failure, void>> logout({String? correlationId}) async {
    _log.info('logout:start', data: {'cid': correlationId});
    try {
      await _remoteDataSource.logout(correlationId: correlationId);
      _log.info('logout:success', data: {'cid': correlationId});
      return const Right(null);
    } on DioException catch (e, st) {
      _log.error(
        'logout:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'logout:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({String? correlationId}) async {
    _log.info('deleteAccount:start', data: {'cid': correlationId});
    try {
      await _remoteDataSource.deleteAccount(correlationId: correlationId);
      _log.info('deleteAccount:success', data: {'cid': correlationId});
      return const Right(null);
    } on DioException catch (e, st) {
      _log.error(
        'deleteAccount:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'deleteAccount:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> verifyOtp({
    required String email,
    required String otpCode,
    String? correlationId,
  }) async {
    _log.info('verifyOtp:start', data: {'cid': correlationId, 'email': email});
    try {
      final model = await _remoteDataSource.verifyOtp(
        email,
        otpCode,
        correlationId: correlationId,
      );
      _log.info('verifyOtp:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'verifyOtp:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'verifyOtp:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpEntity>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    String? correlationId,
  }) async {
    _log.info(
      'resetPassword:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final model = await _remoteDataSource.resetPassword(
        email,
        newPassword,
        confirmPassword,
        correlationId: correlationId,
      );
      _log.info('resetPassword:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'resetPassword:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'resetPassword:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== LOCAL CACHE HELPERS ====================

  static const String _cachedUserKey = 'auth_cached_user';
  static const String _cachedPendingSignupKey = 'auth_pending_signup_user';

  @override
  Future<void> cacheSession(
    UserAuthEntity user, {
    String? correlationId,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_cachedUserKey, jsonEncode(_encodeUser(user)));

    final accessToken = user.accessToken;
    final refreshToken = user.refreshToken;

    _log.info(
      'cacheSession:start',
      data: {
        'cid': correlationId,
        'email': user.email,
        'hasAccessToken': accessToken?.isNotEmpty == true,
        'hasRefreshToken': refreshToken?.isNotEmpty == true,
      },
    );

    if (accessToken == null || accessToken.isEmpty) {
      await TokenStorage.clearTokens();
      _log.warn(
        'cacheSession:cleared_tokens_missing_access',
        data: {'cid': correlationId},
      );
      return;
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      _log.info(
        'cacheSession:saved_access_and_refresh',
        data: {'cid': correlationId},
      );
    } else {
      await TokenStorage.saveToken(accessToken);
      _log.warn(
        'cacheSession:saved_access_only_no_refresh',
        data: {'cid': correlationId},
      );
    }
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
    await TokenStorage.clearTokens();
  }

  @override
  Future<void> cachePendingSignupSession(
    UserAuthEntity user, {
    String? correlationId,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _cachedPendingSignupKey,
      jsonEncode(_encodeUser(user)),
    );
    _log.info(
      'cachePendingSignupSession:saved',
      data: {'cid': correlationId, 'email': user.email},
    );
  }

  @override
  Future<UserAuthEntity?> getCachedPendingSignupSession() async {
    final preferences = await SharedPreferences.getInstance();
    final cached = preferences.getString(_cachedPendingSignupKey);
    if (cached == null || cached.isEmpty) return null;
    try {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      return _decodeUser(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearPendingSignupSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cachedPendingSignupKey);
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
    String? correlationId,
  }) async {
    _log.info('updatePassword:start', data: {'cid': correlationId});
    try {
      final model = await _remoteDataSource.updatePassword(
        currentPassword,
        newPassword,
        confirmPassword,
        correlationId: correlationId,
      );
      _log.info('updatePassword:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'updatePassword:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'updatePassword:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==================== OAUTH ====================

  @override
  Future<Either<Failure, UserAuthEntity>> googleSignIn({
    required String idToken,
    String? correlationId,
  }) async {
    _log.info('googleSignIn:start', data: {'cid': correlationId});
    try {
      final model = await _remoteDataSource.googleSignIn(
        idToken,
        correlationId: correlationId,
      );
      _log.info('googleSignIn:success', data: {'cid': correlationId});
      return Right(model.toEntity());
    } on DioException catch (e, st) {
      _log.error(
        'googleSignIn:error',
        data: {
          'cid': correlationId,
          'message': e.message,
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure.fromDioError(e));
    } catch (e, st) {
      _log.error(
        'googleSignIn:exception',
        data: {'cid': correlationId, 'error': e.toString()},
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}

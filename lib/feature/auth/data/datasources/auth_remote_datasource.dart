import 'package:dio/dio.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import '../models/models.dart';
import 'package:afiete/core/utils/logger.dart';

/// Abstract interface for remote authentication data source.
/// All methods return models (not entities).
/// No error handling at this level - let DioException propagate.
/// All authenticated methods expect token to be attached via Dio interceptor.
abstract class AuthRemoteDataSource {
  // Signup flow (2 endpoints)
  /// Step 1: Initiate signup - send nickname, email, password.
  /// Returns OtpModel with expiration info.
  /// Requires: None (unauthenticated)
  Future<OtpModel> signup(
    String nickname,
    String email,
    String password, {
    String? correlationId,
  });

  /// Step 2: Verify signup OTP and get authentication tokens.
  /// Returns UserModel with access+refresh tokens and profile data.
  /// Requires: None (unauthenticated)
  Future<UserModel> verifySignupOtp(
    String email,
    String otpCode, {
    String? correlationId,
  });

  // Login (1 endpoint)
  /// Login with email and password.
  /// Returns UserModel with access+refresh tokens.
  /// Requires: None (unauthenticated)
  Future<UserModel> login(
    String email,
    String password, {
    String? correlationId,
  });

  // Profile (2 endpoints)
  /// Fetch full profile of authenticated user.
  /// Returns UserModel with all profile data.
  /// Requires: access_token (via interceptor)
  Future<UserModel> fetchProfile({String? correlationId});

  /// Update profile info (dateOfBirth, gender, phoneNumber).
  /// All parameters are optional - only update provided fields.
  /// Returns updated UserModel.
  /// Requires: access_token (via interceptor)
  Future<UserModel> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? correlationId,
  });

  // Password recovery (2 endpoints)
  /// Step 1: Request OTP for password reset.
  /// Returns OtpModel with expiration info.
  /// Requires: None (unauthenticated)
  Future<OtpModel> requestForgotPasswordOtp(
    String email, {
    String? correlationId,
  });

  /// Step 2: Verify password reset OTP and change password.
  /// Returns OtpModel confirming completion.
  /// Requires: None (unauthenticated)
  Future<OtpModel> verifyForgotPasswordOtp(
    String email,
    String otpCode,
    String newPassword,
    String confirmPassword, {
    String? correlationId,
  });

  // Session management (3 endpoints)
  /// Logout and invalidate current session.
  /// Requires: access_token (via interceptor)
  Future<void> logout({String? correlationId});

  /// Delete account permanently (hard delete with verification).
  /// Requires: access_token (via interceptor) + password in body
  Future<void> deleteAccount(String password, {String? correlationId});

  /// Verify OTP for authentication/login purposes (OTP login flow).
  Future<UserModel> verifyOtp(
    String email,
    String otp, {
    String? correlationId,
  });

  /// Change password with current password verification.
  /// Returns updated UserModel.
  /// Requires: access_token (via interceptor)
  Future<UserModel> updatePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword, {
    String? correlationId,
  });

  // OAuth (1 endpoint)
  /// Sign in with Google OAuth token.
  /// Returns UserModel with access+refresh tokens.
  /// Requires: None (unauthenticated)
  Future<UserModel> googleSignIn(String idToken, {String? correlationId});
}

/// Implementation of [AuthRemoteDataSource] using Dio HTTP client.
/// All methods rethrow DioException for error handling at repository layer.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final _log = loggerFor('AuthRemoteDataSource');

  AuthRemoteDataSourceImpl({required Dio dio, String? serverClientId})
    : _dio = dio;

  // ==================== SIGNUP FLOW ====================

  @override
  Future<OtpModel> signup(
    String nickname,
    String email,
    String password, {
    String? correlationId,
  }) async {
    _log.info(
      'signup:start',
      data: {'cid': correlationId, 'email': email, 'nickname': nickname},
    );
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: {
          'user': {'nickname': nickname, 'email': email, 'password': password},
        },
      );
      _log.info(
        'signup:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return OtpModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  @override
  Future<UserModel> verifySignupOtp(
    String email,
    String otpCode, {
    String? correlationId,
  }) async {
    _log.info(
      'verifySignupOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {'email': email, 'code': otpCode},
      );
      _log.info(
        'verifySignupOtp:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  // ==================== LOGIN ====================

  @override
  Future<UserModel> login(
    String email,
    String password, {
    String? correlationId,
  }) async {
    _log.info('login:start', data: {'cid': correlationId, 'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      _log.info(
        'login:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  // ==================== PROFILE ====================

  @override
  Future<UserModel> fetchProfile({String? correlationId}) async {
    _log.info('fetchProfile:start', data: {'cid': correlationId});
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.profile,
      );
      _log.info(
        'fetchProfile:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? correlationId,
  }) async {
    _log.info(
      'updateProfileInfo:start',
      data: {
        'cid': correlationId,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'phoneLength': phoneNumber?.length ?? 0,
      },
    );
    try {
      final data = <String, dynamic>{};
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (gender != null) data['gender'] = gender;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      _log.info(
        'updateProfileInfo:request_payload',
        data: {
          'cid': correlationId,
          'payloadKeys': data.keys.toList(),
          'dateOfBirth': data['date_of_birth'],
          'gender': data['gender'],
          'phoneLength': phoneNumber?.length ?? 0,
        },
      );

      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.profile,
        data: data,
      );
      _log.info(
        'updateProfileInfo:success',
        data: {
          'cid': correlationId,
          'statusCode': response.statusCode,
          'responseKeys': (response.data ?? {}).keys.toList(),
        },
      );
      return UserModel.fromJson(response.data ?? {});
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
        },
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // ==================== PASSWORD RECOVERY ====================

  @override
  Future<OtpModel> requestForgotPasswordOtp(
    String email, {
    String? correlationId,
  }) async {
    _log.info(
      'requestForgotPasswordOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.forgotPasswordOtp,
        data: {'email': email},
      );
      _log.info(
        'requestForgotPasswordOtp:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return OtpModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  @override
  Future<OtpModel> verifyForgotPasswordOtp(
    String email,
    String otpCode,
    String newPassword,
    String confirmPassword, {
    String? correlationId,
  }) async {
    _log.info(
      'verifyForgotPasswordOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {
          'email': email,
          'code': otpCode,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
      _log.info(
        'verifyForgotPasswordOtp:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return OtpModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  @override
  Future<void> logout({String? correlationId}) async {
    _log.info('logout:start', data: {'cid': correlationId});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.logout,
      );
      _log.info(
        'logout:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
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
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String password, {String? correlationId}) async {
    _log.info('deleteAccount:start', data: {'cid': correlationId});
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.deleteAccount,
        data: {'password': password},
      );
      _log.info(
        'deleteAccount:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
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
      rethrow;
    }
  }

  /// Verify OTP for authentication/login purposes (OTP login flow).
  @override
  Future<UserModel> verifyOtp(
    String email,
    String otp, {
    String? correlationId,
  }) async {
    _log.info('verifyOtp:start', data: {'cid': correlationId, 'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {'email': email, 'code': otp},
      );
      _log.info(
        'verifyOtp:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  // ==================== SENSITIVE UPDATES ====================

  @override
  Future<UserModel> updatePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword, {
    String? correlationId,
  }) async {
    _log.info('updatePassword:start', data: {'cid': correlationId});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.passwordChange,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
      _log.info(
        'updatePassword:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }

  // ==================== OAUTH ====================

  @override
  Future<UserModel> googleSignIn(
    String idToken, {
    String? correlationId,
  }) async {
    _log.info('googleSignIn:start', data: {'cid': correlationId});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.googleLogin,
        data: {'id_token': idToken},
      );
      _log.info(
        'googleSignIn:success',
        data: {'cid': correlationId, 'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
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
      rethrow;
    }
  }
}

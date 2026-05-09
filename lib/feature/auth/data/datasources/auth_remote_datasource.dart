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
  Future<OtpModel> signup(String nickname, String email, String password);

  /// Step 2: Verify signup OTP and get authentication tokens.
  /// Returns UserModel with access+refresh tokens and profile data.
  /// Requires: None (unauthenticated)
  Future<UserModel> verifySignupOtp(String email, String otpCode);

  // Login (1 endpoint)
  /// Login with email and password.
  /// Returns UserModel with access+refresh tokens.
  /// Requires: None (unauthenticated)
  Future<UserModel> login(String email, String password);

  // Profile (2 endpoints)
  /// Fetch full profile of authenticated user.
  /// Returns UserModel with all profile data.
  /// Requires: access_token (via interceptor)
  Future<UserModel> fetchProfile();

  /// Update profile info (dateOfBirth, gender, phoneNumber).
  /// All parameters are optional - only update provided fields.
  /// Returns updated UserModel.
  /// Requires: access_token (via interceptor)
  Future<UserModel> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
  });

  // Password recovery (2 endpoints)
  /// Step 1: Request OTP for password reset.
  /// Returns OtpModel with expiration info.
  /// Requires: None (unauthenticated)
  Future<OtpModel> requestForgotPasswordOtp(String email);

  /// Step 2: Verify password reset OTP and change password.
  /// Returns OtpModel confirming completion.
  /// Requires: None (unauthenticated)
  Future<OtpModel> verifyForgotPasswordOtp(
    String email,
    String otpCode,
    String newPassword,
    String confirmPassword,
  );

  // Session management (3 endpoints)
  /// Logout and invalidate current session.
  /// Requires: access_token (via interceptor)
  Future<void> logout();

  /// Delete account permanently (hard delete with verification).
  /// Requires: access_token (via interceptor) + password in body
  Future<void> deleteAccount(String password);

  /// Verify OTP for authentication/login purposes (OTP login flow).
  Future<UserModel> verifyOtp(String email, String otp);

  /// Change password with current password verification.
  /// Returns updated UserModel.
  /// Requires: access_token (via interceptor)
  Future<UserModel> updatePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  );

  // OAuth (1 endpoint)
  /// Sign in with Google OAuth token.
  /// Returns UserModel with access+refresh tokens.
  /// Requires: None (unauthenticated)
  Future<UserModel> googleSignIn(String idToken);
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
    String password,
  ) async {
    _log.info('signup:start', data: {'email': email, 'nickname': nickname});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: {
          'user': {'nickname': nickname, 'email': email, 'password': password},
        },
      );
      _log.info('signup:success', data: {'statusCode': response.statusCode});
      return OtpModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'signup:error',
        data: {
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
  Future<UserModel> verifySignupOtp(String email, String otpCode) async {
    _log.info('verifySignupOtp:start', data: {'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {'email': email, 'code': otpCode},
      );
      _log.info(
        'verifySignupOtp:success',
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'verifySignupOtp:error',
        data: {
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
  Future<UserModel> login(String email, String password) async {
    _log.info('login:start', data: {'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      _log.info('login:success', data: {'statusCode': response.statusCode});
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'login:error',
        data: {
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
  Future<UserModel> fetchProfile() async {
    _log.info('fetchProfile:start');
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.profile,
      );
      _log.info(
        'fetchProfile:success',
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'fetchProfile:error',
        data: {
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
  }) async {
    _log.info(
      'updateProfileInfo:start',
      data: {'dateOfBirth': dateOfBirth, 'gender': gender},
    );
    try {
      final data = <String, dynamic>{};
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (gender != null) data['gender'] = gender;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.profile,
        data: data,
      );
      _log.info(
        'updateProfileInfo:success',
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'updateProfileInfo:error',
        data: {
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

  // ==================== PASSWORD RECOVERY ====================

  @override
  Future<OtpModel> requestForgotPasswordOtp(String email) async {
    _log.info('requestForgotPasswordOtp:start', data: {'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.forgotPasswordOtp,
        data: {'email': email},
      );
      _log.info(
        'requestForgotPasswordOtp:success',
        data: {'statusCode': response.statusCode},
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'requestForgotPasswordOtp:error',
        data: {
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
    String confirmPassword,
  ) async {
    _log.info('verifyForgotPasswordOtp:start', data: {'email': email});
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
        data: {'statusCode': response.statusCode},
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'verifyForgotPasswordOtp:error',
        data: {
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
  Future<void> logout() async {
    _log.info('logout:start');
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.logout,
      );
      _log.info('logout:success', data: {'statusCode': response.statusCode});
    } on DioException catch (e, st) {
      _log.error(
        'logout:error',
        data: {
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
  Future<void> deleteAccount(String password) async {
    _log.info('deleteAccount:start');
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.deleteAccount,
        data: {'password': password},
      );
      _log.info(
        'deleteAccount:success',
        data: {'statusCode': response.statusCode},
      );
    } on DioException catch (e, st) {
      _log.error(
        'deleteAccount:error',
        data: {
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
  Future<UserModel> verifyOtp(String email, String otp) async {
    _log.info('verifyOtp:start', data: {'email': email});
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {'email': email, 'code': otp},
      );
      _log.info('verifyOtp:success', data: {'statusCode': response.statusCode});
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'verifyOtp:error',
        data: {
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
    String confirmPassword,
  ) async {
    _log.info('updatePassword:start');
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
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'updatePassword:error',
        data: {
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
  Future<UserModel> googleSignIn(String idToken) async {
    _log.info('googleSignIn:start');
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.googleLogin,
        data: {'id_token': idToken},
      );
      _log.info(
        'googleSignIn:success',
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException catch (e, st) {
      _log.error(
        'googleSignIn:error',
        data: {
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

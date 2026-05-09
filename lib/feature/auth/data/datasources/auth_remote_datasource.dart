import 'package:dio/dio.dart';
import '../models/models.dart';

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
  );

  // Session management (3 endpoints)
  /// Logout and invalidate current session.
  /// Requires: access_token (via interceptor)
  Future<void> logout();

  /// Delete account permanently (hard delete with verification).
  /// Requires: access_token (via interceptor) + password in body
  Future<void> deleteAccount(String email, String password);

  /// Request OTP for email change.
  /// OTP sent to current email address.
  /// Returns OtpModel with expiration info.
  /// Requires: access_token (via interceptor)
  Future<OtpModel> requestEmailChangeOtp();

  /// Request email change by providing current password (unauthenticated path).
  Future<OtpModel> requestEmailChangeWithPassword({
    required String email,
    required String password,
    required String newEmail,
  });

  /// Verify OTP for authentication/login purposes (OTP login flow).
  Future<UserModel> verifyOtp(String email, String otp);

  // Sensitive updates (3 endpoints)
  /// Confirm email change by verifying OTP.
  /// Returns void on success.
  /// Requires: access_token (via interceptor)
  Future<void> confirmEmailChange(String newEmail, String otpCode);

  /// Change password with current password verification.
  /// Returns updated UserModel.
  /// Requires: access_token (via interceptor)
  Future<UserModel> updatePassword(String currentPassword, String newPassword);

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

  // Base URL for auth endpoints: /api/auth/
  static const String _baseUrl = '/api/auth';

  AuthRemoteDataSourceImpl({required Dio dio, String? serverClientId}) : _dio = dio;

  // ==================== SIGNUP FLOW ====================

  @override
  Future<OtpModel> signup(
    String nickname,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/signup',
        data: {'nickname': nickname, 'email': email, 'password': password},
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> verifySignupOtp(String email, String otpCode) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/verify-signup-otp',
        data: {'email': email, 'otp_code': otpCode},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== LOGIN ====================

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/login',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== PROFILE ====================

  @override
  Future<UserModel> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/profile',
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (gender != null) data['gender'] = gender;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      final response = await _dio.patch<Map<String, dynamic>>(
        '$_baseUrl/profile',
        data: data,
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== PASSWORD RECOVERY ====================

  @override
  Future<OtpModel> requestForgotPasswordOtp(String email) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/request-password-reset-otp',
        data: {'email': email},
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OtpModel> verifyForgotPasswordOtp(
    String email,
    String otpCode,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/verify-password-reset-otp',
        data: {
          'email': email,
          'otp_code': otpCode,
          'new_password': newPassword,
        },
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  @override
  Future<void> logout() async {
    try {
      await _dio.post<Map<String, dynamic>>('$_baseUrl/logout');
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String email, String password) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        '$_baseUrl/delete-account',
        data: {'email': email, 'password': password},
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OtpModel> requestEmailChangeOtp() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/request-email-change-otp',
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  /// Request email change by providing current password (unauthenticated path).
  /// Returns OtpModel with expiration info.
  @override
  Future<OtpModel> requestEmailChangeWithPassword({
    required String email,
    required String password,
    required String newEmail,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/request-email-change-with-password',
        data: {'email': email, 'password': password, 'new_email': newEmail},
      );
      return OtpModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  /// Verify OTP for authentication/login purposes (OTP login flow).
  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/verify-otp',
        data: {'email': email, 'otp_code': otp},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== SENSITIVE UPDATES ====================

  @override
  Future<void> confirmEmailChange(String newEmail, String otpCode) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/confirm-email-change',
        data: {'new_email': newEmail, 'otp_code': otpCode},
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/update-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }

  // ==================== OAUTH ====================

  @override
  Future<UserModel> googleSignIn(String idToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/google-signin',
        data: {'id_token': idToken},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }
}

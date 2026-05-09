import 'package:dio/dio.dart';
import 'package:afiete/core/network/api_endpoints.dart';
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

  AuthRemoteDataSourceImpl({required Dio dio, String? serverClientId})
    : _dio = dio;

  // ==================== SIGNUP FLOW ====================

  @override
  Future<OtpModel> signup(
    String nickname,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.signup,
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
        ApiEndpoints.otpVerify,
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
        ApiEndpoints.login,
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
        ApiEndpoints.profile,
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
        ApiEndpoints.profile,
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
        ApiEndpoints.forgotPasswordOtp,
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
    String confirmPassword,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {
          'email': email,
          'otp_code': otpCode,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
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
      await _dio.post<Map<String, dynamic>>(ApiEndpoints.logout);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.deleteAccount,
        data: {'password': password},
      );
    } on DioException {
      rethrow;
    }
  }

  /// Verify OTP for authentication/login purposes (OTP login flow).
  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.otpVerify,
        data: {'email': email, 'otp_code': otp},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.passwordChange,
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
        ApiEndpoints.googleLogin,
        data: {'id_token': idToken},
      );
      return UserModel.fromJson(response.data ?? {});
    } on DioException {
      rethrow;
    }
  }
}

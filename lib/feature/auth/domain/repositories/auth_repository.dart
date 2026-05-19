import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';

/// Abstract repository defining all authentication operations.
/// All methods return `Either<Failure, T>` for functional error handling.
abstract class AuthRepository {
  // ===== SIGNUP FLOW (MULTI-STEP) =====

  /// Step 1: Initiate signup, request OTP to be sent to email.
  /// Backend validates email uniqueness, generates OTP, sends email.
  Future<Either<Failure, OtpEntity>> signup({
    required String nickname,
    required String email,
    required String password,
    String? correlationId,
  });

  /// Step 2: Verify signup OTP code (returned from email).
  /// Backend validates OTP, sets is_verified=true, returns user with access_token.
  /// **CRITICAL**: This method returns user with token; token must be cached immediately.
  Future<Either<Failure, UserAuthEntity>> verifySignupOtp({
    required String email,
    required String otpCode,
    String? password,
    String? correlationId,
  });

  /// Resend signup OTP to the same email.
  /// Uses dedicated endpoint: /api/users/otp/resend
  Future<Either<Failure, OtpEntity>> resendSignupOtp({
    required String email,
    String? correlationId,
  });

  // ===== LOGIN FLOW =====

  /// Login with email and password.
  /// Returns user entity with access_token and full profile data.
  /// Check [UserAuthEntity.isProfileComplete] to determine if profile completion is needed.
  Future<Either<Failure, UserAuthEntity>> login({
    required String email,
    required String password,
    String? correlationId,
  });

  // ===== PROFILE MANAGEMENT =====

  /// Fetch current authenticated user's profile.
  /// Requires valid access token in Authorization header (managed by Dio interceptor).
  Future<Either<Failure, UserAuthEntity>> fetchProfile({String? correlationId});

  /// Update user profile (partially or fully).
  /// All fields are optional; only provided fields are updated.
  /// Requires access token; returns updated user entity.
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    String? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? psychologicalHistory,
    String? nickname,
    String? correlationId,
  });

  // ===== PASSWORD RECOVERY FLOW =====

  /// Request OTP for password reset.
  /// Public endpoint (no auth required).
  Future<Either<Failure, OtpEntity>> requestForgotPasswordOtp({
    required String email,
    String? correlationId,
  });

  /// Verify forgot password OTP and set new password.
  /// Backend validates OTP, updates password, returns status.
  /// After success, user should call [login] to get new access_token.
  Future<Either<Failure, OtpEntity>> verifyForgotPasswordOtp({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
    String? correlationId,
  });

  // ===== SESSION MANAGEMENT =====

  /// Logout current user.
  /// Requires access token; server invalidates token.
  /// Note: Logout failures should still clear local tokens (done in cubit).
  Future<Either<Failure, void>> logout({String? correlationId});

  /// Delete user account permanently.
  /// Uses authenticated session token.
  /// Hard delete from database; cannot be recovered.
  /// Backend should clear all associated data.
  Future<Either<Failure, void>> deleteAccount({
    required String password,
    String? correlationId,
  });

  /// Reactivate an inactive account with email and password.
  Future<Either<Failure, void>> reactivateAccount({
    required String email,
    required String password,
    String? correlationId,
  });

  // ===== GOOGLE SIGN-IN =====

  /// Google Sign-In OAuth flow.
  /// Requires idToken from Google Sign-In plugin.
  /// Backend validates token with Google servers, creates/updates user, returns access_token.
  /// Returns user with token; check [UserAuthEntity.isProfileComplete] for profile completion.
  Future<Either<Failure, UserAuthEntity>> googleSignIn({
    required String idToken,
    String? correlationId,
  });

  // ===== SENSITIVE PROFILE UPDATES (PASSWORD-PROTECTED) =====

  /// Change user's password.
  /// Requires current password verification for security.
  /// Requires access token.
  Future<Either<Failure, UserAuthEntity>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    String? correlationId,
  });

  // ===== LOCAL SESSION CACHE HELPERS =====

  /// Cache the authenticated user session locally.
  Future<void> cacheSession(UserAuthEntity user, {String? correlationId});

  /// Retrieve cached user session if available.
  Future<UserAuthEntity?> getCachedSession();

  /// Clear cached session locally.
  Future<void> clearCachedSession();

  /// Cache pending signup flow data locally so OTP verification can resume
  /// after app restart or hot restart.
  Future<void> cachePendingSignupSession(
    UserAuthEntity user, {
    String? correlationId,
  });

  /// Retrieve cached pending signup flow data if available.
  Future<UserAuthEntity?> getCachedPendingSignupSession();

  /// Clear cached pending signup flow data locally.
  Future<void> clearPendingSignupSession();

  // ===== ADDITIONAL UTILS REFERENCED BY PRESENTATION =====

  /// Verify generic/authentication OTP (login via OTP flow).
  Future<Either<Failure, UserAuthEntity>> verifyOtp({
    required String email,
    required String otpCode,
    String? correlationId,
  });

  /// Request an email-change OTP by providing current password (unauthenticated path).

  /// Change password using a reset flow (server-side reset).
  Future<Either<Failure, OtpEntity>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    String? correlationId,
  });
}

import 'package:afiete/core/utils/age_utils.dart';
import 'package:afiete/core/utils/logger.dart';
import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';

import 'package:afiete/feature/auth/domain/usecase/fetch_profile_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';

import 'package:afiete/feature/auth/domain/usecase/request_forgot_password_otp_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/google_signin_usecase.dart';
import '../../domain/usecase/update_profile_info_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _log = loggerFor('AuthCubit');
  UserAuthEntity? _pendingSignupUser;
  String? _activeAuthFlowCorrelationId;

  String? get activeAuthFlowCorrelationId => _activeAuthFlowCorrelationId;

  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final FetchProfileUseCase fetchProfileUseCase;
  final UpdateProfileInfoUseCase updateProfileInfoUseCase;

  final RequestForgotPasswordOtpUseCase requestForgotPasswordOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  final AuthRepository authRepository;

  AuthCubit(
    this.loginUseCase,
    this.signupUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
    this.googleSignInUseCase,
    this.fetchProfileUseCase,
    this.updateProfileInfoUseCase,

    this.requestForgotPasswordOtpUseCase,
    this.verifyOtpUseCase,

    this.authRepository,
  ) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    final correlationId = _newCorrelationId(context: 'login');
    _log.info('login:start', data: {'cid': correlationId, 'email': email});
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(
        email: email,
        password: password,
        correlationId: correlationId,
      ),
    );
    result.fold(
      (failure) async {
        _log.error(
          'login:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );

        // Check if account is inactive/restricted
        if (_isInactiveAccountError(failure.errorMessage)) {
          _log.warn(
            'login:account_inactive',
            data: {'cid': correlationId, 'email': email},
          );
          emit(
            const AuthError(
              'This account is inactive or restricted on the server, so sign-in is currently unavailable. Please contact support if you believe this is an error.',
            ),
          );
          return Future.value();
        }

        // Any other error
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log.info(
          'login:success',
          data: {
            'cid': correlationId,
            'email': user.email,
            'isVerified': user.isVerified,
          },
        );

        // Login now goes straight to the authenticated session.
        return _cacheAndEmitUser(user, correlationId: correlationId);
      },
    );
  }

  Future<void> signup(String nickname, String email, String password) async {
    final correlationId = _startAuthFlowCorrelationId(context: 'signup');
    _log.info(
      'signup:start',
      data: {'cid': correlationId, 'email': email, 'nickname': nickname},
    );

    // Pre-OTP flow must be unauthenticated. Clear any previous session first.
    await authRepository.clearCachedSession();
    _log.info('signup:pre_otp_session_cleared', data: {'cid': correlationId});

    _pendingSignupUser = null;
    emit(AuthLoading());
    final result = await signupUseCase(
      SignupParams(
        nickname: nickname,
        email: email,
        password: password,
        correlationId: correlationId,
      ),
    );
    result.fold(
      (failure) async {
        _log.error(
          'signup:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        // If email already exists (unverified), ask for OTP verification
        if (_isNotVerifiedError(failure.errorMessage) ||
            _isEmailAlreadyExistsError(failure.errorMessage)) {
          _log.warn(
            'signup:email_already_exists',
            data: {'cid': correlationId, 'email': email},
          );
          _pendingSignupUser = UserAuthEntity(
            username: nickname,
            nickname: nickname,
            email: email,
            password: password,
            isVerified: false,
          );
          await authRepository.cachePendingSignupSession(
            _pendingSignupUser!,
            correlationId: correlationId,
          );
          // OTP already sent by backend; wait for user input
          emit(
            OtpSent(
              email: email,
              expiresInSeconds: 600, // 10 minutes default
            ),
          );
        } else {
          emit(AuthError(failure.errorMessage));
        }
      },
      (otpEntity) async {
        _log.info(
          'signup:otp_sent',
          data: {
            'cid': correlationId,
            'email': email,
            'expiresIn': otpEntity.expiresInSeconds,
          },
        );
        // OTP was sent; store signup data and wait for verification
        _pendingSignupUser = UserAuthEntity(
          username: nickname,
          nickname: nickname,
          email: email,
          password: password,
          isVerified: false,
        );
        await authRepository.cachePendingSignupSession(
          _pendingSignupUser!,
          correlationId: correlationId,
        );
        // PHASE 1: OTP sent by backend; navigate to verification screen
        emit(
          OtpSent(email: email, expiresInSeconds: otpEntity.expiresInSeconds),
        );
      },
    );
  }

  Future<bool> logout(String email, String password) async {
    final correlationId = _newCorrelationId(context: 'logout');
    _log.info('logout:start', data: {'cid': correlationId, 'email': email});
    emit(AuthLoading());
    final result = await logoutUseCase(
      LogoutParams(correlationId: correlationId),
    );
    return result.fold(
      (failure) {
        _log.error(
          'logout:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (_) async {
        _log.info('logout:success', data: {'cid': correlationId});
        await authRepository.clearCachedSession();
        await authRepository.clearPendingSignupSession();
        _pendingSignupUser = null;
        _activeAuthFlowCorrelationId = null;
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<bool> deleteAccount(String password) async {
    final correlationId = _newCorrelationId(context: 'delete_account');
    _log.warn(
      'delete_account:start',
      data: {'cid': correlationId, 'passwordLength': password.length},
    );
    emit(AuthLoading());
    final result = await deleteAccountUseCase(
      DeleteAccountParams(password: password, correlationId: correlationId),
    );
    return result.fold(
      (failure) {
        _log.error(
          'delete_account:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (_) async {
        _log.info('delete_account:success', data: {'cid': correlationId});
        await authRepository.clearCachedSession();
        await authRepository.clearPendingSignupSession();
        _pendingSignupUser = null;
        _activeAuthFlowCorrelationId = null;
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<void> googleSignIn() async {
    final correlationId = _newCorrelationId(context: 'google_sign_in');
    _log.info('google_sign_in:start', data: {'cid': correlationId});
    emit(AuthLoading());
    final result = await googleSignInUseCase(
      GoogleSignInParams(idToken: '', correlationId: correlationId),
    );
    result.fold(
      (failure) {
        _log.error(
          'google_sign_in:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );

        final msg = failure.errorMessage.toLowerCase();

        // Specific handling for common Google Sign-In plugin errors
        if (msg.contains('id_token') || msg.contains('id token')) {
          emit(
            const AuthError(
              'Google Sign-In could not be completed because the id_token is missing. Configure the OAuth Web Client ID in the app settings so the provider can return an id_token.',
            ),
          );
          return;
        }

        if (msg.contains('apiexception: 10') ||
            msg.contains(': 10') ||
            msg.contains('developer_error')) {
          emit(
            const AuthError(
              'Google Sign-In failed due to an Android OAuth configuration error (ApiException 10). Verify the package name and SHA-1 fingerprint in Google Cloud Console.',
            ),
          );
          return;
        }

        if (msg.contains('sign_in_cancelled') ||
            msg.contains('cancelled') ||
            msg.contains('cancel')) {
          emit(const AuthError('Google Sign-In was cancelled by the user.'));
          return;
        }

        if (msg.contains('play services') || msg.contains('google play')) {
          emit(
            const AuthError(
              'Google Sign-In requires Google Play Services on this device.',
            ),
          );
          return;
        }

        if (_isAlreadyVerifiedError(failure.errorMessage)) {
          emit(
            const AuthError(
              'Your account is already verified. Please sign in directly.',
            ),
          );
          return;
        }

        // Fallback: show server-provided or generic message
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log.info(
          'google_sign_in:success',
          data: {
            'cid': correlationId,
            'username': user.username,
            'email': user.email,
          },
        );
        return _cacheAndEmitUser(user, correlationId: correlationId);
      },
    );
  }

  Future<bool> updateProfileInfo({
    String? nickname,
    required DateTime birthDate,
    required String gender,
    String? phoneNumber,
    String? psychologicalHistory,
  }) async {
    final correlationId = _ensureAuthFlowCorrelationId(
      context: 'profile_update',
    );
    final sanitizedGender = _normalizeGenderForBackend(gender);
    final sanitizedPhone = phoneNumber?.trim();
    final birthDateIso = birthDate.toIso8601String().split('T')[0];

    _log.info(
      'update_profile_info:start',
      data: {
        'cid': correlationId,
        'birthDate': birthDateIso,
        'gender': sanitizedGender,
        'phoneLength': sanitizedPhone?.length ?? 0,
        'nickname': nickname,
        'hasPsychologicalHistory': psychologicalHistory != null,
      },
    );

    final currentState = state;
    AuthState mergeBaseState = currentState;
    UserAuthEntity? existingUser;

    if (currentState is AuthLoaded) {
      existingUser = currentState.user;
    } else if (currentState is AuthProfileUpdated) {
      existingUser = currentState.user;
    } else {
      _log.warn(
        'update_profile_info:state_not_ready_try_cache',
        data: {
          'cid': correlationId,
          'stateType': currentState.runtimeType.toString(),
        },
      );
      final cachedUser = await authRepository.getCachedSession();
      if (cachedUser != null) {
        existingUser = cachedUser;
        mergeBaseState = AuthLoaded(cachedUser);
        emit(AuthLoaded(cachedUser));
        _log.info(
          'update_profile_info:state_recovered_from_cache',
          data: {
            'cid': correlationId,
            'email': cachedUser.email,
            'hasAccessToken': cachedUser.accessToken?.isNotEmpty == true,
          },
        );
      }
    }

    if (existingUser == null) {
      _log.error(
        'update_profile_info:invalid_state',
        data: {
          'cid': correlationId,
          'stateType': currentState.runtimeType.toString(),
        },
      );
      emit(
        const AuthError(
          'Unable to update profile info because your session is not ready. Please sign in again.',
        ),
      );
      return false;
    }

    if (sanitizedGender.isEmpty) {
      _log.warn(
        'update_profile_info:validation_failed',
        data: {'cid': correlationId, 'field': 'gender'},
      );
      emit(const AuthError('Please select your gender before continuing.'));
      return false;
    }

    if (sanitizedGender != 'male' && sanitizedGender != 'female') {
      _log.warn(
        'update_profile_info:validation_failed',
        data: {
          'cid': correlationId,
          'field': 'gender',
          'value': sanitizedGender,
        },
      );
      emit(
        const AuthError(
          'Gender must be male or female before continuing.',
        ),
      );
      return false;
    }

    final phoneValidationError = _validatePhoneNumberForProfile(sanitizedPhone);
    if (phoneValidationError != null) {
      _log.warn(
        'update_profile_info:validation_failed',
        data: {
          'cid': correlationId,
          'field': 'phoneNumber',
          'reason': phoneValidationError,
          'phoneLength': sanitizedPhone?.length ?? 0,
        },
      );
      emit(AuthError(phoneValidationError));
      return false;
    }

    final payloadPhone = sanitizedPhone ?? existingUser.phoneNumber ?? '';
    final payloadNickname =
        (nickname?.trim().isNotEmpty == true)
            ? nickname!.trim()
            : (existingUser.nickname ?? '').trim();
    final payloadPsychologicalHistory = psychologicalHistory ?? '';

    _log.info(
      'update_profile_info:payload_ready',
      data: {
        'cid': correlationId,
        'date_of_birth': birthDateIso,
        'gender': sanitizedGender,
        'phoneLength': payloadPhone.length,
        'nickname': payloadNickname,
        'hasPsychologicalHistory':
            payloadPsychologicalHistory.trim().isNotEmpty,
      },
    );

    final result = await updateProfileInfoUseCase(
      UpdateProfileParams(
        dateOfBirth: birthDateIso,
        gender: sanitizedGender,
        phoneNumber: payloadPhone,
        nickname: payloadNickname,
        psychologicalHistory: payloadPsychologicalHistory,
        correlationId: correlationId,
      ),
    );

    return result.fold(
      (failure) {
        final normalizedMessage = _normalizeProfileInfoUpdateError(
          failure.errorMessage,
        );
        _log.error(
          'update_profile_info:error',
          data: {
            'cid': correlationId,
            'message': failure.errorMessage,
            'normalizedMessage': normalizedMessage,
            'birthDate': birthDateIso,
            'gender': sanitizedGender,
            'phoneLength': payloadPhone.length,
            'nickname': payloadNickname,
            'hasPsychologicalHistory':
                payloadPsychologicalHistory.trim().isNotEmpty,
          },
        );
        emit(AuthError(normalizedMessage));
        return false;
      },
      (updatedUser) {
        _log.info(
          'update_profile_info:success',
          data: {
            'cid': correlationId,
            'hasBirthDate': updatedUser.birthDate != null,
            'hasGender': (updatedUser.gender?.trim().isNotEmpty ?? false),
            'hasPhoneNumber':
                (updatedUser.phoneNumber?.trim().isNotEmpty ?? false),
          },
        );

        final mergedUser = _mergeWithCurrentUser(mergeBaseState, updatedUser);
        _cacheAndEmitUser(
          mergedUser,
          asProfileUpdated: true,
          correlationId: correlationId,
        );

        // Refresh profile from backend to ensure complete sync
        refreshProfileFromBackend();

        _log.info(
          'auth_flow:cid_completed',
          data: {'cid': correlationId, 'stage': 'profile_update_success'},
        );
        _activeAuthFlowCorrelationId = null;

        return true;
      },
    );
  }

  Future<void> sendVerificationOtp(
    String email, {
    VerifyOtpParams? params,
    UserAuthEntity? userAuthEntity,
  }) async {
    final correlationId = _ensureAuthFlowCorrelationId(
      context: 'send_verification_otp',
    );
    _log.info(
      'sendVerificationOtp:start',
      data: {'cid': correlationId, 'email': email},
    );
    emit(AuthLoading());
    // Request to resend OTP for signup verification
    final result = await requestForgotPasswordOtpUseCase(
      ForgotPasswordParams(email: email, correlationId: correlationId),
    );

    await result.fold(
      (failure) async {
        _log.error(
          'sendVerificationOtp:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
      },
      (otpEntity) async {
        _log.info(
          'sendVerificationOtp:success',
          data: {
            'cid': correlationId,
            'email': email,
            'expiresIn': otpEntity.expiresInSeconds,
          },
        );
        // OTP resent successfully; wait for user input
        emit(
          OtpSent(email: email, expiresInSeconds: otpEntity.expiresInSeconds),
        );
      },
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    final correlationId = _ensureAuthFlowCorrelationId(context: 'verify_otp');
    _log.info(
      'verify_otp:start',
      data: {'cid': correlationId, 'email': email, 'otpLength': otp.length},
    );
    emit(AuthLoading());
    final isSignupFlow = _pendingSignupUser != null;
    final result = isSignupFlow
        ? await authRepository.verifySignupOtp(
            email: email,
            otpCode: otp,
            password: _pendingSignupUser?.password,
            correlationId: correlationId,
          )
        : await verifyOtpUseCase(
            VerifyOtpParams(
              email: email,
              otp: otp,
              correlationId: correlationId,
            ),
          );

    await result.fold(
      (failure) {
        _log.error(
          'verify_otp:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
      },
      (user) async {
        // Build verified user from signup or login flow
        final verifiedUser = _buildVerifiedUser(user);

        _log.info(
          'verify_otp:success',
          data: {
            'cid': correlationId,
            'email': email,
            'emailVerified': verifiedUser.isVerified,
            'hasAccessToken': verifiedUser.accessToken?.isNotEmpty == true,
            'hasRefreshToken': verifiedUser.refreshToken?.isNotEmpty == true,
            'isSignupFlow': isSignupFlow,
          },
        );

        UserAuthEntity? sessionUser = verifiedUser;

        if (!(verifiedUser.accessToken?.isNotEmpty == true)) {
          sessionUser = await _recoverAuthenticatedSessionAfterOtp(
            email: email,
            verifiedUser: verifiedUser,
            correlationId: correlationId,
          );

          if (sessionUser == null) {
            if (isSignupFlow) {
              _log.error(
                'verify_otp:missing_tokens_after_signup_verification',
                data: {
                  'cid': correlationId,
                  'email': email,
                  'emailVerified': verifiedUser.isVerified,
                },
              );
              emit(
                const AuthError(
                  'Verification completed, but authentication session could not be established. Please try again in a moment or contact support.',
                ),
              );
            } else {
              emit(
                const AuthError(
                  'OTP verified, but authentication session could not be established. Please sign in again.',
                ),
              );
            }
            return;
          }
        }

        // PHASE 2: OTP verified successfully - CRITICAL token caching point
        // Cache tokens immediately after OTP verification
        await _cacheAndEmitUser(sessionUser, correlationId: correlationId);

        // Determine next step based on flow and profile completion status
        if (isSignupFlow) {
          // PHASE 2.5: Check if profile is complete
          final isProfileComplete = _isUserProfileComplete(sessionUser);

          if (!isProfileComplete) {
            // Profile incomplete: emit special state to navigate to profile completion screen
            _log.info(
              'verify_otp:signup_requires_profile_completion',
              data: {
                'cid': correlationId,
                'email': email,
                'hasAccessToken': sessionUser.accessToken?.isNotEmpty == true,
              },
            );
            // Emit SignupOtpVerified to trigger navigation to CompleteProfileScreen
            emit(SignupOtpVerified(sessionUser));
          }
          // If profile IS complete, AuthLoaded was already emitted above via _cacheAndEmitUser
        }
      },
    );
  }

  Future<UserAuthEntity?> _recoverAuthenticatedSessionAfterOtp({
    required String email,
    required UserAuthEntity verifiedUser,
    required String correlationId,
  }) async {
    final fallbackPassword =
        _pendingSignupUser?.password ?? verifiedUser.password;

    _log.warn(
      'verify_otp:missing_tokens_attempt_login_fallback',
      data: {
        'cid': correlationId,
        'email': email,
        'hasPassword': fallbackPassword?.isNotEmpty == true,
      },
    );

    if (fallbackPassword == null || fallbackPassword.isEmpty) {
      _log.error(
        'verify_otp:login_fallback_unavailable',
        data: {
          'cid': correlationId,
          'reason': 'missing_password_for_fallback_login',
        },
      );
      return null;
    }

    final loginResult = await loginUseCase(
      LoginParams(
        email: email,
        password: fallbackPassword,
        correlationId: correlationId,
      ),
    );

    return loginResult.fold(
      (failure) {
        _log.error(
          'verify_otp:login_fallback_failed',
          data: {
            'cid': correlationId,
            'email': email,
            'message': failure.errorMessage,
          },
        );
        return null;
      },
      (loggedInUser) {
        final merged = loggedInUser.copyWith(
          username: verifiedUser.username.isNotEmpty
              ? verifiedUser.username
              : loggedInUser.username,
          nickname: verifiedUser.nickname ?? loggedInUser.nickname,
          birthDate: verifiedUser.birthDate ?? loggedInUser.birthDate,
          age: verifiedUser.age ?? loggedInUser.age,
          gender: verifiedUser.gender ?? loggedInUser.gender,
          phoneNumber: verifiedUser.phoneNumber ?? loggedInUser.phoneNumber,
          isVerified: true,
          password: fallbackPassword,
        );

        _log.info(
          'verify_otp:login_fallback_success',
          data: {
            'cid': correlationId,
            'email': email,
            'hasAccessToken': merged.accessToken?.isNotEmpty == true,
            'hasRefreshToken': merged.refreshToken?.isNotEmpty == true,
          },
        );

        return merged;
      },
    );
  }

  /// Build user entity with verified status from both signup and login contexts
  UserAuthEntity _buildVerifiedUser(UserAuthEntity backendUser) {
    // If from signup flow, merge with stored signup data
    if (_pendingSignupUser != null) {
      return backendUser.copyWith(
        username: (_pendingSignupUser!.username.isNotEmpty)
            ? _pendingSignupUser!.username
            : backendUser.username,
        nickname: (_pendingSignupUser!.nickname?.isNotEmpty ?? false)
            ? _pendingSignupUser!.nickname
            : backendUser.nickname,
        email: (_pendingSignupUser!.email.isNotEmpty)
            ? _pendingSignupUser!.email
            : backendUser.email,
        password: _pendingSignupUser!.password,
        birthDate: backendUser.birthDate ?? _pendingSignupUser!.birthDate,
        age: backendUser.age ?? _pendingSignupUser!.age,
        gender: backendUser.gender ?? _pendingSignupUser!.gender,
        phoneNumber: backendUser.phoneNumber ?? _pendingSignupUser!.phoneNumber,
      );
    }

    // For non-signup flows, keep backend verification flag as-is.
    return backendUser;
  }

  Future<bool> restoreSession() async {
    final correlationId = _newCorrelationId(context: 'restore_session');
    final cachedUser = await authRepository.getCachedSession();
    if (cachedUser == null) {
      emit(const AuthInitial());
      return false;
    }

    if (!(cachedUser.accessToken?.isNotEmpty == true)) {
      _log.warn(
        'restore_session:invalid_cached_user_missing_token',
        data: {'cid': correlationId, 'email': cachedUser.email},
      );
      await authRepository.clearCachedSession();
      emit(const AuthInitial());
      return false;
    }

    emit(AuthLoaded(cachedUser));
    await refreshProfileFromBackend(correlationId: correlationId);
    return true;
  }

  Future<UserAuthEntity?> restorePendingSignupSession() async {
    final cachedSignup = _pendingSignupUser ??
        await authRepository.getCachedPendingSignupSession();
    if (cachedSignup == null) {
      return null;
    }

    _pendingSignupUser = cachedSignup;
    emit(OtpSent(email: cachedSignup.email, expiresInSeconds: 600));
    return cachedSignup;
  }

  Future<bool> refreshProfileFromBackend({String? correlationId}) async {
    final cid = correlationId ?? _newCorrelationId(context: 'refresh_profile');
    final currentState = state;
    final currentUser = currentState is AuthLoaded
        ? currentState.user
        : currentState is AuthProfileUpdated
        ? currentState.user
        : await authRepository.getCachedSession();

    if (currentUser == null) {
      return false;
    }

    if (!(currentUser.accessToken?.isNotEmpty == true)) {
      _log.warn(
        'refresh_profile:missing_access_token_skip',
        data: {'cid': cid, 'email': currentUser.email},
      );
      return false;
    }

    final result = await fetchProfileUseCase(
      FetchProfileParams(correlationId: cid),
    );
    return result.fold(
      (failure) {
        _log.error(
          'refresh_profile:error',
          data: {'cid': cid, 'message': failure.errorMessage},
        );
        return false;
      },
      (remoteUser) {
        _log.info('refresh_profile:success', data: {'cid': cid});
        final mergedUser = _mergeWithCurrentUser(currentState, remoteUser);
        return _cacheAndEmitUser(
          mergedUser,
          asProfileUpdated: currentState is AuthProfileUpdated,
          correlationId: cid,
        );
      },
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final correlationId = _newCorrelationId(context: 'change_password');
    _log.warn('change_password:start', data: {'cid': correlationId});

    final result = await authRepository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: newPassword,
      correlationId: correlationId,
    );

    final success = result.fold(
      (failure) {
        _log.error(
          'change_password:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        _log.info('change_password:success', data: {'cid': correlationId});

        // Update cached user with new password
        final currentState = state;
        if (currentState is AuthLoaded || currentState is AuthProfileUpdated) {
          final mergedUser = _mergeWithCurrentUser(currentState, updatedUser);
          _cacheAndEmitUser(
            mergedUser,
            asProfileUpdated: currentState is AuthProfileUpdated,
            correlationId: correlationId,
          );
        }

        return true;
      },
    );

    if (success) {
      // Refresh profile from backend to ensure sync
      await refreshProfileFromBackend(correlationId: correlationId);
    }

    return success;
  }

  Future<String?> requestForgotPasswordOtp({required String email}) async {
    final correlationId = _newCorrelationId(context: 'forgot_password_otp');
    _log.info(
      'forgot_password_otp:start',
      data: {'cid': correlationId, 'email': email},
    );
    final result = await requestForgotPasswordOtpUseCase(
      ForgotPasswordParams(email: email, correlationId: correlationId),
    );

    return result.fold(
      (failure) {
        _log.error(
          'forgot_password_otp:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return failure.errorMessage;
      },
      (message) {
        _log.info(
          'forgot_password_otp:success',
          data: {'cid': correlationId, 'message': message},
        );
        return null;
      },
    );
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final correlationId = _newCorrelationId(context: 'reset_password');
    _log.info(
      'reset_password:start',
      data: {'cid': correlationId, 'email': email},
    );

    final result = await authRepository.resetPassword(
      email: email,
      otpCode: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      correlationId: correlationId,
    );

    return result.fold(
      (failure) {
        _log.error(
          'reset_password:error',
          data: {'cid': correlationId, 'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (otpEntity) async {
        _log.info('reset_password:otp_sent', data: {'cid': correlationId});
        return true;
      },
    );
  }

  bool _isNotVerifiedError(String errorMessage) {
    return errorMessage.toLowerCase().contains('not verified') ||
        errorMessage.toLowerCase().contains('verify your account');
  }

  bool _isEmailAlreadyExistsError(String errorMessage) {
    return errorMessage.toLowerCase().contains('already exists') ||
        errorMessage.toLowerCase().contains('user with this email') ||
        errorMessage.toLowerCase().contains('email already');
  }

  bool _isAlreadyVerifiedError(String errorMessage) {
    final normalized = errorMessage.toLowerCase();
    return normalized.contains('already verified') ||
        normalized.contains('user is already verified');
  }

  bool _isInactiveAccountError(String errorMessage) {
    final normalized = errorMessage.toLowerCase();
    return normalized.contains('inactive') ||
        normalized.contains('disabled') ||
        normalized.contains('blocked') ||
        normalized.contains('suspended') ||
        normalized.contains('deactivated');
  }

  String? _validatePhoneNumberForProfile(String? phoneNumber) {
    final value = phoneNumber?.trim() ?? '';
    if (value.isEmpty) {
      return 'Please enter your phone number before continuing.';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 9 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number (9 to 15 digits).';
    }

    return null;
  }

  String _normalizeGenderForBackend(String? gender) {
    final value = (gender ?? '').trim();
    if (value.isEmpty) return '';

    final lowered = value.toLowerCase();
    if (lowered == 'male' || lowered == 'm') return 'male';
    if (lowered == 'female' || lowered == 'f') return 'female';

    if (value == 'ذكر') return 'male';
    if (value == 'أنثى') return 'female';

    return lowered;
  }

  String _normalizeProfileInfoUpdateError(String message) {
    final normalized = message.trim().toLowerCase();

    if (normalized.isEmpty) {
      return 'Could not save profile information. Please try again.';
    }
    if (normalized.contains('date_of_birth') ||
        normalized.contains('birth date') ||
        normalized.contains('dob')) {
      return 'Birthdate is invalid. Please select a valid date and try again.';
    }
    if (normalized.contains('gender')) {
      return 'Gender value is invalid. Please reselect your gender and try again.';
    }
    if (normalized.contains('phone')) {
      return 'Phone number is invalid. Please check the number and try again.';
    }
    if (normalized.contains('token') && normalized.contains('expired')) {
      return 'Your session expired while saving profile info. Please sign in again.';
    }
    if (normalized.contains('authentication credentials were not provided')) {
      return 'Your session is missing authentication credentials. Please sign in again.';
    }
    if (normalized.contains('unauthorized') ||
        normalized.contains('forbidden')) {
      return 'You are not allowed to update profile info right now. Please sign in again.';
    }

    return message;
  }

  Future<bool> _cacheAndEmitUser(
    UserAuthEntity user, {
    bool asProfileUpdated = false,
    String? correlationId,
  }) async {
    if (!(user.accessToken?.isNotEmpty == true)) {
      _log.error(
        'cache_emit_user:missing_access_token',
        data: {
          'cid': correlationId,
          'email': user.email,
          'asProfileUpdated': asProfileUpdated,
        },
      );
      await authRepository.clearCachedSession();
      emit(
        const AuthError(
          'Authentication session is not available. Please sign in again.',
        ),
      );
      return false;
    }

    await authRepository.cacheSession(user, correlationId: correlationId);
    await authRepository.clearPendingSignupSession();
    if (asProfileUpdated) {
      emit(AuthProfileUpdated(user));
    } else {
      emit(AuthLoaded(user));
    }
    return true;
  }

  String _ensureAuthFlowCorrelationId({required String context}) {
    if (_activeAuthFlowCorrelationId != null &&
        _activeAuthFlowCorrelationId!.isNotEmpty) {
      return _activeAuthFlowCorrelationId!;
    }

    final generated =
        'auth-${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}';
    _activeAuthFlowCorrelationId = generated;
    _log.info(
      'auth_flow:cid_created',
      data: {'cid': generated, 'context': context},
    );
    return generated;
  }

  String _startAuthFlowCorrelationId({required String context}) {
    final generated = _newCorrelationId(context: context);
    _activeAuthFlowCorrelationId = generated;
    return generated;
  }

  String _newCorrelationId({required String context}) {
    final generated =
        'auth-${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}';
    _log.info(
      'auth_flow:cid_created',
      data: {'cid': generated, 'context': context},
    );
    return generated;
  }

  UserAuthEntity _mergeWithCurrentUser(
    AuthState currentState,
    UserAuthEntity updatedUser,
  ) {
    final currentUser = currentState is AuthLoaded
        ? currentState.user
        : currentState is AuthProfileUpdated
        ? currentState.user
        : updatedUser;

    return updatedUser.copyWith(
      username: (updatedUser.username.isNotEmpty)
          ? updatedUser.username
          : currentUser.username,
      nickname: (updatedUser.nickname?.isNotEmpty ?? false)
          ? updatedUser.nickname
          : currentUser.nickname,
      email: (updatedUser.email.isNotEmpty)
          ? updatedUser.email
          : currentUser.email,
      password: (updatedUser.password?.isNotEmpty ?? false)
          ? updatedUser.password
          : currentUser.password,

      birthDate: updatedUser.birthDate ?? currentUser.birthDate,
      age:
          updatedUser.age ??
          currentUser.age ??
          calculateAge(updatedUser.birthDate ?? currentUser.birthDate),
      gender: updatedUser.gender ?? currentUser.gender,
      phoneNumber: updatedUser.phoneNumber ?? currentUser.phoneNumber,
      isVerified: updatedUser.isVerified || currentUser.isVerified,
    );
  }

  /// Check if user profile is complete for signup flow
  /// Profile is considered complete when: birthDate, gender, and phoneNumber are all non-empty
  bool _isUserProfileComplete(UserAuthEntity user) {
    final hasBirthDate = user.birthDate != null;
    final hasGender = user.gender != null && user.gender!.trim().isNotEmpty;
    final hasPhoneNumber =
        user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty;

    return hasBirthDate && hasGender && hasPhoneNumber;
  }
}

import 'dart:developer' as developer;

import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/core/utils/age_utils.dart';
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
  static const String _logName = 'AuthCubit';
  UserAuthEntity? _pendingSignupUser;

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
    _log('login:start', data: {'email': email});
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) {
        _log('login:error', data: {'message': failure.errorMessage});

        // Check if account is inactive/restricted
        if (_isInactiveAccountError(failure.errorMessage)) {
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
        _log(
          'login:success',
          data: {'email': user.email, 'isVerified': user.isVerified},
        );

        // Login now goes straight to the authenticated session.
        return _cacheAndEmitUser(user);
      },
    );
  }

  Future<void> signup(String nickname, String email, String password) async {
    _log('signup:start', data: {'email': email, 'nickname': nickname});
    _pendingSignupUser = null;
    emit(AuthLoading());
    final result = await signupUseCase(
      SignupParams(nickname: nickname, email: email, password: password),
    );
    result.fold(
      (failure) {
        _log('signup:error', data: {'message': failure.errorMessage});
        // If email already exists (unverified), send OTP for verification
        if (_isNotVerifiedError(failure.errorMessage) ||
            _isEmailAlreadyExistsError(failure.errorMessage)) {
          _log('signup:email_unverified_send_otp', data: {'email': email});
          _pendingSignupUser = UserAuthEntity(
            username: nickname,
            nickname: nickname,
            email: email,
            password: password,

            isVerified: false,
          );
          return sendVerificationOtp(email);
        } else {
          emit(AuthError(failure.errorMessage));
        }
      },
      (otpEntity) {
        _log('signup:otp_sent', data: {'email': email});
        // OTP was sent; store signup data and wait for verification
        _pendingSignupUser = UserAuthEntity(
          username: nickname,
          nickname: nickname,
          email: email,
          password: password,

          isVerified: false,
        );
        return sendVerificationOtp(email, userAuthEntity: _pendingSignupUser);
      },
    );
  }

  Future<bool> logout(String email, String password) async {
    _log('logout:start', data: {'email': email});
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    return result.fold(
      (failure) {
        _log('logout:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (_) async {
        _log('logout:success');
        await authRepository.clearCachedSession();
        _pendingSignupUser = null;
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<bool> deleteAccount(String password) async {
    _log('delete_account:start', data: {'passwordLength': password});
    emit(AuthLoading());
    final result = await deleteAccountUseCase(
      DeleteAccountParams(password: password),
    );
    return result.fold(
      (failure) {
        _log('delete_account:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (_) async {
        _log('delete_account:success');
        await authRepository.clearCachedSession();
        _pendingSignupUser = null;
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<void> googleSignIn() async {
    _log('google_sign_in:start');
    emit(AuthLoading());
    final result = await googleSignInUseCase(
      const GoogleSignInParams(idToken: ''),
    );
    result.fold(
      (failure) {
        _log('google_sign_in:error', data: {'message': failure.errorMessage});

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
        _log(
          'google_sign_in:success',
          data: {'username': user.username, 'email': user.email},
        );
        return _cacheAndEmitUser(user);
      },
    );
  }

  Future<bool> updateProfileInfo({
    String? nickname,
    required DateTime birthDate,
    required String gender,
    String? phoneNumber,
  }) async {
    final currentState = state;
    if (currentState is! AuthLoaded && currentState is! AuthProfileUpdated) {
      _log('update_profile:skipped', data: {'reason': 'invalid_state'});
      return false;
    }

    final existingUser = currentState is AuthLoaded
        ? currentState.user
        : (currentState as AuthProfileUpdated).user;
    final result = await updateProfileInfoUseCase(
      UpdateProfileParams(
        dateOfBirth: birthDate.toIso8601String().split('T')[0],
        gender: gender,
        phoneNumber: phoneNumber ?? existingUser.phoneNumber ?? '',
      ),
    );

    return result.fold(
      (failure) {
        _log('update_profile:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        _log(
          'update_profile:success',
          data: {'username': updatedUser.username, 'email': updatedUser.email},
        );
        final mergedUser = _mergeWithCurrentUser(currentState, updatedUser);
        _cacheAndEmitUser(mergedUser, asProfileUpdated: true);

        // Refresh profile from backend to ensure complete sync
        refreshProfileFromBackend();

        return true;
      },
    );
  }

  Future<void> sendVerificationOtp(
    String email, {
    VerifyOtpParams? params,
    UserAuthEntity? userAuthEntity,
  }) async {
    _log('send_verification_otp:start', data: {'email': email});
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: params!.otp),
    );

    await result.fold(
      (failure) async {
        // _log(
        //   'send_verification_otp:error',
        //   data: {'message': failure.errorMessage},
        // );
        if (userAuthEntity != null &&
            _isAlreadyVerifiedError(failure.errorMessage)) {
          // _log(
          //   'send_verification_otp:already_verified_recover_login',
          //   data: {'email': fallbackUser.email},
          // );
          await _cacheAndEmitUser(userAuthEntity.copyWith(isVerified: true));
          return;
        }
        emit(AuthError(failure.errorMessage));
      },
      (message) async {
        // _log('send_verification_otp:success', data: {'message': message});
        emit(WaitingForOtpVerification(email));
      },
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    _log('verify_otp:start', data: {'email': email, 'otpLength': otp.length});
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: otp),
    );

    await result.fold(
      (failure) {
        _log('verify_otp:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
      },
      (user) async {
        _log(
          'verify_otp:success',
          data: {'email': email, 'emailVerified': user.isVerified},
        );

        // Build verified user from signup or login flow
        final verifiedUser = _buildVerifiedUser(user);

        // Determine next step based on flow
        if (_pendingSignupUser != null) {
          // SIGNUP FLOW: Account is verified via email, proceed to profile completion
          _log('verify_otp:signup_flow', data: {'email': email});
          final pendingSignupUser = _pendingSignupUser;
          emit(AuthLoading());

          final loginResult = await loginUseCase(
            LoginParams(
              email: pendingSignupUser!.email,
              password: pendingSignupUser.password ?? '',
            ),
          );

          return loginResult.fold(
            (failure) {
              _log(
                'verify_otp:signup_login_error',
                data: {'message': failure.errorMessage},
              );
              _pendingSignupUser = null;
              emit(
                const AuthError(
                  'Your account was verified, but sign-in could not be completed automatically. Please log in again.',
                ),
              );
              return;
            },
            (signedInUser) {
              _log(
                'verify_otp:signup_login_success',
                data: {'email': signedInUser.email},
              );
              _pendingSignupUser = null;

              final authenticatedUser = verifiedUser.copyWith(
                username: (signedInUser.username.isNotEmpty)
                    ? signedInUser.username
                    : verifiedUser.username,
                nickname: (signedInUser.nickname?.isNotEmpty ?? false)
                    ? signedInUser.nickname
                    : verifiedUser.nickname,
                email: signedInUser.email.isNotEmpty
                    ? signedInUser.email
                    : verifiedUser.email,
                password: pendingSignupUser.password,

                isVerified: true,
                birthDate: signedInUser.birthDate ?? verifiedUser.birthDate,
                age: signedInUser.age ?? verifiedUser.age,
                gender: signedInUser.gender ?? verifiedUser.gender,
                phoneNumber:
                    signedInUser.phoneNumber ?? verifiedUser.phoneNumber,
              );

              // Cache the authenticated session so profile completion can use the token.
              return _cacheAndEmitUser(authenticatedUser);
            },
          );
        } else {
          // FALLBACK: No flow context, just proceed with verified user
          _log('verify_otp:no_flow_context', data: {'email': email});
          return _cacheAndEmitUser(verifiedUser);
        }
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
        isVerified: true,
        birthDate: backendUser.birthDate ?? _pendingSignupUser!.birthDate,
        age: backendUser.age ?? _pendingSignupUser!.age,
        gender: backendUser.gender ?? _pendingSignupUser!.gender,
        phoneNumber: backendUser.phoneNumber ?? _pendingSignupUser!.phoneNumber,
      );
    }

    // From login flow, just mark as verified
    return backendUser.copyWith(isVerified: true);
  }

  Future<bool> restoreSession() async {
    _log('restore_session:start');
    final cachedUser = await authRepository.getCachedSession();
    if (cachedUser == null) {
      _log('restore_session:missing_cache');
      emit(const AuthInitial());
      return false;
    }

    _log(
      'restore_session:success',
      data: {'username': cachedUser.username, 'email': cachedUser.email},
    );
    emit(AuthLoaded(cachedUser));
    await refreshProfileFromBackend();
    return true;
  }

  Future<bool> refreshProfileFromBackend() async {
    final currentState = state;
    final currentUser = currentState is AuthLoaded
        ? currentState.user
        : currentState is AuthProfileUpdated
        ? currentState.user
        : await authRepository.getCachedSession();

    if (currentUser == null) {
      _log('refresh_profile:skipped', data: {'reason': 'no_current_user'});
      return false;
    }

    final result = await fetchProfileUseCase(NoParams());
    return result.fold(
      (failure) {
        _log('refresh_profile:error', data: {'message': failure.errorMessage});
        return false;
      },
      (remoteUser) {
        _log(
          'refresh_profile:success',
          data: {'username': remoteUser.username, 'email': remoteUser.email},
        );
        final mergedUser = _mergeWithCurrentUser(currentState, remoteUser);
        return _cacheAndEmitUser(
          mergedUser,
          asProfileUpdated: currentState is AuthProfileUpdated,
        );
      },
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _log('change_password:start');

    final result = await authRepository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: newPassword,
    );

    final success = result.fold(
      (failure) {
        _log('change_password:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        _log('change_password:success');

        // Update cached user with new password
        final currentState = state;
        if (currentState is AuthLoaded || currentState is AuthProfileUpdated) {
          final mergedUser = _mergeWithCurrentUser(currentState, updatedUser);
          _cacheAndEmitUser(
            mergedUser,
            asProfileUpdated: currentState is AuthProfileUpdated,
          );
        }

        return true;
      },
    );

    if (success) {
      // Refresh profile from backend to ensure sync
      await refreshProfileFromBackend();
    }

    return success;
  }

  Future<String?> requestForgotPasswordOtp({required String email}) async {
    _log('forgot_password_otp:start', data: {'email': email});
    final result = await requestForgotPasswordOtpUseCase(
      ForgotPasswordParams(email: email),
    );

    return result.fold(
      (failure) {
        _log(
          'forgot_password_otp:error',
          data: {'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return failure.errorMessage;
      },
      (message) {
        _log('forgot_password_otp:success', data: {'message': message});
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
    _log('reset_password:start', data: {'email': email});

    final result = await authRepository.resetPassword(
      email: email,
      otpCode: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      (failure) {
        _log('reset_password:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (otpEntity) {
        _log('reset_password:otp_sent');
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

  void _log(String message, {Map<String, dynamic>? data}) {
    developer.log(data == null ? message : '$message | $data', name: _logName);
  }

  Future<bool> _cacheAndEmitUser(
    UserAuthEntity user, {
    bool asProfileUpdated = false,
  }) async {
    await authRepository.cacheSession(user);
    if (asProfileUpdated) {
      emit(AuthProfileUpdated(user));
    } else {
      emit(AuthLoaded(user));
    }
    return true;
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
}

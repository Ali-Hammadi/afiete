import 'dart:developer' as developer;

import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/confirm_email_change_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/request_email_change_otp_usecase.dart';
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
  final UpdateProfileInfoUseCase updateProfileInfoUseCase;
  final RequestEmailChangeOtpUseCase requestEmailChangeOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ConfirmEmailChangeUseCase confirmEmailChangeUseCase;
  final AuthRepository authRepository;

  AuthCubit(
    this.loginUseCase,
    this.signupUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
    this.googleSignInUseCase,
    this.updateProfileInfoUseCase,
    this.requestEmailChangeOtpUseCase,
    this.verifyOtpUseCase,
    this.confirmEmailChangeUseCase,
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
        if (_isInactiveAccountError(failure.errorMessage)) {
          emit(
            const AuthError(
              'This account is inactive or restricted on the server, so sign-in is currently unavailable. Please contact support if you believe this is an error.',
            ),
          );
          return Future.value();
        }
        if (_isNotVerifiedError(failure.errorMessage)) {
          _log('login:account_not_verified_send_otp', data: {'email': email});
          return sendVerificationOtp(email);
        }
        if (_isAlreadyVerifiedError(failure.errorMessage)) {
          emit(
            const AuthError(
              'Your account is already verified. Please sign in directly.',
            ),
          );
          return Future.value();
        }
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log(
          'login:success',
          data: {'username': user.username, 'email': user.email},
        );
        // If account is not verified, send OTP instead of rejecting
        if (!user.isVerified) {
          _log(
            'login:account_not_verified_send_otp',
            data: {'email': user.email},
          );
          return sendVerificationOtp(user.email, fallbackUser: user);
        }
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
          return sendVerificationOtp(email);
        } else {
          emit(AuthError(failure.errorMessage));
        }
      },
      (user) {
        _log(
          'signup:success',
          data: {'username': user.username, 'email': user.email},
        );
        // If account is not verified, send OTP instead of loading
        if (!user.isVerified) {
          _pendingSignupUser = user;
          _log('signup:account_not_verified', data: {'email': user.email});
          return sendVerificationOtp(user.email);
        }
        _pendingSignupUser = null;
        return _cacheAndEmitUser(user);
      },
    );
  }

  Future<bool> logout(String email, String password) async {
    _log('logout:start', data: {'email': email});
    emit(AuthLoading());
    final result = await logoutUseCase(
      LogoutParams(email: email, password: password),
    );
    return result.fold(
      (failure) {
        _log('logout:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (user) async {
        _log(
          'logout:success',
          data: {'username': user.username, 'email': user.email},
        );
        await authRepository.clearCachedSession();
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<bool> deleteAccount(String email, String password) async {
    _log('delete_account:start', data: {'email': email});
    emit(AuthLoading());
    final result = await deleteAccountUseCase(
      DeleteAccountParams(email: email, password: password),
    );
    return result.fold(
      (failure) {
        _log('delete_account:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (user) async {
        _log(
          'delete_account:success',
          data: {'username': user.username, 'email': user.email},
        );
        await authRepository.clearCachedSession();
        emit(const AuthInitial());
        return true;
      },
    );
  }

  Future<void> googleSignIn() async {
    _log('google_sign_in:start');
    emit(AuthLoading());
    final result = await googleSignInUseCase(const GoogleSignInParams());
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
      UpdateProfileInfoParams(
        username: existingUser.username,
        nickname: nickname ?? existingUser.nickname,
        birthDate: birthDate,
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
        return _cacheAndEmitUser(mergedUser, asProfileUpdated: true);
      },
    );
  }

  Future<String?> requestEmailChangeOtp({required String newEmail}) async {
    _log('request_email_otp:start', data: {'newEmail': newEmail});
    final currentState = state;
    if (currentState is! AuthLoaded && currentState is! AuthProfileUpdated) {
      _log('request_email_otp:skipped', data: {'reason': 'invalid_state'});
      return null;
    }

    final existingUser = currentState is AuthLoaded
        ? currentState.user
        : (currentState as AuthProfileUpdated).user;

    final result = await requestEmailChangeOtpUseCase(
      RequestEmailChangeOtpParams(
        username: existingUser.username,
        newEmail: newEmail,
      ),
    );

    return result.fold(
      (failure) {
        _log(
          'request_email_otp:error',
          data: {'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return failure.errorMessage;
      },
      (message) {
        _log('request_email_otp:success', data: {'message': message});
        return null;
      },
    );
  }

  Future<bool> confirmEmailChange({
    required String newEmail,
    required String otp,
  }) async {
    _log('confirm_email_change:start', data: {'newEmail': newEmail});
    final currentState = state;
    if (currentState is! AuthLoaded && currentState is! AuthProfileUpdated) {
      _log('confirm_email_change:skipped', data: {'reason': 'invalid_state'});
      return false;
    }

    final existingUser = currentState is AuthLoaded
        ? currentState.user
        : (currentState as AuthProfileUpdated).user;

    final result = await confirmEmailChangeUseCase(
      ConfirmEmailChangeParams(
        username: existingUser.username,
        newEmail: newEmail,
        otp: otp,
      ),
    );

    return result.fold(
      (failure) {
        _log(
          'confirm_email_change:error',
          data: {'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        _log(
          'confirm_email_change:success',
          data: {'username': updatedUser.username, 'email': updatedUser.email},
        );
        final mergedUser = _mergeWithCurrentUser(currentState, updatedUser);
        emit(AuthProfileUpdated(mergedUser));
        return true;
      },
    );
  }

  Future<void> sendVerificationOtp(
    String email, {
    UserAuthEntity? fallbackUser,
  }) async {
    _log('send_verification_otp:start', data: {'email': email});
    emit(AuthLoading());
    final result = await requestEmailChangeOtpUseCase(
      RequestEmailChangeOtpParams(username: email, newEmail: email),
    );

    await result.fold(
      (failure) async {
        _log(
          'send_verification_otp:error',
          data: {'message': failure.errorMessage},
        );
        if (fallbackUser != null &&
            _isAlreadyVerifiedError(failure.errorMessage)) {
          _log(
            'send_verification_otp:already_verified_recover_login',
            data: {'email': fallbackUser.email},
          );
          await _cacheAndEmitUser(fallbackUser.copyWith(isVerified: true));
          return;
        }
        emit(AuthError(failure.errorMessage));
      },
      (message) async {
        _log('send_verification_otp:success', data: {'message': message});
        emit(WaitingForOtpVerification(email));
      },
    );
  }

  Future<void> verifyOtpCode(String email, String code) async {
    _log('verify_otp:start', data: {'email': email, 'codeLength': code.length});
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, code: code),
    );

    result.fold(
      (failure) {
        _log('verify_otp:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log(
          'verify_otp:success',
          data: {'username': user.username, 'email': user.email},
        );
        final mergedUser = _pendingSignupUser == null
            ? user.copyWith(isVerified: true)
            : user.copyWith(
                username: _pendingSignupUser!.username.isNotEmpty
                    ? _pendingSignupUser!.username
                    : user.username,
                nickname: (_pendingSignupUser?.nickname.isNotEmpty ?? false)
                    ? _pendingSignupUser!.nickname
                    : user.nickname,
                email: _pendingSignupUser!.email.isNotEmpty
                    ? _pendingSignupUser!.email
                    : user.email,
                password: _pendingSignupUser!.password.isNotEmpty
                    ? _pendingSignupUser!.password
                    : user.password,
                token: user.token,
                isVerified: true,
                birthDate: user.birthDate ?? _pendingSignupUser!.birthDate,
                age: user.age ?? _pendingSignupUser!.age,
                gender: user.gender ?? _pendingSignupUser!.gender,
                phoneNumber:
                    user.phoneNumber ?? _pendingSignupUser!.phoneNumber,
              );
        _pendingSignupUser = null;
        return _cacheAndEmitUser(mergedUser);
      },
    );
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
    return true;
  }

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    _log('change_password:start', data: {'email': email});

    final result = await authRepository.changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) {
        _log('change_password:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (message) {
        _log('change_password:success', data: {'message': message});
        return true;
      },
    );
  }

  Future<String?> requestForgotPasswordOtp({required String email}) async {
    _log('forgot_password_otp:start', data: {'email': email});
    final result = await requestEmailChangeOtpUseCase(
      RequestEmailChangeOtpParams(username: email, newEmail: email),
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
  }) async {
    _log('reset_password:start', data: {'email': email});

    final result = await authRepository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) {
        _log('reset_password:error', data: {'message': failure.errorMessage});
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (message) {
        _log('reset_password:success', data: {'message': message});
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
      username: updatedUser.username.isNotEmpty
          ? updatedUser.username
          : currentUser.username,
      nickname: updatedUser.nickname.isNotEmpty
          ? updatedUser.nickname
          : currentUser.nickname,
      email: updatedUser.email.isNotEmpty
          ? updatedUser.email
          : currentUser.email,
      password: updatedUser.password.isNotEmpty
          ? updatedUser.password
          : currentUser.password,
      token: updatedUser.token.isNotEmpty
          ? updatedUser.token
          : currentUser.token,
      birthDate: updatedUser.birthDate ?? currentUser.birthDate,
      age: updatedUser.age ?? currentUser.age,
      gender: updatedUser.gender ?? currentUser.gender,
      phoneNumber: updatedUser.phoneNumber ?? currentUser.phoneNumber,
      isVerified: updatedUser.isVerified || currentUser.isVerified,
    );
  }
}

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
        if (_isNotVerifiedError(failure.errorMessage)) {
          _log('login:account_not_verified_send_otp', data: {'email': email});
          return sendVerificationOtp(email);
        }
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log('login:success', data: {'userId': user.id, 'email': user.email});
        // If account is not verified, send OTP instead of rejecting
        if (!user.isVerified) {
          _log(
            'login:account_not_verified_send_otp',
            data: {'email': user.email},
          );
          return sendVerificationOtp(user.email);
        }
        emit(AuthLoaded(user));
      },
    );
  }

  Future<void> signup(String name, String email, String password) async {
    _log('signup:start', data: {'email': email, 'name': name});
    emit(AuthLoading());
    final result = await signupUseCase(
      SignupParams(name: name, email: email, password: password),
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
        _log('signup:success', data: {'userId': user.id, 'email': user.email});
        // If account is not verified, send OTP instead of loading
        if (!user.isVerified) {
          _log('signup:account_not_verified', data: {'email': user.email});
          return sendVerificationOtp(user.email);
        }
        emit(AuthLoaded(user));
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
      (user) {
        _log('logout:success', data: {'userId': user.id, 'email': user.email});
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
      (user) {
        _log(
          'delete_account:success',
          data: {'userId': user.id, 'email': user.email},
        );
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
        emit(AuthError(failure.errorMessage));
      },
      (user) {
        _log(
          'google_sign_in:success',
          data: {'userId': user.id, 'email': user.email},
        );
        emit(AuthLoaded(user));
      },
    );
  }

  Future<bool> updateProfileInfo({
    required String name,
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
        userId: existingUser.id,
        name: name,
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
          data: {'userId': updatedUser.id, 'email': updatedUser.email},
        );
        emit(AuthProfileUpdated(updatedUser));
        return true;
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
      RequestEmailChangeOtpParams(userId: existingUser.id, newEmail: newEmail),
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
        userId: existingUser.id,
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
          data: {'userId': updatedUser.id, 'email': updatedUser.email},
        );
        emit(AuthProfileUpdated(updatedUser));
        return true;
      },
    );
  }

  Future<void> sendVerificationOtp(String email) async {
    _log('send_verification_otp:start', data: {'email': email});
    emit(AuthLoading());
    final result = await requestEmailChangeOtpUseCase(
      RequestEmailChangeOtpParams(userId: email, newEmail: email),
    );

    result.fold(
      (failure) {
        _log(
          'send_verification_otp:error',
          data: {'message': failure.errorMessage},
        );
        emit(AuthError(failure.errorMessage));
      },
      (message) {
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
          data: {'userId': user.id, 'email': user.email},
        );
        emit(AuthLoaded(user.copyWith(isVerified: true)));
      },
    );
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
      RequestEmailChangeOtpParams(userId: email, newEmail: email),
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

  void _log(String message, {Map<String, dynamic>? data}) {
    developer.log(data == null ? message : '$message | $data', name: _logName);
  }
}

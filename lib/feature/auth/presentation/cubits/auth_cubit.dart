import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/confirm_email_change_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/request_email_change_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/google_signin_usecase.dart';
import '../../domain/usecase/update_profile_info_usecase.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final UpdateProfileInfoUseCase updateProfileInfoUseCase;
  final RequestEmailChangeOtpUseCase requestEmailChangeOtpUseCase;
  final ConfirmEmailChangeUseCase confirmEmailChangeUseCase;

  AuthCubit(
    this.loginUseCase,
    this.signupUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
    this.googleSignInUseCase,
    this.updateProfileInfoUseCase,
    this.requestEmailChangeOtpUseCase,
    this.confirmEmailChangeUseCase,
  ) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(AuthLoaded(user)),
    );
  }

  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading());
    final result = await signupUseCase(
      SignupParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(AuthLoaded(user)),
    );
  }

  Future<void> logout(String email, String password) async {
    emit(AuthLoading());
    final result = await logoutUseCase(
      LogoutParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(AuthLoaded(user)),
    );
  }

  Future<void> deleteAccount(String email, String password) async {
    emit(AuthLoading());
    final result = await deleteAccountUseCase(
      DeleteAccountParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(AuthLoaded(user)),
    );
  }

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    final result = await googleSignInUseCase(const GoogleSignInParams());
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(AuthLoaded(user)),
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
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        emit(AuthProfileUpdated(updatedUser));
        return true;
      },
    );
  }

  Future<String?> requestEmailChangeOtp({required String newEmail}) async {
    final currentState = state;
    if (currentState is! AuthLoaded && currentState is! AuthProfileUpdated) {
      return null;
    }

    final existingUser = currentState is AuthLoaded
        ? currentState.user
        : (currentState as AuthProfileUpdated).user;

    final result = await requestEmailChangeOtpUseCase(
      RequestEmailChangeOtpParams(userId: existingUser.id, newEmail: newEmail),
    );

    return result.fold((failure) {
      emit(AuthError(failure.errorMessage));
      return failure.errorMessage;
    }, (message) => message);
  }

  Future<bool> confirmEmailChange({
    required String newEmail,
    required String otp,
  }) async {
    final currentState = state;
    if (currentState is! AuthLoaded && currentState is! AuthProfileUpdated) {
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
        emit(AuthError(failure.errorMessage));
        return false;
      },
      (updatedUser) {
        emit(AuthProfileUpdated(updatedUser));
        return true;
      },
    );
  }
}

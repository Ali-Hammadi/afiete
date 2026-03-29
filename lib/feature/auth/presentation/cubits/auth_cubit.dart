import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/google_signin_usecase.dart';
import '../../domain/entities/auth_user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  AuthCubit(
    this.loginUseCase,
    this.signupUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
    this.googleSignInUseCase,
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
}

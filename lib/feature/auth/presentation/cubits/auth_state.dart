part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final UserAuthEntity user;

  const AuthLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class AuthProfileUpdated extends AuthState {
  final UserAuthEntity user;

  const AuthProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class WaitingForOtpVerification extends AuthState {
  final String email;

  const WaitingForOtpVerification(this.email);

  @override
  List<Object> get props => [email];
}


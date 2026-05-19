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

/// The account is inactive and can be reactivated from a dedicated flow.
class AccountReactivationRequired extends AuthState {
  final String email;
  final String password;
  final String message;

  const AccountReactivationRequired({
    required this.email,
    required this.password,
    required this.message,
  });

  @override
  List<Object> get props => [email, password, message];
}

/// App state when a user account was removed or the local session must be reset.
class AuthReset extends AuthState {
  final String? message;

  const AuthReset([this.message]);

  @override
  List<Object> get props => [message ?? ''];
}

class WaitingForOtpVerification extends AuthState {
  final String email;
  final int? expiresInSeconds;

  const WaitingForOtpVerification(this.email, {this.expiresInSeconds});

  @override
  List<Object> get props => [email, expiresInSeconds ?? 0];
}

/// OTP has been sent to email; waiting for user input
class OtpSent extends AuthState {
  final String email;
  final int expiresInSeconds;

  const OtpSent({required this.email, required this.expiresInSeconds});

  @override
  List<Object> get props => [email, expiresInSeconds];
}

/// OTP verification successful; user is verified but profile not yet complete (signup flow)
class SignupOtpVerified extends AuthState {
  final UserAuthEntity user;

  const SignupOtpVerified(this.user);

  @override
  List<Object> get props => [user];
}

/// Profile update failed
class ProfileUpdateError extends AuthState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object> get props => [message];
}

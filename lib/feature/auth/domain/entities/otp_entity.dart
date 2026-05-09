import 'package:equatable/equatable.dart';

/// Represents OTP response from backend during signup and password recovery flows.
/// Indicates OTP has been sent and provides expiration information.
class OtpEntity extends Equatable {
  final String email;
  final int expiresInSeconds;
  final String? message;

  const OtpEntity({
    required this.email,
    required this.expiresInSeconds,
    this.message,
  });

  @override
  List<Object?> get props => [email, expiresInSeconds, message];
}

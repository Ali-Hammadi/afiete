import 'package:equatable/equatable.dart';
import '../../domain/entities/otp_entity.dart';

/// Data model for OTP response from backend.
/// Indicates OTP has been sent and provides expiration information.
class OtpModel extends Equatable {
  final String email;
  final int expiresInSeconds;
  final String? message;

  const OtpModel({
    required this.email,
    required this.expiresInSeconds,
    this.message,
  });

  /// Parse JSON response from backend.
  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      email: json['email'] ?? '',
      expiresInSeconds: json['expires_in'] ?? json['expiresInSeconds'] ?? 600,
      message: json['message'],
    );
  }

  /// Convert model to JSON for API requests.
  Map<String, dynamic> toJson() => {
    'email': email,
    'expires_in': expiresInSeconds,
    'message': message,
  };

  /// Convert data model to domain entity.
  OtpEntity toEntity() => OtpEntity(
    email: email,
    expiresInSeconds: expiresInSeconds,
    message: message,
  );

  @override
  List<Object?> get props => [email, expiresInSeconds, message];
}

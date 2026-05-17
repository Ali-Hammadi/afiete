import 'package:afiete/feature/auth/data/models/otp_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OtpModel parses backend payload with default expiry', () {
    final model = OtpModel.fromJson({
      'email': 'user@example.com',
      'message': 'OTP sent',
    });

    expect(model.email, 'user@example.com');
    expect(model.expiresInSeconds, 60);
    expect(model.message, 'OTP sent');
  });

  test('OtpModel parses alternate expiry key', () {
    final model = OtpModel.fromJson({
      'email': 'user@example.com',
      'expiresInSeconds': 240,
      'message': 'Try again later',
    });

    expect(model.email, 'user@example.com');
    expect(model.expiresInSeconds, 240);
    expect(model.message, 'Try again later');
  });
}

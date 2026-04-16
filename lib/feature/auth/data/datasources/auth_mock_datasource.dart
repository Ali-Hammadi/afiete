import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/data/models/user_model.dart';

class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  UserModel _currentUser = const UserModel(
    id: 'mock-user-1',
    name: 'Mock User',
    email: 'mock.user@afiete.app',
    password: '123456',
    token: 'mock-token-123',
  );
  String? _pendingEmailOtp;
  String? _pendingEmailAddress;

  @override
  Future<UserModel> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: email,
      password: password,
      token: 'mock-token-login',
    );
    return _currentUser;
  }

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = UserModel(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      token: 'mock-token-signup',
    );
    return _currentUser;
  }

  @override
  Future<UserModel> logout(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: email,
      password: '',
      token: '',
    );
  }

  @override
  Future<UserModel> deleteAccount(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return UserModel(
      id: _currentUser.id,
      name: 'Deleted User',
      email: email,
      password: '',
      token: '',
    );
  }

  @override
  Future<UserModel> googleSignIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    _currentUser = const UserModel(
      id: 'google-mock-user',
      name: 'Google Mock User',
      email: 'google.mock@afiete.app',
      password: '',
      token: 'mock-google-token',
    );
    return _currentUser;
  }

  @override
  Future<UserModel> updateProfileInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    _currentUser = _currentUser.copyWith(
      id: userId.isNotEmpty ? userId : _currentUser.id,
      name: name.isNotEmpty ? name : _currentUser.name,
      birthDate: birthDate,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
    );
    return _currentUser;
  }

  @override
  Future<String> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _pendingEmailAddress = newEmail;
    _pendingEmailOtp = '1234';
    return 'Verification code sent to $newEmail (mock OTP: 1234)';
  }

  @override
  Future<UserModel> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (_pendingEmailAddress != newEmail || _pendingEmailOtp != otp) {
      throw Exception('Invalid OTP');
    }
    _currentUser = _currentUser.copyWith(
      id: userId.isNotEmpty ? userId : _currentUser.id,
      email: newEmail,
    );
    _pendingEmailOtp = null;
    _pendingEmailAddress = null;
    return _currentUser;
  }
}

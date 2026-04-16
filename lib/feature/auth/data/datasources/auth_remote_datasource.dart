import '../models/user_model.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String name, String email, String password);
  Future<UserModel> logout(String email, String password);
  Future<UserModel> deleteAccount(String email, String password);
  Future<UserModel> googleSignIn();
  Future<UserModel> updateProfileInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  });

  Future<String> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  });

  Future<UserModel> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  late final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({required Dio dio})
    : _dio = dio,
      _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
        }
        return user;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Login failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
        }
        return user;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Signup failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.signup),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> logout(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.logout,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        await TokenStorage.clearToken();
        return UserModel(
          id: email,
          name: 'Logged Out',
          email: email,
          password: '',
          token: '',
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Logout failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.logout),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> deleteAccount(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.deleteAccount,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        await TokenStorage.clearToken();
        return UserModel(
          id: email,
          name: 'Account Deleted',
          email: email,
          password: '',
          token: '',
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Delete account failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.deleteAccount),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> googleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Google Sign-In cancelled');
      }
      final auth = await account.authentication;
      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {'id_token': auth.idToken},
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
        }
        return user;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Google login failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.googleLogin),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> updateProfileInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: {
          'userId': userId,
          'name': name,
          'birthDate': birthDate.toIso8601String().split('T').first,
          'gender': gender,
          'phoneNumber': phoneNumber,
        },
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
        }
        return user;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Profile update failed',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.updateProfile),
        error: e.toString(),
      );
    }
  }

  @override
  Future<String> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.requestEmailChangeOtp,
        data: {'userId': userId, 'newEmail': newEmail},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message']?.toString() ?? 'OTP sent successfully.';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to request email OTP',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.requestEmailChangeOtp,
        ),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.confirmEmailChange,
        data: {'userId': userId, 'newEmail': newEmail, 'otp': otp},
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
        }
        return user;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Email confirmation failed',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.confirmEmailChange),
        error: e.toString(),
      );
    }
  }

  UserModel _resolveUserFromAuthResponse(dynamic responseData) {
    final dataMap = responseData as Map<String, dynamic>;
    final userJson =
        (dataMap['user'] as Map<String, dynamic>?) ??
        Map<String, dynamic>.from(dataMap);

    if ((userJson['token'] == null || '${userJson['token']}'.isEmpty) &&
        dataMap['token'] != null) {
      userJson['token'] = dataMap['token'];
    }

    return UserModel.fromJson(userJson);
  }
}

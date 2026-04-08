import '../models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String name, String email, String password);
  Future<UserModel> logout(String email, String password);
  Future<UserModel> deleteAccount(String email, String password);
  Future<UserModel> googleSignIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _modulePath = '/api/auth';

  final Dio _dio;
  late final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({required Dio dio})
    : _dio = dio,
      _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_modulePath/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
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
        requestOptions: RequestOptions(path: '$_modulePath/login'),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$_modulePath/signup',
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
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
        requestOptions: RequestOptions(path: '$_modulePath/signup'),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> logout(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_modulePath/logout',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
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
        requestOptions: RequestOptions(path: '$_modulePath/logout'),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> deleteAccount(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_modulePath/delete-account',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
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
        requestOptions: RequestOptions(path: '$_modulePath/delete-account'),
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
        '$_modulePath/google-login',
        data: {'id_token': auth.idToken},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
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
        requestOptions: RequestOptions(path: '$_modulePath/google-login'),
        error: e.toString(),
      );
    }
  }
}

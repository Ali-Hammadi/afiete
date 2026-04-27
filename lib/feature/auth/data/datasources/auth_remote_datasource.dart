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
      // Get tokens directly from /api/token/
      final tokenResponse = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.tokenObtainPair,
        data: {'email': email, 'password': password},
      );

      final accessToken = tokenResponse.data?['access']?.toString() ?? '';
      final refreshToken = tokenResponse.data?['refresh']?.toString() ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw DioException(
          requestOptions: tokenResponse.requestOptions,
          response: tokenResponse,
          error: 'Login failed: missing access or refresh token.',
        );
      }

      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return UserModel(
        id: email,
        name: email.split('@').first,
        email: email,
        password: password,
        token: accessToken,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.tokenObtainPair),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    try {
      // Register user at /api/patients/register/
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: UserModel.signupRequestBody(
          nickname: name,
          email: email,
          password: password,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Signup failed: ${response.statusCode}',
        );
      }

      // Get tokens from /api/token/ after successful registration
      final tokenResponse = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.tokenObtainPair,
        data: {'email': email, 'password': password},
      );

      final accessToken = tokenResponse.data?['access']?.toString() ?? '';
      final refreshToken = tokenResponse.data?['refresh']?.toString() ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw DioException(
          requestOptions: tokenResponse.requestOptions,
          response: tokenResponse,
          error: 'Failed to obtain tokens after signup',
        );
      }

      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return UserModel(
        id: email,
        name: name,
        email: email,
        password: password,
        token: accessToken,
      );
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
      await TokenStorage.clearTokens();
      return UserModel(
        id: email,
        name: 'Logged Out',
        email: email,
        password: '',
        token: '',
      );
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
    throw DioException(
      requestOptions: RequestOptions(path: ApiEndpoints.deleteAccount),
      error:
          'Delete account endpoint is not available in the current backend schema.',
    );
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: 'Google Sign-In is not available in backend yet.',
          message: 'Google Sign-In is not available in backend yet.',
        );
      }
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
      final response = await _dio.patch(
        ApiEndpoints.updateProfile,
        data: {
          'user': {
            'birth_date': birthDate.toIso8601String().split('T').first,
            'gender': gender.toLowerCase(),
            'phone': phoneNumber,
          },
        },
      );
      if (response.statusCode == 200) {
        final accessToken = await TokenStorage.getAccessToken();
        final dataMap =
            (response.data as Map<String, dynamic>?) ?? <String, dynamic>{};
        final userMap =
            (dataMap['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

        return UserModel(
          id: userId,
          name: name,
          email: userMap['email']?.toString() ?? '',
          password: '',
          token: accessToken ?? '',
          birthDate: userMap['birth_date'] != null
              ? DateTime.tryParse(userMap['birth_date'].toString())
              : birthDate,
          gender: userMap['gender']?.toString() ?? gender,
          phoneNumber: userMap['phone']?.toString() ?? phoneNumber,
        );
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
        data: {'email': newEmail},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractMessage(response.data) ?? 'OTP sent successfully.';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to request email OTP',
      );
    } on DioException catch (e) {
      final message = _extractMessage(e.response?.data);
      if (e.response?.statusCode == 400 &&
          message == 'User with this email does not exist') {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error:
              'Email change OTP is not supported by backend yet. The current endpoint only resends OTP for existing account email verification.',
          message:
              'Email change OTP is not supported by backend yet. The current endpoint only resends OTP for existing account email verification.',
        );
      }
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
        data: {'email': newEmail, 'code': otp},
      );
      if (response.statusCode == 200) {
        final accessToken = await TokenStorage.getAccessToken();
        return UserModel(
          id: userId,
          name: '',
          email: newEmail,
          password: '',
          token: accessToken ?? '',
        );
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Email confirmation failed',
      );
    } on DioException catch (e) {
      final message = _extractMessage(e.response?.data);
      if (e.response?.statusCode == 400 && message == 'Invalid OTP or email') {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error:
              'Email change confirmation is not fully supported by backend yet for new emails.',
          message:
              'Email change confirmation is not fully supported by backend yet for new emails.',
        );
      }
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

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }

      for (final value in data.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
      }
    }
    return null;
  }
}

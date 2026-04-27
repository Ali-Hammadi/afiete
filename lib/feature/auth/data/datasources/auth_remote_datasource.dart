import 'dart:developer' as developer;

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

  Future<bool> sendVerificationOtp(String email);

  Future<UserModel> verifyOtp(String email, String code);

  Future<String> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _logName = 'AuthRemoteDataSource';
  final Dio _dio;
  late final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({required Dio dio})
    : _dio = dio,
      _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      _logInfo('login:start', data: {'email': email});
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      _logInfo(
        'login:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      final data = response.data ?? <String, dynamic>{};
      final accessToken =
          data['access']?.toString() ??
          data['token']?.toString() ??
          data['access_token']?.toString() ??
          '';
      final refreshToken =
          data['refresh']?.toString() ??
          data['refresh_token']?.toString() ??
          '';

      if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        _logInfo('login:token_saved', data: {'type': 'access+refresh'});
      } else if (accessToken.isNotEmpty) {
        await TokenStorage.saveToken(accessToken);
        _logInfo('login:token_saved', data: {'type': 'access_only'});
      }

      final userData =
          (data['user'] as Map<String, dynamic>?) ??
          <String, dynamic>{'email': email, 'nickname': email.split('@').first};

      return UserModel(
        id: email,
        name:
            (userData['name'] ?? userData['nickname'] ?? email.split('@').first)
                .toString(),
        email: (userData['email'] ?? email).toString(),
        password: password,
        token: accessToken,
      );
    } on DioException catch (e) {
      _logError(
        'login:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
        );
      }
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
      _logInfo('signup:start', data: {'email': email, 'nickname': name});
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: UserModel.signupRequestBody(
          nickname: name,
          email: email,
          password: password,
        ),
      );
      _logInfo(
        'signup:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Signup failed: ${response.statusCode}',
        );
      }

      return UserModel(
        id: email,
        name: name,
        email: email,
        password: password,
        token: '',
        isVerified:
            (response.data as Map<String, dynamic>?)?['is_verified'] == true,
      );
    } on DioException catch (e) {
      _logError(
        'signup:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
        );
      }
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
      _logInfo('logout:start', data: {'email': email});
      await TokenStorage.clearTokens();
      _logInfo('logout:success', data: {'email': email});
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
    try {
      _logInfo('delete_account:start', data: {'email': email});
      final response = await _dio.post(
        ApiEndpoints.deleteAccount,
        data: {'email': email, 'password': password},
      );
      _logInfo(
        'delete_account:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await TokenStorage.clearTokens();
        return UserModel(
          id: email,
          name: 'Deleted User',
          email: email,
          password: '',
          token: '',
        );
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Delete account failed',
      );
    } on DioException catch (e) {
      _logError(
        'delete_account:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
        );
      }
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
      _logInfo('google_sign_in:start');
      final account = await _googleSignIn.signIn();
      if (account == null) {
        _logError('google_sign_in:cancelled');
        throw Exception('Google Sign-In cancelled');
      }
      final auth = await account.authentication;
      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {'id_token': auth.idToken},
      );
      _logInfo(
        'google_sign_in:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );
      if (response.statusCode == 200) {
        final user = _resolveUserFromAuthResponse(response.data);
        if (user.token.isNotEmpty) {
          await TokenStorage.saveToken(user.token);
          _logInfo('google_sign_in:token_saved');
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
      _logError(
        'google_sign_in:failed',
        error: {
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
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
      _logInfo(
        'update_profile:start',
        data: {
          'userId': userId,
          'name': name,
          'birthDate': birthDate.toIso8601String(),
          'gender': gender,
          'phoneNumber': phoneNumber,
        },
      );
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
      _logInfo(
        'update_profile:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
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
      _logInfo('request_email_otp:start', data: {'newEmail': newEmail});
      final response = await _dio.post(
        ApiEndpoints.requestEmailChangeOtp,
        data: {'email': newEmail},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logInfo(
          'request_email_otp:success',
          data: {'statusCode': response.statusCode, 'body': response.data},
        );
        return _extractMessage(response.data) ?? 'OTP sent successfully.';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to request email OTP',
      );
    } on DioException catch (e) {
      _logError(
        'request_email_otp:failed',
        error: {
          'newEmail': newEmail,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
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
      _logInfo(
        'confirm_email_change:start',
        data: {'userId': userId, 'newEmail': newEmail, 'otpLength': otp.length},
      );
      final response = await _dio.post(
        ApiEndpoints.confirmEmailChange,
        data: {'email': newEmail, 'code': otp},
      );
      _logInfo(
        'confirm_email_change:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
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
      _logError(
        'confirm_email_change:failed',
        error: {
          'newEmail': newEmail,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
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

  @override
  Future<bool> sendVerificationOtp(String email) async {
    try {
      _logInfo('send_verification_otp:start', data: {'email': email});
      final response = await _dio.post(
        ApiEndpoints.requestEmailChangeOtp,
        data: {'email': email},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logInfo(
          'send_verification_otp:success',
          data: {'statusCode': response.statusCode, 'body': response.data},
        );
        return true;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to send verification OTP',
      );
    } on DioException catch (e) {
      _logError(
        'send_verification_otp:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
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
  Future<UserModel> verifyOtp(String email, String code) async {
    try {
      _logInfo(
        'verify_otp:start',
        data: {'email': email, 'codeLength': code.length},
      );
      final response = await _dio.post(
        ApiEndpoints.confirmEmailChange,
        data: {'email': email, 'code': code},
      );
      _logInfo(
        'verify_otp:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );
      if (response.statusCode == 200) {
        final data = response.data ?? <String, dynamic>{};
        final accessToken =
            data['access']?.toString() ??
            data['token']?.toString() ??
            data['access_token']?.toString() ??
            '';
        final refreshToken =
            data['refresh']?.toString() ??
            data['refresh_token']?.toString() ??
            '';

        if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
          await TokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          _logInfo('verify_otp:token_saved', data: {'type': 'access+refresh'});
        } else if (accessToken.isNotEmpty) {
          await TokenStorage.saveToken(accessToken);
          _logInfo('verify_otp:token_saved', data: {'type': 'access_only'});
        }

        final userData =
            (data['user'] as Map<String, dynamic>?) ??
            <String, dynamic>{
              'email': email,
              'nickname': email.split('@').first,
            };

        return UserModel(
          id: email,
          name:
              (userData['name'] ??
                      userData['nickname'] ??
                      email.split('@').first)
                  .toString(),
          email: (userData['email'] ?? email).toString(),
          password: '',
          token: accessToken,
          isVerified: true,
        );
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'OTP verification failed',
      );
    } on DioException catch (e) {
      _logError(
        'verify_otp:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
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

  @override
  Future<String> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _logInfo('change_password:start', data: {'email': email});
      final response = await _dio.post(
        ApiEndpoints.changePassword,
        data: {
          'email': email,
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
      _logInfo(
        'change_password:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractMessage(response.data) ??
            'Password changed successfully.';
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Password change failed',
      );
    } on DioException catch (e) {
      _logError(
        'change_password:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
        );
      }
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.changePassword),
        error: e.toString(),
      );
    }
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      _logInfo('reset_password:start', data: {'email': email});
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {'email': email, 'otp': otp, 'new_password': newPassword},
      );
      _logInfo(
        'reset_password:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractMessage(response.data) ?? 'Password reset successfully.';
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Password reset failed',
      );
    } on DioException catch (e) {
      _logError(
        'reset_password:failed',
        error: {
          'email': email,
          'statusCode': e.response?.statusCode,
          'message': e.message,
          'response': e.response?.data,
        },
      );
      final message = _extractMessage(e.response?.data);
      if (message != null && message.isNotEmpty) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: message,
          message: message,
        );
      }
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.resetPassword),
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

  void _logInfo(String message, {Object? data}) {
    developer.log(
      data == null
          ? message
          : '$message | ${_shorten(_sanitize(data).toString())}',
      name: _logName,
    );
  }

  void _logError(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      error == null
          ? message
          : '$message | ${_shorten(_sanitize(error).toString())}',
      name: _logName,
      error: error,
      stackTrace: stackTrace,
    );
  }

  dynamic _sanitize(dynamic value) {
    if (value is Map) {
      final output = <String, dynamic>{};
      value.forEach((key, val) {
        final normalizedKey = key.toString().toLowerCase();
        if (normalizedKey.contains('password') ||
            normalizedKey.contains('token') ||
            normalizedKey == 'id_token' ||
            normalizedKey == 'code') {
          output[key.toString()] = '***';
        } else {
          output[key.toString()] = _sanitize(val);
        }
      });
      return output;
    }
    if (value is List) {
      return value.map(_sanitize).toList();
    }
    return value;
  }

  String _shorten(String input) {
    const max = 600;
    if (input.length <= max) {
      return input;
    }
    return '${input.substring(0, max)}...';
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }

      final detail = data['detail']?.toString();
      if (detail != null && detail.isNotEmpty) {
        return detail;
      }
    }
    return _extractFirstText(data);
  }

  String? _extractFirstText(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? null : text;
    }

    if (value is List) {
      for (final item in value) {
        final found = _extractFirstText(item);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }
      return null;
    }

    if (value is Map) {
      for (final entryValue in value.values) {
        final found = _extractFirstText(entryValue);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }
      return null;
    }

    return value.toString();
  }
}

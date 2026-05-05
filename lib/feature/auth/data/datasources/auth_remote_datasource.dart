import 'dart:developer' as developer;

import 'package:flutter/services.dart';

import '../models/user_model.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> fetchProfile();
  Future<UserModel> signup(String nickname, String email, String password);
  Future<UserModel> logout(String email, String password);
  Future<UserModel> deleteAccount(String email, String password);
  Future<UserModel> googleSignIn();
  Future<UserModel> updateProfileInfo({
    required String userId,
    String? nickname,
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

  Future<UserModel> verifyOtp(String email, String otp);

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

  /// [serverClientId] is the OAuth 2.0 Web client ID for your backend.
  /// Provide it to enable returning an `idToken` on Android/iOS.
  AuthRemoteDataSourceImpl({required Dio dio, String? serverClientId})
    : _dio = dio,
      _googleSignIn = serverClientId != null
          ? GoogleSignIn(
              scopes: ['email', 'profile'],
              serverClientId: serverClientId,
            )
          : GoogleSignIn();

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

      // Parse user data from response - same as signup
      final responseMap = data;
      final parsedUser = UserModel.fromJson(responseMap);

      return parsedUser.copyWith(
        email: parsedUser.email.isNotEmpty ? parsedUser.email : email,
        password: password,
        token: accessToken,
        isVerified:
            parsedUser.isVerified ||
            responseMap['is_verified'] == true ||
            responseMap['isVerified'] == true,
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
  Future<UserModel> fetchProfile() async {
    try {
      _logInfo('fetch_profile:start');
      final response = await _dio.get(ApiEndpoints.updateProfile);
      _logInfo(
        'fetch_profile:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200) {
        return _resolveUserFromAuthResponse(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to load the current profile information.',
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
  Future<UserModel> signup(
    String nickname,
    String email,
    String password,
  ) async {
    try {
      _logInfo('signup:start', data: {'email': email, 'nickname': nickname});
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: UserModel.signupRequestBody(
          nickname: nickname,
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
          error:
              'Unable to complete sign-up. The server returned status code ${response.statusCode}.',
        );
      }

      final responseMap =
          (response.data as Map<String, dynamic>?) ?? <String, dynamic>{};
      final parsedUser = UserModel.fromJson(responseMap);

      return parsedUser.copyWith(
        username: parsedUser.username.isNotEmpty
            ? parsedUser.username
            : nickname,
        email: parsedUser.email.isNotEmpty ? parsedUser.email : email,
        password: password,
        token: parsedUser.token,
        isVerified:
            parsedUser.isVerified ||
            responseMap['is_verified'] == true ||
            responseMap['isVerified'] == true,
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
        username: 'Logged Out',
        nickname: 'Logged Out',
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
        data: {
          ApiEndpoints.keyEmail: email,
          ApiEndpoints.keyPassword: password,
        },
      );
      _logInfo(
        'delete_account:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      final statusCode = response.statusCode;
      final responseBody = response.data;

      if (statusCode == 204 ||
          (statusCode == 200 && _isDeleteAccountSuccess(responseBody))) {
        await TokenStorage.clearTokens();
        return UserModel(
          username: 'Deleted User',
          nickname: 'Deleted User',
          email: email,
          password: '',
          token: '',
        );
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error:
            _extractDeleteAccountFailureMessage(responseBody) ??
            _extractMessage(responseBody) ??
            'Unable to delete the account.',
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

  bool _isDeleteAccountSuccess(dynamic data) {
    if (data == null) {
      return true;
    }

    if (data is! Map<String, dynamic>) {
      final text = data.toString().toLowerCase();
      return text.contains('deleted') || text.contains('success');
    }

    final explicitSuccess = _readBoolLike(data['success']);
    if (explicitSuccess != null) {
      return explicitSuccess;
    }

    final explicitOk = _readBoolLike(data['ok']);
    if (explicitOk != null) {
      return explicitOk;
    }

    final statusText = data['status']?.toString().toLowerCase().trim();
    if (statusText != null && statusText.isNotEmpty) {
      if (statusText == 'success' || statusText == 'ok') {
        return true;
      }
      if (statusText == 'failed' ||
          statusText == 'error' ||
          statusText == 'failure') {
        return false;
      }
    }

    final hasErrors = _extractFirstText(data['errors'])?.isNotEmpty == true;
    if (hasErrors) {
      return false;
    }

    final hasError = _extractFirstText(data['error'])?.isNotEmpty == true;
    if (hasError) {
      return false;
    }

    final message = _extractMessage(data)?.toLowerCase();
    if (message != null && message.isNotEmpty) {
      if (message.contains('deleted') ||
          message.contains('removed') ||
          message.contains('success')) {
        return true;
      }
      if (message.contains('fail') ||
          message.contains('invalid') ||
          message.contains('error') ||
          message.contains('unable') ||
          message.contains('not allowed') ||
          message.contains('incorrect')) {
        return false;
      }
    }

    return true;
  }

  String? _extractDeleteAccountFailureMessage(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final explicitMessage = _extractMessage(data);
    if (explicitMessage != null && explicitMessage.isNotEmpty) {
      return explicitMessage;
    }

    return _extractFirstText(data['errors']) ??
        _extractFirstText(data['error']);
  }

  bool? _readBoolLike(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return null;
  }

  @override
  Future<UserModel> googleSignIn() async {
    try {
      _logInfo('google_sign_in:start');
      final account = await _googleSignIn.signIn();
      if (account == null) {
        _logError('google_sign_in:cancelled');
        throw Exception('Google Sign-In was cancelled by the user.');
      }
      final auth = await account.authentication;
      if (auth.idToken == null || auth.idToken!.isEmpty) {
        _logError(
          'google_sign_in:id_token_missing',
          error:
              'idToken is missing. Configure GoogleSignIn with serverClientId so the provider can return an idToken.',
        );
        throw DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.googleLogin),
          error:
              'Google Sign-In could not be completed because the id_token is missing. Provide the OAuth Web client ID as serverClientId when creating GoogleSignIn so the provider can return an id_token.',
        );
      }

      final response = await _dio.post(
        ApiEndpoints.googleLogin,
        data: {ApiEndpoints.keyIdToken: auth.idToken},
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
          error: 'Google Sign-In could not be completed.',
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
          error: 'Google Sign-In is not available in the backend yet.',
          message: 'Google Sign-In is not available in the backend yet.',
        );
      }
      rethrow;
    } on PlatformException catch (e) {
      // Handle Google plugin errors (e.g., ApiException: 10 from Android)
      _logError(
        'google_sign_in:platform_error',
        error: {'code': e.code, 'message': e.message, 'details': e.details},
      );
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.googleLogin),
        error: e.message ?? e.code,
      );
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
    String? nickname,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  }) async {
    try {
      _logInfo(
        'update_profile:start',
        data: {
          'userId': userId,
          'nickname': nickname,
          'birthDate': birthDate.toIso8601String(),
          'gender': gender,
          'phoneNumber': phoneNumber,
        },
      );
      final response = await _dio.patch(
        ApiEndpoints.updateProfile,
        data: {
          'user': {
            'nickname': nickname,
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
          username:
              (userMap['username'] ??
                      userMap['nickname'] ??
                      userMap['name'] ??
                      '')
                  .toString(),
          nickname: userMap['nickname']?.toString() ?? nickname,
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
        error: 'Unable to update the profile information.',
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
        data: {ApiEndpoints.keyEmail: newEmail},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logInfo(
          'request_email_otp:success',
          data: {'statusCode': response.statusCode, 'body': response.data},
        );
        return _extractMessage(response.data) ??
            'Verification code sent successfully.';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to request a verification code for this email address.',
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
              'The backend does not currently support sending an OTP for email change. This endpoint only resends verification codes for the current account email.',
          message:
              'The backend does not currently support sending an OTP for email change. This endpoint only resends verification codes for the current account email.',
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
      final requestData = {
        ApiEndpoints.keyEmail: newEmail,
        ApiEndpoints.keyOtp: otp,
      };
      _logInfo('confirm_email_change:request', data: requestData);
      final response = await _dio.post(
        ApiEndpoints.confirmEmailChange,
        data: requestData,
      );
      _logInfo(
        'confirm_email_change:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );
      if (response.statusCode == 200) {
        final accessToken = await TokenStorage.getAccessToken();
        return UserModel(
          username: userId,
          nickname: userId,
          email: newEmail,
          password: '',
          token: accessToken ?? '',
        );
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to confirm the email change.',
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
              'The backend does not currently support confirming a new email address with this flow.',
          message:
              'The backend does not currently support confirming a new email address with this flow.',
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
        data: {ApiEndpoints.keyEmail: email},
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
        error: 'Unable to send the verification code.',
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
        requestOptions: RequestOptions(
          path: ApiEndpoints.requestEmailChangeOtp,
        ),
        error: e.toString(),
      );
    }
  }

  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    try {
      _logInfo(
        'verify_otp:start',
        data: {'email': email, 'otpLength': otp.length},
      );
      final requestData = {
        ApiEndpoints.keyEmail: email,
        'code': otp,
        ApiEndpoints.keyOtp: otp,
      };
      _logInfo('verify_otp:request', data: requestData);
      final response = await _dio.post(
        ApiEndpoints.confirmEmailChange,
        data: requestData,
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
          username:
              (userData['username'] ??
                      userData['nickname'] ??
                      userData['name'] ??
                      email.split('@').first)
                  .toString(),
          nickname: userData['nickname']?.toString() ?? email.split('@').first,
          email: (userData['email'] ?? email).toString(),
          password: '',
          token: accessToken,
          isVerified: true,
        );
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to verify the one-time code.',
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
          ApiEndpoints.keyEmail: email,
          ApiEndpoints.keyCurrentPassword: currentPassword,
          ApiEndpoints.keyNewPassword: newPassword,
        },
      );
      _logInfo(
        'change_password:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractMessage(response.data) ??
            'Password updated successfully.';
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to change the password.',
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
        data: {
          ApiEndpoints.keyEmail: email,
          ApiEndpoints.keyOtp: otp,
          ApiEndpoints.keyNewPassword: newPassword,
        },
      );
      _logInfo(
        'reset_password:response',
        data: {'statusCode': response.statusCode, 'body': response.data},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractMessage(response.data) ??
            'Password reset completed successfully.';
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unable to reset the password.',
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
    final dataMap = responseData is Map<String, dynamic>
        ? responseData
        : <String, dynamic>{};
    final rootData = (dataMap['data'] as Map<String, dynamic>?) ?? dataMap;
    final userJson =
        (rootData['user'] as Map<String, dynamic>?) ??
        Map<String, dynamic>.from(rootData);

    if ((userJson['token'] == null || '${userJson['token']}'.isEmpty) &&
        (rootData['token'] != null || dataMap['token'] != null)) {
      userJson['token'] = rootData['token'] ?? dataMap['token'];
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
            normalizedKey == 'code' ||
            normalizedKey == 'otp') {
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
      if (message != null &&
          message.isNotEmpty &&
          !_isGenericMessage(message)) {
        return message;
      }

      final detail = data['detail']?.toString();
      if (detail != null && detail.isNotEmpty && !_isGenericMessage(detail)) {
        return detail;
      }

      // Prefer nested field-level messages like:
      // {"email": "User is already verified"} or
      // {"user": {"email": ["user with this email already exists."]}}
      final fieldMessage = _extractFieldMessage(data);
      if (fieldMessage != null && fieldMessage.isNotEmpty) {
        return fieldMessage;
      }

      if (message != null && message.isNotEmpty) {
        return message;
      }

      if (detail != null && detail.isNotEmpty) {
        return detail;
      }
    }
    return _extractFirstText(data);
  }

  String? _extractFieldMessage(Map<String, dynamic> data) {
    const reservedKeys = {'message', 'detail', 'error', 'status', 'code'};

    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      if (reservedKeys.contains(key)) {
        continue;
      }
      final found = _extractFirstText(entry.value);
      if (found != null && found.isNotEmpty) {
        return found;
      }
    }

    final errorValue = data['error'];
    if (errorValue is Map<String, dynamic>) {
      final found = _extractFirstText(errorValue['message'] ?? errorValue);
      if (found != null && found.isNotEmpty) {
        return found;
      }
    }

    return null;
  }

  bool _isGenericMessage(String message) {
    final normalized = message.trim().toLowerCase();
    return normalized == 'invalid request. please check your input.' ||
        normalized == 'invalid request' ||
        normalized == 'bad request';
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

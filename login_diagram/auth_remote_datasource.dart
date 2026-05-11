// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:your_app/core/services/dio_client.dart';
// import 'package:your_app/core/error/exceptions.dart';
// import 'package:your_app/feature/auth/data/models/user_model.dart';

// /// 🔌 AuthRemoteDataSource - تعريف المتعاقد
// abstract class AuthRemoteDataSource {
//   /// تسجيل الدخول عبر البريد الإلكتروني وكلمة المرور
//   Future<UserModel> login({
//     required String email,
//     required String password,
//   });

//   /// التسجيل الجديد
//   Future<UserModel> signup({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   });

//   /// إرسال OTP للتحقق
//   Future<void> sendOtp({required String email});

//   /// التحقق من OTP
//   Future<UserModel> verifyOtp({
//     required String email,
//     required String otp,
//   });

//   /// إكمال الملف الشخصي
//   Future<UserModel> completeProfile({
//     required String userId,
//     required String dateOfBirth,
//     required String gender,
//     required String phoneNumber,
//   });

//   /// تسجيل الخروج
//   Future<void> logout();
// }

// /// التنفيذ الفعلي للـ AuthRemoteDataSource
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final DioClient _dioClient;

//   AuthRemoteDataSourceImpl(this._dioClient);

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🔐 LOGIN ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// 🟢 خطوة 5: استدعاء API - Login with email and password
//   @override
//   Future<UserModel> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       _log('Sending login request for: $email');

//       // 🔵 بناء الطلب
//       final requestBody = {
//         'email': email,
//         'password': password,
//       };

//       _log('Request body: ${requestBody.toString()}');

//       // 📤 إرسال POST request إلى الخادم
//       final response = await _dioClient.post(
//         '/api/auth/login',
//         data: requestBody,
//       );

//       _log('Login response status: ${response.statusCode}');

//       // التحقق من الاستجابة
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = response.data;

//         if (data == null) {
//           _log('ERROR: Response data is null');
//           throw ServerException('لم تحتوي الاستجابة على بيانات');
//         }

//         _log('Response data type: ${data.runtimeType}');
//         _log('Response keys: ${(data as Map).keys}');

//         // استخراج بيانات المستخدم من الاستجابة
//         // قد تكون الاستجابة بصيغة:
//         // {user: {...}, token: "..."} أو مباشرة {..., token: "..."}
//         final userData = data['user'] ?? data;

//         if (userData is! Map<String, dynamic>) {
//           _log('ERROR: User data is not a Map');
//           throw ServerException('صيغة الاستجابة غير صحيحة');
//         }

//         _log('Converting response to UserModel');

//         // تحويل الاستجابة إلى UserModel
//         final userModel = UserModel.fromJson(userData);

//         _log('Login successful: ${userModel.email}');
//         _log('Token length: ${userModel.token?.length ?? 0}');

//         return userModel;
//       } else {
//         // استجابة بحالة خطأ
//         _log('ERROR: Unexpected status code: ${response.statusCode}');
//         _extractAndThrowError(response);
//       }
//     } on DioException catch (e) {
//       // معالجة أخطاء Dio (شبكة، timeout، إلخ)
//       _log('Dio error: ${e.type}');
//       _handleDioException(e);
//     } catch (e) {
//       // خطأ غير متوقع
//       _log('Unexpected error: $e');
//       throw ServerException('خطأ غير متوقع: $e');
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📝 SIGNUP ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<UserModel> signup({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     try {
//       _log('Sending signup request for: $email');

//       final requestBody = {
//         'email': email,
//         'password': password,
//         'password_confirmation': confirmPassword,
//       };

//       final response = await _dioClient.post(
//         '/api/auth/signup',
//         data: requestBody,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final userData = response.data['user'] ?? response.data;
//         final userModel = UserModel.fromJson(userData);
//         _log('Signup successful');
//         return userModel;
//       } else {
//         _log('Signup failed with status: ${response.statusCode}');
//         _extractAndThrowError(response);
//       }
//     } on DioException catch (e) {
//       _log('Dio error in signup: ${e.type}');
//       _handleDioException(e);
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📨 SEND OTP ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<void> sendOtp({required String email}) async {
//     try {
//       _log('Sending OTP to: $email');

//       final response = await _dioClient.post(
//         '/api/auth/send-otp',
//         data: {'email': email},
//       );

//       if (response.statusCode != 200 && response.statusCode != 201) {
//         _log('Send OTP failed with status: ${response.statusCode}');
//         _extractAndThrowError(response);
//       }

//       _log('OTP sent successfully to $email');
//     } on DioException catch (e) {
//       _handleDioException(e);
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // ✅ VERIFY OTP ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<UserModel> verifyOtp({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       _log('Verifying OTP for: $email');

//       final response = await _dioClient.post(
//         '/api/auth/verify-otp',
//         data: {
//           'email': email,
//           'otp': otp,
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final userData = response.data['user'] ?? response.data;
//         final userModel = UserModel.fromJson(userData);
//         _log('OTP verification successful');
//         return userModel;
//       } else {
//         _log('OTP verification failed with status: ${response.statusCode}');
//         _extractAndThrowError(response);
//       }
//     } on DioException catch (e) {
//       _handleDioException(e);
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 👤 COMPLETE PROFILE ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<UserModel> completeProfile({
//     required String userId,
//     required String dateOfBirth,
//     required String gender,
//     required String phoneNumber,
//   }) async {
//     try {
//       _log('Completing profile for user: $userId');

//       final response = await _dioClient.post(
//         '/api/auth/complete-profile',
//         data: {
//           'user_id': userId,
//           'date_of_birth': dateOfBirth,
//           'gender': gender,
//           'phone_number': phoneNumber,
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final userData = response.data['user'] ?? response.data;
//         final userModel = UserModel.fromJson(userData);
//         _log('Profile completed successfully');
//         return userModel;
//       } else {
//         _log('Complete profile failed with status: ${response.statusCode}');
//         _extractAndThrowError(response);
//       }
//     } on DioException catch (e) {
//       _handleDioException(e);
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🚪 LOGOUT ENDPOINT
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<void> logout() async {
//     try {
//       _log('Sending logout request');

//       final response = await _dioClient.post(
//         '/api/auth/logout',
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _log('Logout successful');
//       } else {
//         _log('Logout failed with status: ${response.statusCode}');
//         // لا نرفع خطأ في logout لأنه يجب مسح التوكن على أي حال
//       }
//     } on DioException catch (e) {
//       _log('Dio error in logout: ${e.type}');
//       // لا نرفع خطأ في logout
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🛠️ HELPER METHODS
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// استخراج رسالة الخطأ من استجابة الخادم ورفع استثناء
//   void _extractAndThrowError(Response response) {
//     String errorMessage = 'خطأ في الخادم';

//     try {
//       if (response.data is Map<String, dynamic>) {
//         final data = response.data as Map<String, dynamic>;
        
//         // محاولة استخراج رسالة الخطأ من عدة أماكن محتملة
//         errorMessage = 
//             data['message'] ?? 
//             data['error'] ?? 
//             data['detail'] ?? 
//             (data['errors'] is Map 
//               ? (data['errors'] as Map).values.first.toString()
//               : 'خطأ غير معروف');
//       }
//     } catch (e) {
//       _log('Error parsing error response: $e');
//     }

//     _log('Server error: $errorMessage');
//     throw ServerException(errorMessage);
//   }

//   /// معالج أخطاء Dio
//   /// Handles Dio exceptions and converts them to appropriate exceptions
//   void _handleDioException(DioException e) {
//     String errorMessage = 'خطأ في الاتصال';

//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//         errorMessage = 'انتهت مهلة الاتصال. يرجى المحاولة لاحقاً';
//         _log('Connection timeout');
//         break;
//       case DioExceptionType.sendTimeout:
//         errorMessage = 'انتهت مهلة الإرسال. يرجى المحاولة لاحقاً';
//         _log('Send timeout');
//         break;
//       case DioExceptionType.receiveTimeout:
//         errorMessage = 'انتهت مهلة الاستقبال. يرجى المحاولة لاحقاً';
//         _log('Receive timeout');
//         break;
//       case DioExceptionType.badResponse:
//         // محاولة استخراج رسالة من الاستجابة
//         if (e.response != null) {
//           _extractAndThrowError(e.response!);
//         } else {
//           _log('Bad response without details');
//           throw ServerException(errorMessage);
//         }
//         return;
//       case DioExceptionType.cancel:
//         errorMessage = 'تم إلغاء الطلب';
//         _log('Request cancelled');
//         break;
//       case DioExceptionType.connectionError:
//         errorMessage = 'خطأ في الاتصال. تحقق من الاتصال بالإنترنت';
//         _log('Connection error');
//         break;
//       case DioExceptionType.unknown:
//         errorMessage = 'خطأ غير متوقع: ${e.message}';
//         _log('Unknown error: ${e.message}');
//         break;
//     }

//     throw NetworkException(errorMessage);
//   }

//   /// تسجيل بسيط للتصحيح
//   void _log(String message) {
//     debugPrint('[AuthRemoteDataSource] $message');
//   }
// }

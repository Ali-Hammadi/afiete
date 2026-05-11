// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:your_app/core/error/exceptions.dart';
// import 'package:your_app/core/error/failure.dart';
// import 'package:your_app/core/utils/token_storage.dart';
// import 'package:your_app/feature/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:your_app/feature/auth/data/models/user_model.dart';
// import 'package:your_app/feature/auth/domain/entities/auth_user_entity.dart';
// import 'package:your_app/feature/auth/domain/repositories/auth_repository.dart';

// /// 🗂️ AuthRepository Implementation - طبقة البيانات
// /// تتولى التواصل مع DataSource وإدارة التخزين المؤقت والتوكن
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource _remoteDataSource;
//   final TokenStorage _tokenStorage;

//   AuthRepositoryImpl({
//     required AuthRemoteDataSource remoteDataSource,
//     required TokenStorage tokenStorage,
//   })  : _remoteDataSource = remoteDataSource,
//         _tokenStorage = tokenStorage;

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🔐 LOGIN
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// تسجيل الدخول - Login with email and password
//   ///
//   /// يقوم بـ:
//   /// 1. استدعاء API عبر RemoteDataSource
//   /// 2. حفظ التوكن في TokenStorage
//   /// 3. تحويل النموذج إلى Entity والعودة
//   /// 4. معالجة الأخطاء وتحويلها إلى Failures
//   @override
//   Future<Either<Failure, UserAuthEntity>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       _log('login() called with email: $email');

//       // 🟡 خطوة 4: استدعاء remote datasource
//       final userModel = await _remoteDataSource.login(
//         email: email,
//         password: password,
//       );

//       _log('Received user model: ${userModel.email}');

//       // 💾 خطوة حفظ التوكن - يجب أن يكون موجوداً
//       if (userModel.token != null && userModel.token!.isNotEmpty) {
//         _log('Saving token to TokenStorage');
//         try {
//           await _tokenStorage.saveToken(userModel.token!);
//           _log('Token saved successfully: ${userModel.token!.substring(0, 20)}...');
//         } catch (e) {
//           _log('ERROR: Failed to save token: $e');
//           return Left(
//             CacheFailure('فشل حفظ التوكن: $e'),
//           );
//         }
//       } else {
//         _log('ERROR: No token in response');
//         return Left(
//           ServerFailure('لم يتم استقبال توكن من الخادم'),
//         );
//       }

//       // تحويل إلى entity والعودة
//       _log('Converting UserModel to UserAuthEntity');
//       return Right(userModel.toEntity());
//     } on ServerException catch (e) {
//       _log('ServerException in login: ${e.message}');
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       _log('NetworkException in login: ${e.message}');
//       return Left(NetworkFailure(e.message));
//     } on CacheException catch (e) {
//       _log('CacheException in login: ${e.message}');
//       return Left(CacheFailure(e.message));
//     } catch (e) {
//       _log('Unexpected error in login: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📝 SIGNUP
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// تسجيل حساب جديد
//   @override
//   Future<Either<Failure, UserAuthEntity>> signup({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     try {
//       _log('signup() called with email: $email');

//       final userModel = await _remoteDataSource.signup(
//         email: email,
//         password: password,
//         confirmPassword: confirmPassword,
//       );

//       // لا نحفظ التوكن هنا لأن الحساب قد لا يكون مفعل بعد
//       _log('Signup successful');
//       return Right(userModel.toEntity());
//     } on ServerException catch (e) {
//       _log('ServerException in signup: ${e.message}');
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       _log('NetworkException in signup: ${e.message}');
//       return Left(NetworkFailure(e.message));
//     } catch (e) {
//       _log('Unexpected error in signup: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📨 SEND OTP
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// إرسال OTP
//   @override
//   Future<Either<Failure, void>> sendOtp({required String email}) async {
//     try {
//       _log('sendOtp() called for email: $email');

//       await _remoteDataSource.sendOtp(email: email);

//       _log('OTP sent successfully');
//       return const Right(null);
//     } on ServerException catch (e) {
//       _log('ServerException in sendOtp: ${e.message}');
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       _log('NetworkException in sendOtp: ${e.message}');
//       return Left(NetworkFailure(e.message));
//     } catch (e) {
//       _log('Unexpected error in sendOtp: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // ✅ VERIFY OTP
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// التحقق من OTP
//   @override
//   Future<Either<Failure, UserAuthEntity>> verifyOtp({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       _log('verifyOtp() called for email: $email');

//       final userModel = await _remoteDataSource.verifyOtp(
//         email: email,
//         otp: otp,
//       );

//       // 💾 حفظ التوكن بعد التحقق من OTP
//       if (userModel.token != null && userModel.token!.isNotEmpty) {
//         _log('Saving token after OTP verification');
//         try {
//           await _tokenStorage.saveToken(userModel.token!);
//           _log('Token saved after OTP verification');
//         } catch (e) {
//           _log('ERROR: Failed to save token after OTP: $e');
//           return Left(CacheFailure('فشل حفظ التوكن: $e'));
//         }
//       }

//       _log('OTP verification successful');
//       return Right(userModel.toEntity());
//     } on ServerException catch (e) {
//       _log('ServerException in verifyOtp: ${e.message}');
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       _log('NetworkException in verifyOtp: ${e.message}');
//       return Left(NetworkFailure(e.message));
//     } catch (e) {
//       _log('Unexpected error in verifyOtp: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 👤 COMPLETE PROFILE
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// إكمال بيانات الملف الشخصي
//   @override
//   Future<Either<Failure, UserAuthEntity>> completeProfile({
//     required String userId,
//     required String dateOfBirth,
//     required String gender,
//     required String phoneNumber,
//   }) async {
//     try {
//       _log('completeProfile() called for userId: $userId');

//       final userModel = await _remoteDataSource.completeProfile(
//         userId: userId,
//         dateOfBirth: dateOfBirth,
//         gender: gender,
//         phoneNumber: phoneNumber,
//       );

//       _log('Profile completed successfully');
//       return Right(userModel.toEntity());
//     } on ServerException catch (e) {
//       _log('ServerException in completeProfile: ${e.message}');
//       return Left(ServerFailure(e.message));
//     } on NetworkException catch (e) {
//       _log('NetworkException in completeProfile: ${e.message}');
//       return Left(NetworkFailure(e.message));
//     } catch (e) {
//       _log('Unexpected error in completeProfile: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🚪 LOGOUT
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// تسجيل الخروج
//   @override
//   Future<Either<Failure, void>> logout() async {
//     try {
//       _log('logout() called');

//       // محاولة تسجيل الخروج من الخادم (اختياري)
//       try {
//         await _remoteDataSource.logout();
//         _log('Logout from server successful');
//       } catch (e) {
//         // لا نوقف عملية الخروج إذا فشل الطلب
//         _log('Server logout failed, but continuing with local logout: $e');
//       }

//       // 💾 مسح التوكن من التخزين المحلي - هذا يجب أن يحدث دائماً
//       try {
//         await _tokenStorage.clearToken();
//         _log('Token cleared from TokenStorage');
//       } catch (e) {
//         _log('ERROR: Failed to clear token: $e');
//         return Left(CacheFailure('فشل مسح التوكن: $e'));
//       }

//       _log('Logout successful');
//       return const Right(null);
//     } catch (e) {
//       _log('Unexpected error in logout: $e');
//       return Left(ServerFailure('Unknown error: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🔍 GET SAVED TOKEN
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// الحصول على التوكن المحفوظ (للتحقق من جلسة الدخول)
//   @override
//   Future<Either<Failure, String?>> getSavedToken() async {
//     try {
//       _log('getSavedToken() called');

//       final token = await _tokenStorage.getToken();

//       if (token == null || token.isEmpty) {
//         _log('No token found in storage');
//         return const Right(null);
//       }

//       _log('Token retrieved: ${token.substring(0, 20)}...');
//       return Right(token);
//     } catch (e) {
//       _log('Error getting saved token: $e');
//       return Left(CacheFailure('فشل استرجاع التوكن: $e'));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🛠️ HELPER METHODS
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// تسجيل بسيط للتصحيح
//   void _log(String message) {
//     debugPrint('[AuthRepositoryImpl] $message');
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:your_app/core/error/failure.dart';
// import 'package:your_app/feature/auth/domain/entities/auth_user_entity.dart';
// import 'package:your_app/feature/auth/domain/usecase/login_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/signup_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/logout_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/verify_signup_otp_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/complete_profile_usecase.dart';
// // ... import other usecases

// part 'auth_state.dart';

// /// 🎮 AuthCubit - مدير حالة المصادقة
// /// Handles all authentication operations and state management
// class AuthCubit extends Cubit<AuthState> {
//   // Usecases
//   final LoginUsecase _loginUsecase;
//   final SignupUsecase _signupUsecase;
//   final LogoutUsecase _logoutUsecase;
//   final VerifySignupOtpUsecase _verifySignupOtpUsecase;
//   final CompleteProfileUsecase _completeProfileUsecase;
//   // ... other usecases

//   AuthCubit({
//     required LoginUsecase loginUsecase,
//     required SignupUsecase signupUsecase,
//     required LogoutUsecase logoutUsecase,
//     required VerifySignupOtpUsecase verifySignupOtpUsecase,
//     required CompleteProfileUsecase completeProfileUsecase,
//     // ... other usecases
//   })  : _loginUsecase = loginUsecase,
//         _signupUsecase = signupUsecase,
//         _logoutUsecase = logoutUsecase,
//         _verifySignupOtpUsecase = verifySignupOtpUsecase,
//         _completeProfileUsecase = completeProfileUsecase,
//         super(const AuthInitial());

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🔐 LOGIN OPERATION
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// 🔴 خطوة 2: تسجيل الدخول - Login with email and password
//   /// 
//   /// Flow:
//   /// 1. Validate inputs
//   /// 2. Emit AuthLoading
//   /// 3. Call loginUsecase
//   /// 4. Handle result with fold pattern
//   /// 5. Emit appropriate state (AuthLoaded, ProfileIncomplete, or AuthError)
//   Future<void> login({
//     required String email,
//     required String password,
//   }) async {
//     _log('Starting login for email: $email');

//     // Validation
//     if (email.isEmpty || password.isEmpty) {
//       _log('Login validation failed: empty email or password');
//       emit(const AuthError('البريد الإلكتروني وكلمة المرور مطلوبان'));
//       return;
//     }

//     if (!_isValidEmail(email)) {
//       _log('Login validation failed: invalid email format');
//       emit(const AuthError('البريد الإلكتروني غير صحيح'));
//       return;
//     }

//     // Emit loading state
//     emit(const AuthLoading());

//     try {
//       // 🟡 خطوة 3: استدعاء usecase
//       final result = await _loginUsecase(
//         email: email,
//         password: password,
//       );

//       // 🎯 fold pattern: معالجة النتيجة (خطأ أو نجاح)
//       result.fold(
//         (failure) {
//           // ❌ فشل العملية
//           _handleLoginFailure(failure);
//         },
//         (user) {
//           // ✅ نجح الدخول
//           _handleLoginSuccess(user);
//         },
//       );
//     } catch (e) {
//       // خطأ غير متوقع
//       _log('Unexpected error in login: $e');
//       emit(AuthError('خطأ غير متوقع: $e'));
//     }
//   }

//   /// ❌ معالج فشل تسجيل الدخول
//   /// Handles login failures and emits appropriate error state
//   void _handleLoginFailure(Failure failure) {
//     _log('Login failed with failure: $failure');

//     String errorMessage = 'فشل تسجيل الدخول';

//     // تصنيف الأخطاء والعثور على الرسالة المناسبة
//     if (failure is ServerFailure) {
//       // خطأ من الخادم
//       if (_isInactiveAccountError(failure.message)) {
//         errorMessage = 'الحساب غير نشط. يرجى تفعيله عبر البريد الإلكتروني';
//       } else if (failure.message.contains('Invalid credentials') ||
//           failure.message.contains('invalid') ||
//           failure.message.contains('not found')) {
//         errorMessage = 'بيانات الدخول غير صحيحة';
//       } else if (failure.message.contains('account locked')) {
//         errorMessage = 'الحساب مقفول. يرجى التواصل مع الدعم';
//       } else {
//         errorMessage = failure.message;
//       }
//     } else if (failure is NetworkFailure) {
//       // خطأ في الشبكة
//       errorMessage = 'خطأ في الاتصال. تحقق من الاتصال بالإنترنت';
//     } else if (failure is CacheFailure) {
//       // خطأ في التخزين المؤقت
//       errorMessage = 'خطأ في القراءة من الذاكرة';
//     } else {
//       errorMessage = failure.message;
//     }

//     emit(AuthError(errorMessage));
//   }

//   /// ✅ معالج نجاح تسجيل الدخول
//   /// Handles successful login and emits appropriate state
//   void _handleLoginSuccess(UserAuthEntity user) {
//     _log('Login successful for user: ${user.email}');

//     // تحقق من وجود التوكن
//     if (user.token == null || user.token!.isEmpty) {
//       _log('ERROR: Token is missing from server response');
//       emit(const AuthError('لم يتم استقبال توكن من الخادم'));
//       return;
//     }

//     _log('Token received and should be cached: ${user.token!.substring(0, 20)}...');

//     // تحقق من اكتمال بيانات الملف الشخصي
//     if (user.isProfileComplete) {
//       // ✅ الملف كامل - دخول مباشر للصفحة الرئيسية
//       _log('Profile is complete, emitting AuthLoaded');
//       emit(AuthLoaded(user));
//     } else {
//       // ⚠️ الملف ناقص - إعادة توجيه لإكمال الملف
//       _log('Profile is incomplete, emitting ProfileIncomplete');
//       emit(ProfileIncomplete(user));
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🔍 HELPER METHODS
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// فحص ما إذا كان البريد الإلكتروني صحيحاً
//   /// Basic email validation
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );
//     return emailRegex.hasMatch(email);
//   }

//   /// فحص خاص للحسابات غير النشطة
//   /// Detects if the error is due to inactive account
//   bool _isInactiveAccountError(String message) {
//     final inactiveKeywords = [
//       'inactive',
//       'not activated',
//       'pending activation',
//       'verify email',
//       'unverified',
//       'not verified',
//       'email not confirmed',
//     ];
//     final lowerMessage = message.toLowerCase();
//     return inactiveKeywords.any(
//       (keyword) => lowerMessage.contains(keyword),
//     );
//   }

//   /// تسجيل بسيط للتصحيح
//   /// Simple debug logging
//   void _log(String message) {
//     debugPrint('[AuthCubit] $message');
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📝 OTHER AUTH OPERATIONS (STUBS)
//   // ═══════════════════════════════════════════════════════════════════════════

//   /// تسجيل حساب جديد
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     // Implementation similar to login
//     _log('Signup called');
//     emit(const AuthLoading());
    
//     // TODO: Implement signup logic
//   }

//   /// تسجيل الخروج
//   Future<void> logout() async {
//     _log('Logout called');
//     emit(const AuthLoading());
    
//     // TODO: Implement logout logic
//   }

//   /// التحقق من OTP بعد التسجيل
//   Future<void> verifySignupOtp({
//     required String email,
//     required String otp,
//   }) async {
//     _log('Verify signup OTP called for $email');
//     emit(const OtpLoading());
    
//     // TODO: Implement OTP verification logic
//   }

//   /// إكمال بيانات الملف الشخصي
//   Future<void> completeProfile({
//     required String dateOfBirth,
//     required String gender,
//     required String phoneNumber,
//   }) async {
//     _log('Complete profile called');
//     emit(const AuthLoading());
    
//     // TODO: Implement complete profile logic
//   }
// }

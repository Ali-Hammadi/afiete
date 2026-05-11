// import 'package:dartz/dartz.dart';
// import 'package:your_app/core/error/failure.dart';
// import 'package:your_app/feature/auth/domain/entities/auth_user_entity.dart';
// import 'package:your_app/feature/auth/domain/repositories/auth_repository.dart';

// /// 🔵 LogIن Usecase - طبقة المجال
// /// 
// /// المسؤوليات:
// /// 1. تعريف منطق تسجيل الدخول
// /// 2. التحقق من صحة المدخلات
// /// 3. استدعاء Repository
// /// 4. إرجاع Either<Failure, UserAuthEntity>
// class LoginUsecase {
//   final AuthRepository _repository;

//   LoginUsecase(this._repository);

//   /// استدعاء العملية: call(email, password)
//   /// 
//   /// يمكن استخدامها بطريقتين:
//   /// 1. loginUsecase(email: "...", password: "...")
//   /// 2. loginUsecase.call(email: "...", password: "...")
//   Future<Either<Failure, UserAuthEntity>> call({
//     required String email,
//     required String password,
//   }) async {
//     // يمكن إضافة تحقق إضافي هنا إن لزم الأمر
//     // مثلاً: التحقق من صيغة البريد الإلكتروني
    
//     return await _repository.login(
//       email: email,
//       password: password,
//     );
//   }

//   /// بديل: يمكن جعل الـ Usecase callable بشكل مباشر
//   /// Future<Either<Failure, UserAuthEntity>> call({
//   ///   required String email,
//   ///   required String password,
//   /// }) => this.call(email: email, password: password);
// }

// /// 🔷 SignupUsecase - التسجيل الجديد
// class SignupUsecase {
//   final AuthRepository _repository;

//   SignupUsecase(this._repository);

//   Future<Either<Failure, UserAuthEntity>> call({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     // التحقق من تطابق كلمات المرور
//     if (password != confirmPassword) {
//       return Left(
//         ValidationFailure('كلمات المرور غير متطابقة'),
//       );
//     }

//     // التحقق من قوة كلمة المرور
//     if (password.length < 8) {
//       return Left(
//         ValidationFailure('كلمة المرور يجب أن تكون 8 أحرف على الأقل'),
//       );
//     }

//     return await _repository.signup(
//       email: email,
//       password: password,
//       confirmPassword: confirmPassword,
//     );
//   }
// }

// /// 🔶 SendOtpUsecase - إرسال OTP
// class SendOtpUsecase {
//   final AuthRepository _repository;

//   SendOtpUsecase(this._repository);

//   Future<Either<Failure, void>> call({required String email}) async {
//     return await _repository.sendOtp(email: email);
//   }
// }

// /// 🟡 VerifyOtpUsecase - التحقق من OTP
// class VerifyOtpUsecase {
//   final AuthRepository _repository;

//   VerifyOtpUsecase(this._repository);

//   Future<Either<Failure, UserAuthEntity>> call({
//     required String email,
//     required String otp,
//   }) async {
//     // التحقق من صحة OTP (يجب أن تكون 6 أرقام)
//     if (otp.length != 6 || !otp.every((char) => char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
//       return Left(
//         ValidationFailure('OTP يجب أن يكون 6 أرقام'),
//       );
//     }

//     return await _repository.verifyOtp(
//       email: email,
//       otp: otp,
//     );
//   }
// }

// /// 🟢 VerifySignupOtpUsecase - التحقق من OTP بعد التسجيل
// class VerifySignupOtpUsecase {
//   final AuthRepository _repository;

//   VerifySignupOtpUsecase(this._repository);

//   Future<Either<Failure, UserAuthEntity>> call({
//     required String email,
//     required String otp,
//   }) async {
//     return await _repository.verifyOtp(
//       email: email,
//       otp: otp,
//     );
//   }
// }

// /// 🔵 CompleteProfileUsecase - إكمال بيانات الملف
// class CompleteProfileUsecase {
//   final AuthRepository _repository;

//   CompleteProfileUsecase(this._repository);

//   Future<Either<Failure, UserAuthEntity>> call({
//     required String userId,
//     required String dateOfBirth,
//     required String gender,
//     required String phoneNumber,
//   }) async {
//     // التحقق من صحة التاريخ
//     try {
//       DateTime.parse(dateOfBirth);
//     } catch (e) {
//       return Left(
//         ValidationFailure('تاريخ الميلاد غير صحيح'),
//       );
//     }

//     // التحقق من صحة الجنس
//     if (!['male', 'female', 'other'].contains(gender.toLowerCase())) {
//       return Left(
//         ValidationFailure('الجنس غير صحيح'),
//       );
//     }

//     // التحقق من صحة رقم الهاتف (بسيط)
//     if (phoneNumber.isEmpty || phoneNumber.length < 7) {
//       return Left(
//         ValidationFailure('رقم الهاتف غير صحيح'),
//       );
//     }

//     return await _repository.completeProfile(
//       userId: userId,
//       dateOfBirth: dateOfBirth,
//       gender: gender,
//       phoneNumber: phoneNumber,
//     );
//   }
// }

// /// 🔴 LogoutUsecase - تسجيل الخروج
// class LogoutUsecase {
//   final AuthRepository _repository;

//   LogoutUsecase(this._repository);

//   Future<Either<Failure, void>> call() async {
//     return await _repository.logout();
//   }
// }

// /// 🟣 GetSavedTokenUsecase - الحصول على التوكن المحفوظ
// class GetSavedTokenUsecase {
//   final AuthRepository _repository;

//   GetSavedTokenUsecase(this._repository);

//   Future<Either<Failure, String?>> call() async {
//     return await _repository.getSavedToken();
//   }
// }

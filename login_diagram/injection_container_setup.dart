// import 'package:get_it/get_it.dart';
// import 'package:your_app/core/services/dio_client.dart';
// import 'package:your_app/core/utils/token_storage.dart';
// import 'package:your_app/feature/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:your_app/feature/auth/data/repositories/auth_repository_impl.dart';
// import 'package:your_app/feature/auth/domain/repositories/auth_repository.dart';
// import 'package:your_app/feature/auth/domain/usecase/login_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/signup_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/logout_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/send_otp_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/verify_signup_otp_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/complete_profile_usecase.dart';
// import 'package:your_app/feature/auth/domain/usecase/get_saved_token_usecase.dart';
// import 'package:your_app/feature/auth/presentation/cubits/auth_cubit.dart';

// /// 🔧 Service Locator / Dependency Injection Setup
// /// استخدام GetIt للتسجيل المركزي للـ Dependencies

// final sl = GetIt.instance;

// /// إعداد Service Locator بالكامل
// /// قم باستدعاء هذه الدالة في main() قبل runApp()
// Future<void> setupServiceLocator() async {
//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🌐 CORE DEPENDENCIES
//   // ═══════════════════════════════════════════════════════════════════════════

//   // تسجيل Dio Client (يجب أن يكون singleton)
//   if (!sl.isRegistered<DioClient>()) {
//     sl.registerSingleton<DioClient>(
//       DioClient(),
//     );
//   }

//   // تسجيل Token Storage (يجب أن يكون singleton)
//   if (!sl.isRegistered<TokenStorage>()) {
//     sl.registerSingleton<TokenStorage>(
//       TokenStorage(),
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🗂️ DATA LAYER
//   // ═══════════════════════════════════════════════════════════════════════════

//   // تسجيل Auth Remote DataSource
//   sl.registerSingleton<AuthRemoteDataSource>(
//     AuthRemoteDataSourceImpl(sl<DioClient>()),
//   );

//   // تسجيل Auth Repository
//   sl.registerSingleton<AuthRepository>(
//     AuthRepositoryImpl(
//       remoteDataSource: sl<AuthRemoteDataSource>(),
//       tokenStorage: sl<TokenStorage>(),
//     ),
//   );

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 📦 DOMAIN LAYER - USECASES
//   // ═══════════════════════════════════════════════════════════════════════════

//   // تسجيل LoginUsecase
//   sl.registerSingleton<LoginUsecase>(
//     LoginUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل SignupUsecase
//   sl.registerSingleton<SignupUsecase>(
//     SignupUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل LogoutUsecase
//   sl.registerSingleton<LogoutUsecase>(
//     LogoutUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل SendOtpUsecase
//   sl.registerSingleton<SendOtpUsecase>(
//     SendOtpUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل VerifySignupOtpUsecase
//   sl.registerSingleton<VerifySignupOtpUsecase>(
//     VerifySignupOtpUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل CompleteProfileUsecase
//   sl.registerSingleton<CompleteProfileUsecase>(
//     CompleteProfileUsecase(sl<AuthRepository>()),
//   );

//   // تسجيل GetSavedTokenUsecase
//   sl.registerSingleton<GetSavedTokenUsecase>(
//     GetSavedTokenUsecase(sl<AuthRepository>()),
//   );

//   // ═══════════════════════════════════════════════════════════════════════════
//   // 🎮 PRESENTATION LAYER - CUBITS
//   // ═══════════════════════════════════════════════════════════════════════════

//   // تسجيل AuthCubit - يجب أن يكون singleton للتحكم في الحالة العامة
//   sl.registerSingleton<AuthCubit>(
//     AuthCubit(
//       loginUsecase: sl<LoginUsecase>(),
//       signupUsecase: sl<SignupUsecase>(),
//       logoutUsecase: sl<LogoutUsecase>(),
//       verifySignupOtpUsecase: sl<VerifySignupOtpUsecase>(),
//       completeProfileUsecase: sl<CompleteProfileUsecase>(),
//       getSavedTokenUsecase: sl<GetSavedTokenUsecase>(),
//     ),
//   );

//   print('✅ Service Locator setup completed successfully');
// }

// /// دالة مساعدة للتحقق من تسجيل dependency معين
// void verifyRegistrations() {
//   try {
//     // التحقق من تسجيل جميع المتعمدات
//     assert(sl.isRegistered<DioClient>(), 'DioClient not registered');
//     assert(sl.isRegistered<TokenStorage>(), 'TokenStorage not registered');
//     assert(sl.isRegistered<AuthRemoteDataSource>(), 'AuthRemoteDataSource not registered');
//     assert(sl.isRegistered<AuthRepository>(), 'AuthRepository not registered');
//     assert(sl.isRegistered<LoginUsecase>(), 'LoginUsecase not registered');
//     assert(sl.isRegistered<SignupUsecase>(), 'SignupUsecase not registered');
//     assert(sl.isRegistered<LogoutUsecase>(), 'LogoutUsecase not registered');
//     assert(sl.isRegistered<SendOtpUsecase>(), 'SendOtpUsecase not registered');
//     assert(sl.isRegistered<VerifySignupOtpUsecase>(), 'VerifySignupOtpUsecase not registered');
//     assert(sl.isRegistered<CompleteProfileUsecase>(), 'CompleteProfileUsecase not registered');
//     assert(sl.isRegistered<GetSavedTokenUsecase>(), 'GetSavedTokenUsecase not registered');
//     assert(sl.isRegistered<AuthCubit>(), 'AuthCubit not registered');

//     print('✅ All registrations verified successfully');
//   } catch (e) {
//     print('❌ Registration verification failed: $e');
//   }
// }

// /// دالة مساعدة لإزالة جميع التسجيلات (مفيدة للاختبارات)
// Future<void> cleanupServiceLocator() async {
//   await sl.reset();
//   print('✅ Service Locator cleaned up');
// }

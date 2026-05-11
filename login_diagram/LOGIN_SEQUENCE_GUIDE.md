# تسلسل تسجيل الدخول الكامل - Complete Login Sequence Guide

## 📋 نظرة عامة | Overview

تسلسل تسجيل الدخول يتضمن 6 خطوات رئيسية:
1. **Login Screen** - إدخال البريد الإلكتروني وكلمة المرور
2. **Cubit: login()** - تنفيذ حالة الانتظار والتحقق
3. **Repository** - تمرير البيانات إلى طبقة البيانات
4. **DataSource** - الاتصال بـ API
5. **Response Handling** - التعامل مع النجاح/الفشل
6. **State Navigation** - توجيه واجهة المستخدم بناءً على الحالة

---

## 🏗️ المعمارية | Architecture Flow

```
┌─────────────────────────────────────────────────────────────┐
│ UI LAYER (Login Screen)                                      │
│ - TextFields: email, password                               │
│ - Submit Button → cubit.login(email, password)             │
└────────────────┬────────────────────────────────────────────┘
                 │ emit(AuthLoading)
┌─────────────────▼────────────────────────────────────────────┐
│ PRESENTATION LAYER (AuthCubit)                               │
│ - login() → loginUsecase(email, password)                  │
│ - fold(failure, userEntity)                                │
│   ├─ Failure → emit(AuthError) or emit(ProfileIncomplete) │
│   └─ User → emit(AuthLoaded) or emit(ProfileIncomplete)   │
└────────────────┬────────────────────────────────────────────┘
                 │
┌─────────────────▼────────────────────────────────────────────┐
│ DOMAIN LAYER (LoginUsecase)                                  │
│ - call(email, password) → repository.login(...)            │
└────────────────┬────────────────────────────────────────────┘
                 │
┌─────────────────▼────────────────────────────────────────────┐
│ DATA LAYER (AuthRepository)                                  │
│ - login() → remoteDataSource.login(...)                    │
│ - Cache token & user in TokenStorage                       │
└────────────────┬────────────────────────────────────────────┘
                 │
┌─────────────────▼────────────────────────────────────────────┐
│ REMOTE DATA SOURCE (Dio HTTP Client)                         │
│ - POST /api/auth/login {email, password}                   │
│ - Response: {token, user, profile_complete}                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 Login Screen Implementation

### File: `lib/feature/auth/presentation/screens/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/feature/auth/presentation/cubits/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // 🔴 خطوة 1: استدعاء cubit.login()
      context.read<AuthCubit>().login(
            email: email,
            password: password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // 🟢 خطوة 6: استجابة للحالات
          if (state is AuthLoaded) {
            // نجح - المستخدم لديه ملف شامل
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
            );
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is ProfileIncomplete) {
            // نجح لكن الملف ناقص
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('يرجى إكمال بيانات الملف')),
            );
            Navigator.of(context).pushReplacementNamed('/complete-profile');
          } else if (state is AuthError) {
            // فشل عام
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // البريد الإلكتروني
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'البريد الإلكتروني مطلوب';
                        }
                        if (!value!.contains('@')) {
                          return 'البريد الإلكتروني غير صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // كلمة المرور
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'كلمة المرور مطلوبة';
                        }
                        if (value!.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // زر تسجيل الدخول
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('تسجيل الدخول'),
                    ),
                    const SizedBox(height: 16),

                    // روابط إضافية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context)
                                      .pushNamed('/forgot-password');
                                },
                          child: const Text('هل نسيت كلمة المرور؟'),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).pushNamed('/signup');
                                },
                          child: const Text('إنشاء حساب جديد'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

---

## 🎮 AuthCubit: Login Method

### File: `lib/feature/auth/presentation/cubits/auth_cubit.dart` (الجزء الخاص بـ login)

```dart
// في داخل AuthCubit class

/// 🔴 خطوة 2: استدعاء usecase من Cubit
Future<void> login({
  required String email,
  required String password,
}) async {
  // انبعث حالة التحميل
  emit(AuthLoading());

  try {
    // استدعاء usecase مع معاملات البيانات
    final result = await _loginUsecase(
      email: email,
      password: password,
    );

    // 🎯 fold pattern: معالجة النتيجة (خطأ أو نجاح)
    result.fold(
      (failure) {
        // ❌ فشل العملية
        _handleLoginFailure(failure);
      },
      (user) {
        // ✅ نجح الدخول
        _handleLoginSuccess(user);
      },
    );
  } catch (e) {
    // خطأ غير متوقع
    _log('Login error: $e');
    emit(AuthError('خطأ غير متوقع: $e'));
  }
}

/// معالج الفشل الخاص
void _handleLoginFailure(Failure failure) {
  _log('Login failed: $failure');

  // تصنيف الأخطاء
  if (failure is ServerFailure) {
    if (_isInactiveAccountError(failure.message)) {
      // الحساب غير نشط - يحتاج تفعيل
      emit(AuthError('الحساب غير نشط. يرجى تفعيله عبر البريد الإلكتروني'));
    } else if (failure.message.contains('Invalid credentials')) {
      emit(AuthError('بيانات الدخول غير صحيحة'));
    } else {
      emit(AuthError(failure.message));
    }
  } else if (failure is NetworkFailure) {
    emit(AuthError('خطأ في الاتصال. تحقق من الاتصال بالإنترنت'));
  } else {
    emit(AuthError(failure.message));
  }
}

/// معالج النجاح الخاص
void _handleLoginSuccess(UserAuthEntity user) {
  _log('Login success: ${user.email}');

  // 💾 حفظ التوكن (يجب أن يكون done بواسطة repository!)
  // لكن نتحقق للتأكيد
  if (user.token == null || user.token!.isEmpty) {
    emit(AuthError('لم يتم استقبال توكن من الخادم'));
    return;
  }

  // تحقق من اكتمال الملف
  if (user.isProfileComplete) {
    // ✅ الملف كامل - دخول مباشر
    emit(AuthLoaded(user));
  } else {
    // ⚠️ الملف ناقص - إعادة توجيه لإكمال الملف
    emit(ProfileIncomplete(user));
  }
}

/// فحص خاص للحسابات غير النشطة
bool _isInactiveAccountError(String message) {
  final inactivateKeywords = [
    'inactive',
    'not activated',
    'pending activation',
    'verify email',
  ];
  return inactivateKeywords.any(
    (keyword) => message.toLowerCase().contains(keyword),
  );
}

/// تسجيل بسيط للتصحيح
void _log(String message) {
  debugPrint('[AuthCubit] $message');
}
```

---

## 📦 Domain Layer: LoginUsecase

### File: `lib/feature/auth/domain/usecase/login_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:your_app/core/error/failure.dart';
import 'package:your_app/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:your_app/feature/auth/domain/repositories/auth_repository.dart';

/// 🔵 خطوة 3: طبقة المجال - تعريف العملية
class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  /// استدعاء العملية: call(email, password)
  Future<Either<Failure, UserAuthEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(
      email: email,
      password: password,
    );
  }
}
```

---

## 🗂️ Data Layer: Repository Implementation

### File: `lib/feature/auth/data/repositories/auth_repository_impl.dart` (الجزء الخاص بـ login)

```dart
@override
Future<Either<Failure, UserAuthEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    // 🟡 خطوة 4: استدعاء remote datasource
    final userModel = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    // 💾 خطوة حفظ التوكن
    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await _tokenStorage.saveToken(userModel.token!);
      _log('Token saved: ${userModel.token!.substring(0, 20)}...');
    }

    // تحويل إلى entity والعودة
    return Right(userModel.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('Unknown error: $e'));
  }
}

void _log(String message) {
  debugPrint('[AuthRepositoryImpl] $message');
}
```

---

## 🔌 Remote DataSource: API Call

### File: `lib/feature/auth/data/datasources/auth_remote_datasource.dart`

```dart
abstract class AuthRemoteDataSource {
  /// تسجيل الدخول عبر البريد الإلكتروني وكلمة المرور
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

/// التنفيذ الفعلي
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _log('Logging in: $email');

      // 🟢 خطوة 5: استدعاء API
      final response = await _dioClient.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // فحص الاستجابة
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        _log('Login response received');

        // تحويل JSON إلى UserModel
        final userModel = UserModel.fromJson(data['user'] ?? data);

        return userModel;
      } else {
        throw ServerException(
          'Login failed: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // معالجة أخطاء Dio
      final message = _extractErrorMessage(e);
      _log('Dio error: $message');
      throw ServerException(message);
    } catch (e) {
      _log('Unexpected error: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  /// استخراج رسالة الخطأ من استجابة الخادم
  String _extractErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    }
    if (e.response?.data is Map) {
      final errorData = e.response!.data as Map<String, dynamic>;
      return errorData['message'] ?? errorData['error'] ?? e.message ?? 'Unknown error';
    }
    return e.message ?? 'Unknown error';
  }

  void _log(String message) {
    debugPrint('[AuthRemoteDataSource] $message');
  }
}
```

---

## 📊 Login Request/Response Models

### File: `lib/feature/auth/data/models/user_model.dart` (المتعلق بـ login)

```dart
class UserModel extends UserAuthEntity {
  const UserModel({
    required String id,
    required String email,
    required String? firstName,
    required String? lastName,
    required String? phoneNumber,
    required String? dateOfBirth,
    required String? gender,
    required String? token,
    required bool? isProfileComplete,
    required DateTime? createdAt,
  }) : super(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
    gender: gender,
    token: token,
    isProfileComplete: isProfileComplete ?? false,
    createdAt: createdAt,
  );

  /// تحويل من JSON (من API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      token: json['token'] as String?,
      isProfileComplete: json['is_profile_complete'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// تحويل إلى JSON (للإرسال)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'token': token,
      'is_profile_complete': isProfileComplete,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// تحويل إلى entity (للاستخدام في الـ domain)
  UserAuthEntity toEntity() {
    return UserAuthEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      token: token,
      isProfileComplete: isProfileComplete,
      createdAt: createdAt,
    );
  }
}
```

---

## 🔧 DI Registration

### File: `lib/core/di/injection_container.dart` (الجزء الخاص بـ login)

```dart
/// تسجيل usecase
_setupAuthUseCases() {
  // تسجيل LoginUsecase
  sl.registerSingleton<LoginUsecase>(
    LoginUsecase(sl<AuthRepository>()),
  );

  // ... تسجيل الـ usecases الأخرى ...
}

/// تسجيل Cubit
_setupAuthPresentationLayer() {
  sl.registerSingleton<AuthCubit>(
    AuthCubit(
      loginUsecase: sl<LoginUsecase>(),
      // ... المعاملات الأخرى ...
    ),
  );
}

/// في main() أو initializeServiceLocator()
Future<void> setupServiceLocator() async {
  // .. التسجيلات الأخرى
  _setupAuthUseCases();
  _setupAuthPresentationLayer();
}
```

---

## 🚀 Navigation Setup

### File: `lib/core/routes/app_router.dart`

```dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case '/complete-profile':
        final user = settings.arguments as UserAuthEntity?;
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(user: user),
          settings: settings,
        );

      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Unknown route')),
          ),
        );
    }
  }
}
```

---

## 📱 Main App Setup

### File: `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(); // تسجيل الـ DI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيقي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider<AuthCubit>(
        create: (_) => sl<AuthCubit>(),
        child: const SplashScreen(),
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
```

---

## 🧪 اختبار التدفق | Testing Flow

### في Postman أو cURL:

```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

# الاستجابة الناجحة:
{
  "user": {
    "id": "123",
    "email": "user@example.com",
    "first_name": "أحمد",
    "last_name": "محمد",
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "is_profile_complete": true,
    "created_at": "2026-05-11T00:00:00Z"
  }
}
```

---

## 📊 حالات الاستجابة | Response Cases

| الحالة | الوصف | State Emitted |
|-------|-------|--------------|
| ✅ نجح + ملف كامل | البيانات صحيحة والملف مكتمل | `AuthLoaded(user)` |
| ✅ نجح + ملف ناقص | البيانات صحيحة لكن الملف ناقص | `ProfileIncomplete(user)` |
| ❌ بيانات خاطئة | البريد أو كلمة المرور خاطئة | `AuthError('بيانات غير صحيحة')` |
| ❌ حساب معطل | الحساب غير مفعل أو موقوف | `AuthError('الحساب غير نشط')` |
| ❌ خطأ شبكة | لا توجد إنترنت | `AuthError('خطأ في الاتصال')` |
| ❌ خطأ خادم | خطأ 500 | `AuthError('خطأ في الخادم')` |

---

## 🎯 ملخص الخطوات

```
1. ❌ المستخدم يدخل البيانات في LoginScreen
      ↓
2. 🟠 يضغط "تسجيل الدخول" → cubit.login(email, password)
      ↓
3. 🟡 AuthCubit يستدعي LoginUsecase
      ↓
4. 🟢 LoginUsecase يستدعي AuthRepository.login()
      ↓
5. 🔵 AuthRepository يستدعي AuthRemoteDataSource.login()
      ↓
6. 🟣 RemoteDataSource يرسل POST request إلى /api/auth/login
      ↓
7. 💾 API يرد بـ token و user data
      ↓
8. 💪 Repository يحفظ التوكن في TokenStorage
      ↓
9. 🎯 Cubit يتحقق من اكتمال الملف
      ↓
10. 🔴 emit(AuthLoaded) أو emit(ProfileIncomplete)
      ↓
11. 🎬 UI تستجيب للـ state وتعيد التوجيه
```

---

## 🔑 النقاط المهمة | Key Points

✅ **حفظ التوكن**: في `AuthRepository.login()` بعد نجاح API
✅ **معالجة الأخطاء**: تصنيف Failures في Cubit
✅ **التحقق من الملف**: `user.isProfileComplete` في Cubit
✅ **إغلاق Resources**: تخليص الـ TextEditingControllers في dispose
✅ **State Pattern**: استخدام fold() من Dartz للـ Either
✅ **DI Registration**: تسجيل الـ Usecase و Cubit في injection_container

---

## ⚠️ الأخطاء الشائعة | Common Mistakes

❌ عدم حفظ التوكن → المستخدم يُخرج من الجلسة
❌ عدم التحقق من `isProfileComplete` → لا يتم إعادة التوجيه للملف الناقص
❌ عدم تنظيف Controllers → تسرب الذاكرة
❌ عدم معالجة Network Errors → تطبيق يتعطل
❌ استدعاء setState في BlocListener → حدوث خطأ

---

تم! 🎉 لديك الآن تسلسل دخول كامل وواضح جاهز للتنفيذ!

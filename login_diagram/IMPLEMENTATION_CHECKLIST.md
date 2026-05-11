# ✅ تسلسل تسجيل الدخول - قائمة التحقق الكاملة
# Complete Login Sequence Implementation Checklist

---

## 📋 ملخص الملفات المطلوبة | Files Summary

تم إنشاء **7 ملفات رئيسية** جاهزة للاستخدام:

| # | الملف | الموقع | الغرض |
|---|------|--------|--------|
| 1 | `LOGIN_SEQUENCE_GUIDE.md` | `/outputs/` | دليل شامل بجميع الخطوات |
| 2 | `login_screen.dart` | `/outputs/` | شاشة تسجيل الدخول - UI |
| 3 | `auth_cubit.dart` | `/outputs/` | إدارة الحالة - Logic |
| 4 | `auth_remote_datasource.dart` | `/outputs/` | اتصالات API |
| 5 | `auth_repository_impl.dart` | `/outputs/` | طبقة البيانات |
| 6 | `usecases.dart` | `/outputs/` | منطق تسجيل الدخول |
| 7 | `injection_container_setup.dart` | `/outputs/` | إعداد DI |

---

## 🔄 تدفق البيانات الكامل | Complete Data Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 1: USER INTERFACE                                               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  LoginScreen                                                          │
│  ├─ TextFormField: email                                            │
│  ├─ TextFormField: password (obscured)                              │
│  └─ ElevatedButton: "تسجيل الدخول"                                   │
│        └─ onPressed → context.read<AuthCubit>().login()             │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ Emits: AuthLoading
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 2: PRESENTATION LAYER (Cubit)                                   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  AuthCubit.login(email, password)                                    │
│  ├─ Validate inputs                                                  │
│  ├─ Call LoginUsecase.call(email, password)                         │
│  └─ result.fold(                                                     │
│       (failure) → emit(AuthError),                                   │
│       (user) → {                                                     │
│         if (user.isProfileComplete)                                 │
│           emit(AuthLoaded(user))                                    │
│         else                                                         │
│           emit(ProfileIncomplete(user))                             │
│       }                                                              │
│     )                                                                │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ Calls: LoginUsecase
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 3: DOMAIN LAYER (Usecase)                                       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  LoginUsecase.call(email, password)                                  │
│  └─ repository.login(email, password)                               │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ Calls: Repository
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 4: DATA LAYER (Repository)                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  AuthRepositoryImpl.login(email, password)                            │
│  ├─ Call: remoteDataSource.login(...)                               │
│  ├─ Save token: tokenStorage.saveToken(userModel.token)             │
│  ├─ Convert: userModel.toEntity()                                   │
│  └─ Return: Either<Failure, UserAuthEntity>                         │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ Calls: Remote DataSource
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 5: REMOTE DATA SOURCE (API)                                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  AuthRemoteDataSourceImpl.login(email, password)                      │
│  ├─ Build request: {email, password}                                │
│  ├─ POST /api/auth/login                                            │
│  ├─ Parse response JSON → UserModel                                 │
│  └─ Return: UserModel                                               │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ HTTP Request
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 6: BACKEND API (Django)                                         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  POST /api/auth/login                                                │
│  Request:  {email: "...", password: "..."}                          │
│  Response: {                                                         │
│    user: {                                                          │
│      id: "123",                                                     │
│      email: "user@example.com",                                     │
│      first_name: "أحمد",                                             │
│      token: "eyJ...",                                               │
│      is_profile_complete: true/false                                │
│    }                                                                │
│  }                                                                  │
│                                                                        │
└───────────────────────────┬────────────────────────────────────────────┘
                            │
                            │ Returns JSON
                            ▼
┌──────────────────────────────────────────────────────────────────────┐
│ STEP 7: STATE EMISSION & UI RESPONSE                                 │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  BlocListener<AuthCubit, AuthState>(                                 │
│    listener: (context, state) {                                      │
│      if (state is AuthLoaded) {                                      │
│        // Profile complete → Navigate to /home                      │
│        Navigator.pushReplacementNamed(context, '/home');            │
│      }                                                               │
│      else if (state is ProfileIncomplete) {                         │
│        // Profile incomplete → Navigate to /complete-profile        │
│        Navigator.pushReplacementNamed(                              │
│          context,                                                   │
│          '/complete-profile',                                       │
│          arguments: state.user                                      │
│        );                                                           │
│      }                                                               │
│      else if (state is AuthError) {                                 │
│        // Show error message                                        │
│        ScaffoldMessenger.of(context).showSnackBar(                  │
│          SnackBar(content: Text(state.message))                     │
│        );                                                           │
│      }                                                              │
│    }                                                                │
│  )                                                                  │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 خطوات التنفيذ العملية | Implementation Steps

### الخطوة 1: نسخ الملفات
```bash
# انسخ الملفات من /outputs/ إلى المشاريع الصحيحة:

# lib/feature/auth/presentation/screens/
cp login_screen.dart lib/feature/auth/presentation/screens/

# lib/feature/auth/presentation/cubits/
cp auth_cubit.dart lib/feature/auth/presentation/cubits/

# lib/feature/auth/data/datasources/
cp auth_remote_datasource.dart lib/feature/auth/data/datasources/

# lib/feature/auth/data/repositories/
cp auth_repository_impl.dart lib/feature/auth/data/repositories/

# lib/feature/auth/domain/usecase/
cp usecases.dart lib/feature/auth/domain/usecase/login_usecase.dart
# (أنشئ ملفات منفصلة لكل usecase أو احتفظ بها معاً)

# lib/core/di/
cp injection_container_setup.dart lib/core/di/
```

### الخطوة 2: التحديثات المطلوبة

#### `lib/main.dart`:
```dart
import 'package:your_app/core/di/injection_container_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔴 استدعاء إعداد DI
  await setupServiceLocator();
  
  // ✅ تحقق من التسجيلات (اختياري)
  verifyRegistrations();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<AuthCubit>(
        create: (_) => sl<AuthCubit>(),
        child: const SplashScreen(),
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
```

#### `lib/core/routes/app_router.dart`:
```dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      
      case '/complete-profile':
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            user: settings.arguments as UserAuthEntity,
          ),
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

### الخطوة 3: التحقق من المتعلقات (Dependencies)

تأكد من تثبيت:
```yaml
dependencies:
  flutter_bloc: ^8.0.0
  dartz: ^0.10.1
  dio: ^5.0.0
  get_it: ^7.0.0
  equatable: ^2.0.5
```

### الخطوة 4: اختبار الدخول
```dart
// اختبر في Postman أو cURL:
POST http://localhost:8000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}

// الاستجابة الناجحة:
{
  "user": {
    "id": "123",
    "email": "test@example.com",
    "first_name": "أحمد",
    "last_name": "محمد",
    "token": "eyJ...",
    "is_profile_complete": true,
    "created_at": "2026-05-11T00:00:00Z"
  }
}
```

---

## 🎯 النقاط الحرجة | Critical Points

### ✅ يجب أن تفعل:

1. **حفظ التوكن**:
   ```dart
   // في AuthRepositoryImpl.login()
   await _tokenStorage.saveToken(userModel.token!);
   ```

2. **التحقق من اكتمال الملف**:
   ```dart
   if (user.isProfileComplete) {
     emit(AuthLoaded(user));
   } else {
     emit(ProfileIncomplete(user));
   }
   ```

3. **معالجة الأخطاء الصحيحة**:
   ```dart
   result.fold(
     (failure) => emit(AuthError(failure.message)),
     (user) => _handleLoginSuccess(user),
   );
   ```

4. **تنظيف Resources**:
   ```dart
   @override
   void dispose() {
     _emailController.dispose();
     _passwordController.dispose();
     super.dispose();
   }
   ```

5. **التحقق من صحة البيانات المدخلة**:
   ```dart
   // في login_screen.dart
   if (_formKey.currentState?.validate() ?? false) {
     _handleLogin();
   }
   ```

### ❌ لا تفعل:

1. ❌ عدم حفظ التوكن → المستخدم يخرج من الجلسة
2. ❌ عدم التحقق من `isProfileComplete` → لا يتم إعادة التوجيه
3. ❌ استخدام `setState` في BlocListener → قد يسبب خطأ
4. ❌ عدم معالجة Network Errors → التطبيق يتعطل
5. ❌ ترك TextEditingControllers بدون dispose → تسرب الذاكرة

---

## 🧪 اختبار اليد | Manual Testing

### سيناريو 1: دخول ناجح مع ملف كامل
```
1. أدخل: email = "user@example.com", password = "password123"
2. اضغط: "تسجيل الدخول"
3. انتظر: ✓ يجب أن يظهر "تم تسجيل الدخول بنجاح"
4. انتظر: ✓ يجب أن تنتقل إلى /home
```

### سيناريو 2: دخول ناجح مع ملف ناقص
```
1. أدخل: email = "incomplete@example.com", password = "password123"
2. اضغط: "تسجيل الدخول"
3. انتظر: ✓ يجب أن يظهر "يرجى إكمال بيانات الملف"
4. انتظر: ✓ يجب أن تنتقل إلى /complete-profile
```

### سيناريو 3: بيانات خاطئة
```
1. أدخل: email = "wrong@example.com", password = "wrongpass"
2. اضغط: "تسجيل الدخول"
3. انتظر: ✓ يجب أن يظهر "بيانات الدخول غير صحيحة"
4. انتظر: ✓ البقاء على نفس الشاشة
```

### سيناريو 4: خطأ في الاتصال
```
1. قطع الإنترنت
2. أدخل: بيانات صحيحة
3. اضغط: "تسجيل الدخول"
4. انتظر: ✓ يجب أن يظهر "خطأ في الاتصال"
```

---

## 📊 قائمة التحقق النهائية | Final Checklist

- [ ] نسخت جميع الملفات إلى المجلدات الصحيحة
- [ ] استيراد جميع الـ Packages المطلوبة
- [ ] استدعاء `setupServiceLocator()` في `main()`
- [ ] أضفت routes `/login`, `/home`, `/complete-profile`
- [ ] شاشة التسجيل تقبل email/password
- [ ] التوكن يحفظ في التخزين المحلي
- [ ] التطبيق يتحقق من اكتمال الملف
- [ ] رسائل الخطأ تظهر بشكل صحيح
- [ ] التطبيق ينتقل إلى الشاشة الصحيحة بناءً على الحالة
- [ ] لا توجد memory leaks (تنظيف Resources)

---

## 🎉 النتيجة النهائية

لديك الآن **تسلسل دخول كامل وآمن** يتضمن:

✅ شاشة login جميلة وسهلة الاستخدام
✅ إدارة حالة قوية مع Cubit + BLoC
✅ معالجة شاملة للأخطاء
✅ حفظ آمن للتوكن
✅ توجيه ذكي بناءً على حالة الملف
✅ معمارية نظيفة وقابلة للصيانة

---

## 📞 الدعم والمساعدة

إذا واجهت أي مشاكل:

1. تحقق من استيراد جميع الـ Packages
2. تأكد من استدعاء `setupServiceLocator()`
3. فعّل Logging بإضافة `_log()` في كل خطوة
4. استخدم DevTools للتحقق من state tree
5. فعّل Network Monitor في Postman للتحقق من API calls

---

**تم! 🎉 استمتع بتسجيل دخول احترافي!**

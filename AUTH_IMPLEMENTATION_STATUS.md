# حالة تنفيذ ميزة المصادقة (Auth)

ملخّص سريع
- المستندات الموجودة في المستودع: `ARCHITECTURE_FLOW_DIAGRAMS.md`, `AUTH_ARCHITECTURE_BLUEPRINT.md`, `AUTH_QUICK_REFERENCE.md`, `AUTHENTICATION_FLOWS.md`, `AUTHENTICATION_IMPLEMENTATION_ROADMAP.md`.
- النتيجة الحالية: توثيق معماري شامل وخريطة طريق واضحة لتنفيذ الميزة.

العناصر المنجزة (مستندات/تخطيط)
- وثّقنا بنية النظام وتدفّق الحالات وخرائط التدفق (Flows).
- أنشأنا مرجعًا سريعًا يحدّد الملفات والأهداف لكل مرحلة.
- وُضع مخطط طريق تفصيلي (Implementation Roadmap) مع مهام قابلة للتتبّع.

العناصر الناقصة (عمل تطبيقي)
1. Phase 1 — Domain & Data
   - إنشاء الـ `entities` الفعلية (`UserAuthEntity`, `OtpEntity`) — غير منفّذ.
   - تنفيذ جميع `UseCase` والـ `Params` — غير منفّذ.
   - نماذج البيانات (`UserModel`, `OtpModel`) مع `fromJson`/`toEntity` — غير منفّذ.
   - إضافة `AuthRemoteDataSource` و `AuthRemoteDataSourceImpl` (Dio) — غير منفّذ.
   - تنفيذ `AuthRepositoryImpl` مع تحويل الأخطاء إلى `Failure` — غير منفّذ.

2. Phase 2 — Presentation & State Management
   - تعريف كل حالات `AuthState` والـ `AuthCubit` مع جميع الدوال (signup, verifyOtp, login, updateProfile, logout, deleteAccount, requestEmailChange, confirmEmailChange, updatePassword, googleSignIn، الخ) — غير منفّذ.
   - تنفيذ آليات التخزين المؤقت للرموز (`TokenStorage`) وطرق مسحها — غير منفّذ.
   - تحديث DI في `lib/core/di/injection_container.dart` لتسجيل usecases، repository، cubit — غير منفّذ.

3. Phase 3 — Navigation & Splash
   - `AppRouter.generateRoute()` و`MyRoutes` مع حالات التوجّه إلى الشاشات ذات الصلة — غير منفّذ.
   - شاشة `SplashScreen` التي تتحقّق من التوكن وتوجّه المستخدم — غير منفّذ.

4. Phase 4 — واجهة المستخدم (Screens)
   - شاشات: `SignupScreen`, `VerifyOtpScreen`, `CompleteProfileScreen`, `LoginScreen`, `ForgotPasswordScreen`, `ProfileSettingsScreen` ومكونات قابلة لإعادة الاستخدام (otp_input, auth_text_field, countdown_timer, password_strength) — غير منفّذ.

5. Phase 5 — اختبارات
   - اختبارات وحدة للـ usecases والـ repositories، اختبارات ويدجت للواجهات، اختبارات تكامل للـ flows — غير منفّذ.

6. تكامل Backend وميزات إضافية
   - إعداد Dio interceptor لربط `access_token` وميكانيكية تجديد الرمز (refresh token) — غير منفّذ.
   - تحقق من توافق العقود (endpoints) مع الفريق الخلفي وللتعامل مع رموز الحالة المختلفة — غير منفّذ.

خطوات مقترحة وأولوية التنفيذ
1. تنفيذ Phase 1 (Domain & Data): إنشاء الـ `entities`، `models`, و `usecases`، ثم تنفيذ `AuthRemoteDataSourceImpl` الجزئي لطلبات الـ API الأساسية.
2. تنفيذ `AuthRepositoryImpl` مع تحويــل الأخطاء إلى `Failure` وكتابة اختبارات وحدة بسيطة للموديلات.
3. إعداد `TokenStorage` وDio interceptor بسيط لإرسال الـ `Authorization` header.
4. تنفيذ Phase 2 (Cubit + States) وربط UseCases مع Cubit، ثم تحديث DI.
5. تنفيذ Phase 3 & 4 (Router + Screens) بالترتيب: شاشة التحقق (OTP) → تسجيل الدخول/التسجيل → استكمال الملف الشخصي → إعدادات الملف الشخصي.
6. كتابة اختبارات (Phase 5) تدريجيًا أثناء تنفيذ كل جزء.
7. تكامل وتحقق نهائي مع الـ Backend: اختبار سيناريوهات 200/400/401/500 وعمليات التجديد.

اقتراح عملي فوري
- أبدأ الآن بإنشاء الملفات الأساسية للـ Phase 1 (`entities`, `usecases` skeletons, `models`) ثم أعود لتحديثك بالملفات التي أنشأتها واختبار `flutter analyze`/`dart analyze`.

ملف الحالة هذا تم إنشاؤه تلقائيًا من الوثائق الموجودة في المستودع؛ للتفاصيل راجع الملفات المذكورة أعلاه.

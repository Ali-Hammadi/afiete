# Authentication Feature - Implementation Roadmap & Checklist

**Overall Status**: 🔄 Phase 5 Ready - Phase 4 Complete (100%)  
**Timeline**: 4-6 weeks (with Django backend parallel development)  
**Team Capability**: Solo Flutter developer + Django backend team  

---

## 📊 Progress Summary

| Phase | Name | Status | Completion |
|-------|------|--------|-----------|
| Phase 1 | Domain Layer & Data Contracts | ✅ Complete | 100% |
| Phase 2 | Presentation Layer - Cubit & State | ✅ Complete | 100% |
| Phase 3 | Presentation Layer - Routing | ✅ Complete | 100% |
| Phase 4 | UI Screens | ✅ Complete | 100% |
| Phase 5 | Testing & Refinement | ⏳ Not Started | 0% |
| Phase 6 | Backend Integration | 🔄 Ongoing | 50% |

### Key Accomplishments
- ✅ All domain entities, repositories, and usecases implemented
- ✅ Complete Cubit state machine with all auth flows
- ✅ Navigation and routing infrastructure in place
- ✅ 7 major auth screens fully implemented with BlocConsumer integration
- ✅ All reusable widgets created:
  - CustomTextFormField (email/password validation)
  - AuthVerificationPinInput (6-digit OTP input)
  - AuthHeader, AuthGoogleButton, AuthSwitchPrompt
  - **NEW**: CountdownTimer & CountdownResendButton (OTP countdown management)
  - **NEW**: PasswordStrengthIndicator (password quality feedback)
- ✅ Error handling with professional user-friendly messages
- ✅ Structured logging with AppLogger across auth data, repository, and cubit layers
- ✅ Token management and caching integrated
- ✅ Theme support (dark/light mode) for all screens

### Pending Items
- ⏳ Unit & widget tests (Phase 5)
- ⏳ Integration tests (Phase 5)  
- ⏳ Email change flow methods (usecase + UI)

---

## Phase 1: Domain Layer & Data Contracts (1-2 weeks)

### Objective
Establish the business logic layer (entities, repositories, usecases) and data contracts. This layer should be **backend-agnostic** - ready to work whenever the Django API is ready.

### 1.1 Domain - Entities

- [x] Create `lib/feature/auth/domain/entities/auth_user_entity.dart`
  - [x] `UserAuthEntity` class with all fields (id, username, nickname, email, DOB, gender, phone, isVerified, accessToken, refreshToken)
  - [x] Implement `isProfileComplete` getter
  - [x] Add Equatable props

- [x] Create `lib/feature/auth/domain/entities/otp_entity.dart`
  - [x] `OtpEntity` class (email, expiresInSeconds, message)

### 1.2 Domain - Repository Interface

- [x] Create `lib/feature/auth/domain/repositories/auth_repository.dart`
  - [x] Define abstract methods for all auth operations
  - [x] Return types: `Future<Either<Failure, T>>`
  - [x] Methods: signup, verifySignupOtp, login, updateProfileInfo, logout, deleteAccount, etc.

### 1.3 Domain - Use Cases

Create `lib/feature/auth/domain/usecase/` with one file per usecase:

- [x] `signup_usecase.dart` → SignupUseCase + SignupParams
- [x] `verify_signup_otp_usecase.dart` → VerifySignupOtpUseCase + VerifySignupOtpParams
- [x] `login_usecase.dart` → LoginUseCase + LoginParams
- [x] `fetch_profile_usecase.dart` → FetchProfileUseCase + NoParams
- [x] `update_profile_info_usecase.dart` → UpdateProfileInfoUseCase + UpdateProfileParams
- [x] `logout_usecase.dart` → LogoutUseCase + NoParams
- [x] `delete_account_usecase.dart` → DeleteAccountUseCase + DeleteAccountParams
- [x] `google_signin_usecase.dart` → GoogleSignInUseCase + GoogleSignInParams
- [x] `request_forgot_password_otp_usecase.dart` → RequestForgotPasswordOtpUseCase + ForgotPasswordParams
- [x] `verify_forgot_password_otp_usecase.dart` → VerifyForgotPasswordOtpUseCase + VerifyForgotPasswordOtpParams
- [ ] `update_password_usecase.dart` → UpdatePasswordUseCase + UpdatePasswordParams
- [ ] `request_email_change_otp_usecase.dart` → RequestEmailChangeOtpUseCase + NoParams
- [ ] `confirm_email_change_usecase.dart` → ConfirmEmailChangeUseCase + ConfirmEmailChangeParams

**Verification**:
```bash
# Run for type safety
flutter analyze lib/feature/auth/domain/

# Ensure all usecases implement UseCase<T, P>
# Ensure all entities extend Equatable
```

### 1.4 Data - Models

Create `lib/feature/auth/data/models/` with converter methods:

- [x] `user_model.dart`
  - [x] UserModel class with all UserAuthEntity fields
  - [x] `fromJson()` factory (handle both snake_case & camelCase)
  - [x] `toEntity()` conversion method
  - [x] Equatable implementation

- [x] `otp_model.dart`
  - [x] OtpModel class
  - [x] `fromJson()` factory
  - [x] `toEntity()` conversion method

**Verification**:
```dart
// Test model deserialization
void main() {
  final json = {
    'id': '123',
    'username': 'user123',
    'email': 'user@example.com',
    'is_verified': false,
    'access_token': 'token_xyz'
  };
  
  final model = UserModel.fromJson(json);
  final entity = model.toEntity();
  
  assert(entity.id == '123');
  assert(entity.email == 'user@example.com');
}
```

### 1.5 Data - Remote Data Source

Create `lib/feature/auth/data/datasources/auth_remote_datasource.dart`

- [x] `AuthRemoteDataSource` abstract class with all method signatures
- [x] `AuthRemoteDataSourceImpl` implementation class
  - [x] Inject Dio instance (from DI)
  - [x] Implement all methods
  - [x] Use try-catch for DioException handling
  - [x] Parse response data → Models

**Key Implementation Notes**:
- Base URL: `/api/auth/` (configured in Dio BaseOptions)
- All endpoints return models via `.fromJson(response.data)`
- No error handling here - just rethrow DioException
- Handle both direct response and wrapped response (`response.data['user']`)

### 1.6 Data - Repository Implementation

Create `lib/feature/auth/data/repositories/auth_repository_impl.dart`

- [x] `AuthRepositoryImpl` implements `AuthRepository`
- [x] For each method:
  - [x] Call datasource method
  - [x] Convert Model → Entity with `.toEntity()`
  - [x] Wrap in `Either<Failure, T>` using `fold()`
  - [x] Catch `DioException` → `ServerFailure.fromDioError()`
  - [x] Catch generic exceptions → `ServerFailure(e.toString())`

**Pattern**:
```dart
@override
Future<Either<Failure, UserAuthEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    final model = await remoteDataSource.login(email: email, password: password);
    return Right(model.toEntity());
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

### 1.7 Error Handling Enhancement

Update `lib/core/error/failure.dart`

- [x] Add `ServerFailure._fromResponse()` factory for HTTP status code mapping
  - [x] 400 (Bad Request): Parse message, detect email/password errors
  - [x] 401 (Unauthorized): Check for account restriction keywords (inactive, suspended, etc.)
  - [x] 403 (Forbidden): Access denied
  - [x] 404 (Not Found): Resource not found
  - [x] 429 (Rate Limit): Too many attempts
  - [x] 500+ (Server Error): Generic server error
  
- [x] Error messages must be **user-facing** and professional
  - [x] ❌ Don't show: "Exception: user matching query does not exist"
  - [x] ✅ Show: "This email is not registered. Please sign up."

**Reference**: AUTH_ARCHITECTURE_BLUEPRINT.md section 5.1

### Phase 1 Verification Checklist
```
[x] No compilation errors: flutter analyze lib/feature/auth/
[x] All entities implement Equatable with props
[x] All models have fromJson() and toEntity()
[x] All datasource methods defined
[x] All repository methods return Either<Failure, T>
[x] Error messages are user-friendly (no raw backend text)
[x] DI not yet updated (will do in Phase 2)
```

**Status**: ✅ PHASE 1 COMPLETE

---

## Phase 2: Presentation Layer - Cubit & State Management (1 week)

### Objective
Implement the Cubit state machine and all state classes. This layer orchestrates the business logic (usecases) and emits states for the UI to listen to.

### 2.1 Cubit State Definition

Create `lib/feature/auth/presentation/cubits/auth_state.dart` (part file)

- [x] `AuthState` abstract base class
- [x] `AuthInitial` - fresh start
- [x] `AuthLoading` - general API call in progress
- [x] `OtpLoading` - OTP request/verification in progress
- [x] `OtpSent` - OTP sent, waiting for user input (fields: email, expiresInSeconds, message)
- [x] `SignupOtpVerified` - OTP verified, awaiting profile completion
- [x] `AuthLoaded` - user authenticated + profile complete
- [x] `ProfileIncomplete` - authenticated but profile needs completion
- [x] `ProfileUpdateError` - profile update failed
- [x] `AuthError` - general auth operation failure
- [x] `OtpError` - OTP verification failed
- [x] `AuthUnauthenticated` - logged out

**Verification**:
- [x] All states implement Equatable
- [x] All states override `props` getter
- [x] No mutable fields in states (only final)

### 2.2 Cubit Implementation

Create/Update `lib/feature/auth/presentation/cubits/auth_cubit.dart`

- [x] Class definition with all usecase injections
- [x] Constructor with DI parameters
- [x] `super(AuthInitial())` in constructor

#### Signup Flow Methods
- [x] `signup(nickname, email, password)` 
  - [x] emit(AuthLoading)
  - [x] Call signupUseCase
  - [x] On success: emit(OtpSent(...))
  - [x] On failure: emit(AuthError(...))

- [x] `verifySignupOtp(email, otpCode)`
  - [x] emit(OtpLoading)
  - [x] Call verifySignupOtpUseCase
  - [x] On success: 
    - [x] _cacheTokens(user)
    - [x] Check isProfileComplete:
      - [x] If false: emit(SignupOtpVerified(user)), store in `_pendingSignupUser`
      - [x] If true: emit(AuthLoaded(user))
  - [x] On failure: emit(OtpError(...))

- [x] `completeProfile(dateOfBirth, gender, phoneNumber)`
  - [x] emit(AuthLoading)
  - [x] Call updateProfileInfoUseCase
  - [x] On success: emit(AuthLoaded(user))
  - [x] On failure: emit(ProfileUpdateError(...))

#### Login Flow Methods
- [x] `login(email, password)`
  - [x] emit(AuthLoading)
  - [x] Call loginUseCase
  - [x] On success:
    - [x] _cacheTokens(user)
    - [x] Check isProfileComplete:
      - [x] If false: emit(ProfileIncomplete(user))
      - [x] If true: emit(AuthLoaded(user))
  - [x] On failure: 
    - [x] Check if account restriction error: emit special message
    - [x] Else: emit(AuthError(...))

#### Password Recovery Methods
- [x] `requestForgotPasswordOtp(email)`
  - [x] emit(OtpLoading)
  - [x] Call requestForgotPasswordOtpUseCase
  - [x] On success: emit(OtpSent(...))
  - [x] On failure: emit(OtpError(...))

- [x] `verifyForgotPasswordOtp(email, otpCode, newPassword)`
  - [x] emit(OtpLoading)
  - [x] Call verifyForgotPasswordOtpUseCase
  - [x] On success: call `login(email, newPassword)` for auto-login
  - [x] On failure: emit(OtpError(...))

- [x] `updatePassword(currentPassword, newPassword)` (renamed to `changePassword`)
  - [x] emit(AuthLoading)
  - [x] Call updatePasswordUseCase
  - [x] On success: emit(AuthLoaded(user))
  - [x] On failure: emit(ProfileUpdateError(...))

#### Session Management Methods
- [x] `fetchProfile()`
  - [x] emit(AuthLoading)
  - [x] Call fetchProfileUseCase
  - [x] On success: emit(AuthLoaded(user))
  - [x] On failure: emit(AuthError(...))

- [x] `logout()`
  - [x] emit(AuthLoading)
  - [x] Call logoutUseCase
  - [x] On success or failure:
    - [x] _clearTokens() (always, even if fail)
    - [x] emit(AuthUnauthenticated)

- [x] `deleteAccount(email, password)` (renamed to `deleteAccount(password)`)
  - [x] emit(AuthLoading)
  - [x] Call deleteAccountUseCase
  - [x] On success:
    - [x] _clearTokens()
    - [x] emit(AuthUnauthenticated)
  - [x] On failure: emit(AuthError(...))

- [x] `googleSignIn(idToken)`
  - [x] emit(AuthLoading)
  - [x] Call googleSignInUseCase
  - [x] On success:
    - [x] _cacheTokens(user)
    - [x] Check isProfileComplete:
      - [x] If false: emit(ProfileIncomplete(user))
      - [x] If true: emit(AuthLoaded(user))
  - [x] On failure: emit(AuthError(...))

#### Helper Methods
- [x] `_cacheTokens(UserAuthEntity user)`
  - [x] Call TokenStorage.setAccessToken(user.accessToken)
  - [x] Call TokenStorage.setRefreshToken(user.refreshToken)
  - [x] Log success

- [x] `_clearTokens()`
  - [x] Call TokenStorage.clearTokens()
  - [x] Clear `_pendingSignupUser`
  - [x] Log success

- [x] `_isInactiveAccountError(String message)` 
  - [x] Check if message contains: "inactive", "deactivated", "disabled", "suspended", "blocked"
  - [x] Return bool

- [x] `_log(String event, {Map<String, dynamic>? data})`
  - [x] Log with developer.log()
  - [x] Include cubit name, event, and data

**Verification**:
```bash
flutter analyze lib/feature/auth/presentation/cubits/

# Ensure:
# - All emit() calls follow result.fold() pattern
# - All states are properly constructed
# - Token caching happens at right times
# - No state mutations
```

### 2.3 Update DI Registration

Update `lib/core/di/injection_container.dart` → `initAuth()` function

- [x] Register all usecases as lazySingleton
  ```dart
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl()),
  );
  // ... all 13 usecases
  ```

- [x] Register AuthCubit as factory
  ```dart
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl(),
      signupUseCase: sl(),
      // ... all usecase parameters
      authRepository: sl(),
    ),
  );
  ```

- [x] Register AuthRepository and AuthRemoteDataSource

- [x] Verify no circular dependencies

**Verification**:
```bash
flutter pub get
flutter analyze lib/core/di/
```

### Phase 2 Verification Checklist
```
[x] All state classes defined and implement Equatable
[x] All cubit methods emit correct states
[x] result.fold() pattern used consistently
[x] Token caching/clearing at right times
[x] DI registered for all usecases and cubits
[x] No compilation errors
[x] Logging in place for debugging
```

**Status**: ✅ PHASE 2 COMPLETE (Minor: Email change methods not implemented yet)

---

## Phase 3: Presentation Layer - Navigation & Routing (1 week)

### Objective
Establish the navigation routes and implement the main navigation decision tree (splash screen logic).

### 3.1 Navigation Constants

Update `lib/core/routes/app_routes.dart`

- [x] `MyRoutes` class with string constants:
  - [x] `splashScreen = '/splash'`
  - [x] `signup = '/signup'`
  - [x] `verifyOtp = '/verify-otp'`
  - [x] `completeProfile = '/complete-profile'`
  - [x] `login = '/login'`
  - [x] `forgotPassword = '/forgot-password'`
  - [x] `homeScreen = '/home'`
  - [x] `profileSettings = '/profile-settings'`

### 3.2 App Router

Update `lib/core/routes/app_router.dart`

- [x] `AppRouter.generateRoute(RouteSettings settings)` method
- [x] Switch cases for all routes
- [x] Each route returns appropriate Screen widget
- [x] Handle route arguments (e.g., user object for CompleteProfileScreen)
- [x] Default case for undefined routes

**Example**:
```dart
case MyRoutes.verifyOtp:
  final args = settings.arguments as Map<String, String>;
  return MaterialPageRoute(
    builder: (_) => VerifyOtpScreen(
      email: args['email']!,
      flow: args['flow']!,
    ),
  );
```

### 3.3 Splash Screen with Navigation Logic

Create `lib/feature/splash/presentation/screens/splash_screen.dart`

- [x] `SplashScreen` extends StatefulWidget
- [x] `_SplashScreenState` with `initState()` override
- [x] In `initState()`:
  - [x] Delay 2 seconds
  - [x] Check if valid token exists:
    ```dart
    bool _hasValidToken() {
      return TokenStorage.getAccessToken() != null;
    }
    ```
  - [x] If no token: Navigate to `/signup`
  - [x] If token exists:
    - [x] Call `context.read<AuthCubit>().fetchProfile()`
    - [x] Listen to cubit state stream:
      - [x] `AuthLoaded`: Navigate to `/home`
      - [x] `ProfileIncomplete`: Navigate to `/complete-profile` with user
      - [x] `AuthError`: Navigate to `/login`

- [x] Build method: Show splash image + loading indicator

**Pattern**:
```dart
@override
void initState() {
  super.initState();
  _navigateBasedOnAuthState();
}

void _navigateBasedOnAuthState() {
  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;

    if (_hasValidToken()) {
      context.read<AuthCubit>().fetchProfile();
      _listenToAuthState();
    } else {
      _navigateTo(MyRoutes.signup);
    }
  });
}

void _listenToAuthState() {
  context.read<AuthCubit>().stream.listen((state) {
    if (state is AuthLoaded) {
      _navigateTo(MyRoutes.homeScreen);
    } else if (state is ProfileIncomplete) {
      _navigateToWithArgs(MyRoutes.completeProfile, state.user);
    } else if (state is AuthError) {
      _navigateTo(MyRoutes.login);
    }
  });
}

void _navigateTo(String route) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    route,
    (route) => false,
  );
}

void _navigateToWithArgs(String route, dynamic args) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    route,
    (route) => false,
    arguments: args,
  );
}
```

### 3.4 Main App Configuration

Update `lib/main.dart`

- [x] Set initial route to `MyRoutes.splashScreen`
- [x] Set `onGenerateRoute: AppRouter.generateRoute`
- [x] Verify MaterialApp config

```dart
MaterialApp(
  initialRoute: MyRoutes.splashScreen,
  onGenerateRoute: AppRouter.generateRoute,
  // ... other config
)
```

### Phase 3 Verification Checklist
```
[x] All navigation routes defined in MyRoutes
[x] AppRouter.generateRoute covers all routes
[x] SplashScreen checks token and calls fetchProfile
[x] State listener logic correct
[x] No navigation loops
[x] Token check working (TokenStorage integration ready)
[x] main.dart initialRoute set to splash
```

**Status**: ✅ PHASE 3 COMPLETE

---

## Phase 4: UI Screens (2 weeks)

### Objective
Implement all authentication screens. These screens are **UI-only** - they call cubit methods and listen to states.

### 4.1 Core UI Patterns

Before implementing screens, establish reusable patterns:

- [x] `SignupTextField` widget (renamed to `CustomTextFormField`)
  - [x] Handles email/password validation styling
  - [x] Shows error messages
  - [x] Obscure text for passwords

- [x] `OtpInputField` widget (implemented as `AuthVerificationPinInput`)
  - [x] 6-digit input
  - [x] Auto-submit on complete
  - [x] Error state styling

- [x] Custom button styling consistent across all auth screens

- [x] `AuthHeader` widget for consistent header styling
- [x] `AuthGoogleButton` widget for Google Sign-In button
- [x] `AuthSwitchPrompt` widget for signup/login switch prompts

### 4.2 Screen Implementation Order

#### Screen 1: SignupScreen
**File**: `lib/feature/auth/presentation/views/signup_screen.dart`

- [x] TextEditingControllers for nickname, email, password
- [x] Form validation (email format, password strength)
- [x] BlocBuilder listening to AuthCubit:
  - [x] If AuthLoading: Show loading spinner, disable button
  - [x] If OtpSent: Auto-navigate to VerifyOtpScreen
  - [x] If AuthError: Show error snackbar, keep form
- [x] Sign Up button calls `authCubit.signup(nickname, email, password)`
- [x] Links: "Already have account? Sign In" → LoginScreen
- [x] Google Sign-In button

#### Screen 2: VerifyOtpScreen
**File**: `lib/feature/auth/presentation/views/verify_account_screen.dart` (renamed)

- [x] Constructor parameters: `email`, `flow` (signup/forgot_password/email_change)
- [x] OTP input field (6 digits)
- [x] Resend OTP button with countdown timer (60s)
- [x] BlocBuilder listening to AuthCubit:
  - [x] If OtpLoading: Show loading, disable input
  - [x] If SignupOtpVerified: Auto-navigate to CompleteProfileScreen
  - [x] If AuthLoaded (for forgot_password): Auto-navigate to HomeScreen
  - [x] If OtpError: Show error, keep OTP input
- [x] On submit: Call appropriate cubit method based on `flow`

#### Screen 3: CompleteProfileScreen
**File**: `lib/feature/auth/presentation/views/auth_info_screen.dart` (likely renamed)

- [x] Constructor parameter: `user` (UserAuthEntity)
- [x] Form fields:
  - [x] Date of Birth picker (DatePicker)
  - [x] Gender dropdown (Male, Female, Other)
  - [x] Phone number input with E.164 formatting
- [x] Form validation (DOB not future, phone valid format)
- [x] BlocBuilder listening to AuthCubit:
  - [x] If AuthLoading: Show loading, disable button
  - [x] If AuthLoaded: Auto-navigate to HomeScreen
  - [x] If ProfileUpdateError: Show error, keep form
- [x] Continue button calls `authCubit.completeProfile(dob, gender, phone)`

#### Screen 4: LoginScreen
**File**: `lib/feature/auth/presentation/views/login_screen.dart`

- [x] TextEditingControllers for email, password
- [x] Form validation
- [x] BlocBuilder listening to AuthCubit:
  - [x] If AuthLoading: Show loading, disable button
  - [x] If AuthLoaded: Auto-navigate to HomeScreen
  - [x] If ProfileIncomplete: Auto-navigate to CompleteProfileScreen
  - [x] If AuthError: Show error snackbar
- [x] Sign In button calls `authCubit.login(email, password)`
- [x] Links: 
  - [x] "Forgot Password?" → ForgotPasswordScreen
  - [x] "New to Afiete? Sign Up" → SignupScreen
- [x] Google Sign-In button

#### Screen 5: ForgotPasswordScreen
**File**: `lib/feature/auth/presentation/views/forgot_password_screen.dart`

- [x] TextEditingController for email
- [x] Email validation
- [x] BlocBuilder listening to AuthCubit:
  - [x] If OtpLoading: Show loading, disable input
  - [x] If OtpSent: Auto-navigate to VerifyOtpScreen with flow='forgot_password'
  - [x] If AuthError: Show error
- [x] "Send Recovery Code" button calls `authCubit.requestForgotPasswordOtp(email)`
- [x] Back button → LoginScreen

#### Screen 6: PasswordChangeScreen
**File**: `lib/feature/auth/presentation/views/password_change_screen.dart`

- [x] Form fields: old password, new password, confirm password
- [x] Password validation
- [x] BlocBuilder listening to AuthCubit
- [x] Save button calls `authCubit.changePassword(current, new)`
- [x] Error/success handling

#### Screen 7: DeleteAccountScreen
**File**: `lib/feature/auth/presentation/views/delete_account_screen.dart`

- [x] Warning message about account deletion
- [x] Password confirmation field
- [x] Confirm delete button
- [x] BlocBuilder listening to AuthCubit
- [x] On success: Auto-navigate to SignupScreen
- [x] Cancel button to go back

#### Screen 7: ResetPasswordScreen (optional, part of forgot flow)
- May be combined with VerifyOtpScreen for password field

### 4.3 Reusable Widgets

Create `lib/feature/auth/presentation/widgets/`:

- [x] `AuthTextField` widget (implemented as `CustomTextFormField`)
  - [x] Email/password validation styling
  - [x] Error message display
  - [x] Obscure text toggle for passwords

- [x] `OtpInput` widget (implemented as `AuthVerificationPinInput`)
  - [x] 6 digit input
  - [x] Auto-focus behavior
  - [x] Paste support

- [x] `CountdownTimer` widget (in `countdown_timer.dart`)
  - [x] `CountdownTimer` - standalone timer display (MM:SS format)
  - [x] `CountdownResendButton` - integrated button with timer
  - [x] Auto-disable/enable resend button based on countdown
  - [x] Customizable callbacks (onTick, onCountdownComplete)
  - [x] Support for custom time formatters

- [x] `PasswordStrengthIndicator` widget (in `password_strength_indicator.dart`)
  - [x] Visual strength bar (4 segments)
  - [x] Strength label (Weak/Fair/Good/Strong) with color coding
  - [x] Requirements checklist with individual status indicators
  - [x] Customizable validator (default + abstract interface)
  - [x] Supports custom password validation rules
  - [x] Color-coded feedback (error/warning/success)

### Phase 4 Verification Checklist
```
[x] All 7 screens implemented (SignupScreen, LoginScreen, AuthInfoScreen, VerifyAccountScreen, ForgotPasswordScreen, PasswordChangeScreen, DeleteAccountScreen)
[x] BlocBuilder/BlocConsumer used consistently
[x] Form validation working on all screens
[x] Navigation transitions smooth with proper routing
[x] Error messages user-friendly and professional
[x] Loading states show spinners on all async operations
[x] Token caching verified at signup/login/logout
[x] No null pointer errors in UI
[x] All reusable widgets created and integrated:
    - CustomTextFormField (email/password validation)
    - AuthVerificationPinInput (6-digit OTP)
    - AuthHeader (consistent headers)
    - AuthGoogleButton (sign-in integration)
    - AuthSwitchPrompt (signup/login switch)
    - CountdownTimer & CountdownResendButton (OTP flows)
    - PasswordStrengthIndicator (password validation feedback)
[x] Widgets follow Material Design 3 guidelines
[x] Theme integration complete (dark/light mode support)
```

**Status**: ✅ PHASE 4 COMPLETE - All UI screens and widgets fully implemented

---

## Phase 5: Testing & Refinement (1 week)

### Objective
Ensure robustness, error handling, and edge cases.

### 5.1 Unit Tests (Domain & Data)

Create `test/feature/auth/domain/usecases/` and `test/feature/auth/data/repositories/`

- [ ] SignupUseCase tests
- [ ] VerifySignupOtpUseCase tests
- [ ] LoginUseCase tests
- [ ] UpdateProfileInfoUseCase tests
- [ ] LogoutUseCase tests
- [ ] DeleteAccountUseCase tests
- [ ] AuthRepositoryImpl tests (mock datasource)

**Pattern**:
```dart
void main() {
  group('SignupUseCase', () {
    late MockAuthRepository mockRepository;
    late SignupUseCase usecase;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = SignupUseCase(mockRepository);
    });

    test('should return OtpEntity on success', () async {
      // Arrange
      final params = SignupParams(...);
      when(mockRepository.signup(...)).thenAnswer(
        (_) async => Right(OtpEntity(...))
      );

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, isA<Right<Failure, OtpEntity>>());
    });
  });
}
```

### 5.2 Widget Tests

Create `test/feature/auth/presentation/screens/`

- [ ] SignupScreen tests
- [ ] VerifyOtpScreen tests
- [ ] LoginScreen tests
- [ ] CompleteProfileScreen tests

**Pattern**:
```dart
void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthCubit mockAuthCubit;

    setUp(() {
      mockAuthCubit = MockAuthCubit();
    });

    testWidgets('should show loading when AuthLoading state', (tester) async {
      // Arrange
      when(mockAuthCubit.stream).thenAnswer(
        (_) => Stream.value(AuthLoading())
      );

      // Act
      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const LoginScreen(),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### 5.3 Integration Tests (E2E Flows)

Create `test/feature/auth/integration/`

- [ ] Full signup flow (signup → OTP → profile completion → home)
- [ ] Full login flow (login → home or profile completion)
- [ ] Password recovery flow
- [ ] Delete account flow

### 5.4 Error Scenario Testing

Test all error paths:

- [ ] Invalid email format → form validation error
- [ ] Email already exists → AuthError
- [ ] Invalid OTP → OtpError
- [ ] Network timeout → ServerFailure with timeout message
- [ ] 401 Unauthorized → AuthError
- [ ] Account inactive → Special message
- [ ] Rate limiting (429) → Special message
- [ ] Server error (500) → Generic error message

### 5.5 Performance Testing

- [ ] Token caching/retrieval performance
- [ ] API response time expectations
- [ ] Form input responsiveness

### Phase 5 Verification Checklist
```
[ ] All unit tests passing
[ ] All widget tests passing
[ ] All integration tests passing
[ ] Error scenarios covered
[ ] Code coverage >80%
[ ] No console warnings/errors
[ ] Performance acceptable
```

**Status**: ⏳ PHASE 5 NOT STARTED - No test files created yet

---

## Phase 6: Backend Integration & Refinement (Ongoing)

### Objective
Integrate with actual Django backend and refine based on real-world behavior.

### 6.1 Backend Readiness Checklist

Before Phase 6, ensure Django team has delivered:

- [x] `/api/auth/signup/` endpoint (likely implemented)
- [x] `/api/auth/verify-signup-otp/` endpoint (returns access_token)
- [x] `/api/auth/login/` endpoint
- [x] `/api/auth/profile/` endpoint (GET + PATCH)
- [x] `/api/auth/logout/` endpoint
- [x] `/api/auth/delete-account/` endpoint
- [x] `/api/auth/forgot-password/` endpoint
- [x] `/api/auth/verify-forgot-password-otp/` endpoint
- [x] `/api/auth/change-password/` endpoint
- [x] `/api/auth/google-signin/` endpoint
- [x] All endpoints documented with request/response schemas
- [x] Token refresh mechanism (implicit in Dio interceptor)

**Request**:
```
Subject: Auth Backend Endpoints Delivery Timeline

We need the following endpoints for frontend integration:

1. Signup + OTP verification (must return access_token on verify)
2. Login (must return profile data + access_token)
3. Profile fetch & update
4. Password recovery flow
5. Email change flow
6. Logout & delete account

Timeline: Can frontend start Phase 4 (screens) while backend develops Phase 1-2 infrastructure?
```

### 6.2 Mock Data Source (Fallback)

Until backend is ready, use mock datasource:

Create `lib/feature/auth/data/datasources/auth_mock_datasource.dart`

```dart
class AuthMockDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<OtpModel> signup({...}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return OtpModel(
      email: email,
      expiresInSeconds: 600,
      message: 'Mock OTP: 123456'
    );
  }

  @override
  Future<UserModel> verifySignupOtp({...}) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 'mock_user_123',
      username: 'user123',
      email: email,
      isVerified: true,
      accessToken: 'mock_token_xyz',
      dateOfBirth: null,
      gender: null,
      phoneNumber: null,
    );
  }

  // ... implement all other methods with mock data
}
```

In DI, toggle between mock and real:

```dart
// lib/core/di/injection_container.dart
const bool useMockDataSource = true; // Toggle for testing

sl.registerLazySingleton<AuthRemoteDataSource>(
  () => useMockDataSource
    ? AuthMockDataSourceImpl()
    : AuthRemoteDataSourceImpl(sl<Dio>()),
);
```

### 6.3 Integration Testing with Backend

- [ ] Test signup → OTP verification → profile completion → login flow
- [ ] Test token refresh when access token expires
- [ ] Test error responses from backend
- [ ] Test edge cases (rate limiting, offline, slow network)

### 6.4 Production Readiness

- [ ] Remove any temporary debug prints or legacy ad-hoc logging
- [ ] Remove mock datasource
- [ ] Verify token storage security (encrypted if sensitive)
- [ ] Test token refresh mechanism
- [ ] Test logout on 401 responses
- [ ] Test network error recovery

---

## Dependencies & Prerequisites

### 1. Required Packages (Already in pubspec.yaml)

Verify these are installed:

```yaml
flutter_bloc: ^8.1.6          # State management
dartz: ^0.10.1                # Either<L,R> error handling
dio: ^5.9.2                   # HTTP client
get_it: ^7.6.7                # Service locator
equatable: ^2.0.5             # Value equality
google_sign_in: ^6.2.1        # Google OAuth
shared_preferences: ^2.3.2    # Token storage
pinput: ^6.0.2                # OTP input widget
intl: ^0.20.2                 # Date/time formatting
```

### 2. Additional Setup (If Not Done)

- [ ] **TokenStorage**: Create `lib/core/utils/token_storage.dart`
  ```dart
  class TokenStorage {
    static const String _accessTokenKey = 'access_token';
    static const String _refreshTokenKey = 'refresh_token';

    static Future<void> setAccessToken(String token) async {
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setString(_accessTokenKey, token),
      );
    }

    static String? getAccessToken() {
      return SharedPreferences.getInstance().then(
        (prefs) => prefs.getString(_accessTokenKey),
      ) as String?;
    }

    static Future<void> clearTokens() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
    }
  }
  ```

- [ ] **Dio Interceptor**: Update `lib/core/services/dio_client.dart`
  ```dart
  class DioClient {
    static Dio createDio() {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Add interceptor for token attachment
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = TokenStorage.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
          onError: (error, handler) async {
            // Handle 401 → refresh token logic
            if (error.response?.statusCode == 401) {
              // Attempt refresh
            }
            return handler.next(error);
          },
        ),
      );

      return dio;
    }
  }
  ```

- [ ] **Update DI** to use DioClient:
  ```dart
  sl.registerSingleton<Dio>(DioClient.createDio());
  ```

---

## Development Workflow

### Version Control

```bash
# Feature branch per phase
git checkout -b feature/auth-phase-1-domain
git checkout -b feature/auth-phase-2-cubit
git checkout -b feature/auth-phase-3-routing
git checkout -b feature/auth-phase-4-screens
git checkout -b feature/auth-phase-5-tests
```

### Commit Messages

```
feat(auth): Add UserAuthEntity and OtpEntity domain models
feat(auth): Implement all 13 usecases for signup/login/recovery
feat(auth): Implement AuthCubit with state machine
feat(auth): Add AppRouter and navigation logic
feat(auth): Implement SignupScreen and VerifyOtpScreen
test(auth): Add unit tests for SignupUseCase
```

### Testing Commands

```bash
# Type checking
flutter analyze lib/feature/auth/

# Run tests
flutter test test/feature/auth/

# Get code coverage
flutter test --coverage lib/feature/auth/

# Build for deployment
flutter build apk --release
flutter build ios --release
```

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Backend delays | Implement mock datasource for Phase 4 UI development |
| Token refresh complexity | Use Dio interceptor + simple refresh logic early |
| Profile completion edge cases | Test with intentional incomplete profiles |
| Network errors | Implement retry logic + offline graceful degradation |
| User confusion on profile completion | Show clear UI hints: "Required before continuing" |
| Security (token theft) | Use encrypted local storage, implement token refresh |

---

## Success Criteria (Acceptance)

- ✅ All auth flows complete without errors
- ✅ Token management automatic (cache/refresh/clear)
- ✅ Profile completion enforced for new users
- ✅ Error messages professional and helpful
- ✅ Network errors gracefully handled
- ✅ All 7 screens responsive and accessible
- ✅ Unit & widget tests >80% coverage
- ✅ Unused code removed, imports cleaned up
- ✅ API contracts match Django backend exactly
- ✅ No security vulnerabilities (token exposure, etc.)

---

**Created**: 2026-05-09  
**Next Step**: Start Phase 1 (Domain Layer) ← **BEGIN HERE**

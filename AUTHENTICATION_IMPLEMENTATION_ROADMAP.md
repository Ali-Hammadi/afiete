# Authentication Feature - Implementation Roadmap & Checklist

**Status**: Ready for Phase 1 Implementation  
**Timeline**: 4-6 weeks (with Django backend parallel development)  
**Team Capability**: Solo Flutter developer + Django backend team  

---

## Phase 1: Domain Layer & Data Contracts (1-2 weeks)

### Objective
Establish the business logic layer (entities, repositories, usecases) and data contracts. This layer should be **backend-agnostic** - ready to work whenever the Django API is ready.

### 1.1 Domain - Entities

- [ ] Create `lib/feature/auth/domain/entities/auth_user_entity.dart`
  - [ ] `UserAuthEntity` class with all fields (id, username, nickname, email, DOB, gender, phone, isVerified, accessToken, refreshToken)
  - [ ] Implement `isProfileComplete` getter
  - [ ] Add Equatable props

- [ ] Create `lib/feature/auth/domain/entities/otp_entity.dart`
  - [ ] `OtpEntity` class (email, expiresInSeconds, message)

### 1.2 Domain - Repository Interface

- [ ] Create `lib/feature/auth/domain/repositories/auth_repository.dart`
  - [ ] Define abstract methods for all auth operations
  - [ ] Return types: `Future<Either<Failure, T>>`
  - [ ] Methods: signup, verifySignupOtp, login, updateProfileInfo, logout, deleteAccount, etc.

### 1.3 Domain - Use Cases

Create `lib/feature/auth/domain/usecase/` with one file per usecase:

- [ ] `signup_usecase.dart` → SignupUseCase + SignupParams
- [ ] `verify_signup_otp_usecase.dart` → VerifySignupOtpUseCase + VerifySignupOtpParams
- [ ] `login_usecase.dart` → LoginUseCase + LoginParams
- [ ] `fetch_profile_usecase.dart` → FetchProfileUseCase + NoParams
- [ ] `update_profile_info_usecase.dart` → UpdateProfileInfoUseCase + UpdateProfileParams
- [ ] `logout_usecase.dart` → LogoutUseCase + NoParams
- [ ] `delete_account_usecase.dart` → DeleteAccountUseCase + DeleteAccountParams
- [ ] `google_signin_usecase.dart` → GoogleSignInUseCase + GoogleSignInParams
- [ ] `request_forgot_password_otp_usecase.dart` → RequestForgotPasswordOtpUseCase + ForgotPasswordParams
- [ ] `verify_forgot_password_otp_usecase.dart` → VerifyForgotPasswordOtpUseCase + VerifyForgotPasswordOtpParams
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

- [ ] `user_model.dart`
  - [ ] UserModel class with all UserAuthEntity fields
  - [ ] `fromJson()` factory (handle both snake_case & camelCase)
  - [ ] `toEntity()` conversion method
  - [ ] Equatable implementation

- [ ] `otp_model.dart`
  - [ ] OtpModel class
  - [ ] `fromJson()` factory
  - [ ] `toEntity()` conversion method

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

- [ ] `AuthRemoteDataSource` abstract class with all method signatures
- [ ] `AuthRemoteDataSourceImpl` implementation class
  - [ ] Inject Dio instance (from DI)
  - [ ] Implement all methods
  - [ ] Use try-catch for DioException handling
  - [ ] Parse response data → Models

**Key Implementation Notes**:
- Base URL: `/api/auth/` (configured in Dio BaseOptions)
- All endpoints return models via `.fromJson(response.data)`
- No error handling here - just rethrow DioException
- Handle both direct response and wrapped response (`response.data['user']`)

### 1.6 Data - Repository Implementation

Create `lib/feature/auth/data/repositories/auth_repository_impl.dart`

- [ ] `AuthRepositoryImpl` implements `AuthRepository`
- [ ] For each method:
  - [ ] Call datasource method
  - [ ] Convert Model → Entity with `.toEntity()`
  - [ ] Wrap in `Either<Failure, T>` using `fold()`
  - [ ] Catch `DioException` → `ServerFailure.fromDioError()`
  - [ ] Catch generic exceptions → `ServerFailure(e.toString())`

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

- [ ] Add `ServerFailure._fromResponse()` factory for HTTP status code mapping
  - [ ] 400 (Bad Request): Parse message, detect email/password errors
  - [ ] 401 (Unauthorized): Check for account restriction keywords (inactive, suspended, etc.)
  - [ ] 403 (Forbidden): Access denied
  - [ ] 404 (Not Found): Resource not found
  - [ ] 429 (Rate Limit): Too many attempts
  - [ ] 500+ (Server Error): Generic server error
  
- [ ] Error messages must be **user-facing** and professional
  - [ ] ❌ Don't show: "Exception: user matching query does not exist"
  - [ ] ✅ Show: "This email is not registered. Please sign up."

**Reference**: AUTH_ARCHITECTURE_BLUEPRINT.md section 5.1

### Phase 1 Verification Checklist
```
[ ] No compilation errors: flutter analyze lib/feature/auth/
[ ] All entities implement Equatable with props
[ ] All models have fromJson() and toEntity()
[ ] All datasource methods defined
[ ] All repository methods return Either<Failure, T>
[ ] Error messages are user-friendly (no raw backend text)
[ ] DI not yet updated (will do in Phase 2)
```

---

## Phase 2: Presentation Layer - Cubit & State Management (1 week)

### Objective
Implement the Cubit state machine and all state classes. This layer orchestrates the business logic (usecases) and emits states for the UI to listen to.

### 2.1 Cubit State Definition

Create `lib/feature/auth/presentation/cubits/auth_state.dart` (part file)

- [ ] `AuthState` abstract base class
- [ ] `AuthInitial` - fresh start
- [ ] `AuthLoading` - general API call in progress
- [ ] `OtpLoading` - OTP request/verification in progress
- [ ] `OtpSent` - OTP sent, waiting for user input (fields: email, expiresInSeconds, message)
- [ ] `SignupOtpVerified` - OTP verified, awaiting profile completion
- [ ] `AuthLoaded` - user authenticated + profile complete
- [ ] `ProfileIncomplete` - authenticated but profile needs completion
- [ ] `ProfileUpdateError` - profile update failed
- [ ] `AuthError` - general auth operation failure
- [ ] `OtpError` - OTP verification failed
- [ ] `AuthUnauthenticated` - logged out

**Verification**:
- [ ] All states implement Equatable
- [ ] All states override `props` getter
- [ ] No mutable fields in states (only final)

### 2.2 Cubit Implementation

Create/Update `lib/feature/auth/presentation/cubits/auth_cubit.dart`

- [ ] Class definition with all usecase injections
- [ ] Constructor with DI parameters
- [ ] `super(AuthInitial())` in constructor

#### Signup Flow Methods
- [ ] `signup(nickname, email, password)` 
  - [ ] emit(AuthLoading)
  - [ ] Call signupUseCase
  - [ ] On success: emit(OtpSent(...))
  - [ ] On failure: emit(AuthError(...))

- [ ] `verifySignupOtp(email, otpCode)`
  - [ ] emit(OtpLoading)
  - [ ] Call verifySignupOtpUseCase
  - [ ] On success: 
    - [ ] _cacheTokens(user)
    - [ ] Check isProfileComplete:
      - [ ] If false: emit(SignupOtpVerified(user)), store in `_pendingSignupUser`
      - [ ] If true: emit(AuthLoaded(user))
  - [ ] On failure: emit(OtpError(...))

- [ ] `completeProfile(dateOfBirth, gender, phoneNumber)`
  - [ ] emit(AuthLoading)
  - [ ] Call updateProfileInfoUseCase
  - [ ] On success: emit(AuthLoaded(user))
  - [ ] On failure: emit(ProfileUpdateError(...))

#### Login Flow Methods
- [ ] `login(email, password)`
  - [ ] emit(AuthLoading)
  - [ ] Call loginUseCase
  - [ ] On success:
    - [ ] _cacheTokens(user)
    - [ ] Check isProfileComplete:
      - [ ] If false: emit(ProfileIncomplete(user))
      - [ ] If true: emit(AuthLoaded(user))
  - [ ] On failure: 
    - [ ] Check if account restriction error: emit special message
    - [ ] Else: emit(AuthError(...))

#### Password Recovery Methods
- [ ] `requestForgotPasswordOtp(email)`
  - [ ] emit(OtpLoading)
  - [ ] Call requestForgotPasswordOtpUseCase
  - [ ] On success: emit(OtpSent(...))
  - [ ] On failure: emit(OtpError(...))

- [ ] `verifyForgotPasswordOtp(email, otpCode, newPassword)`
  - [ ] emit(OtpLoading)
  - [ ] Call verifyForgotPasswordOtpUseCase
  - [ ] On success: call `login(email, newPassword)` for auto-login
  - [ ] On failure: emit(OtpError(...))

- [ ] `updatePassword(currentPassword, newPassword)`
  - [ ] emit(AuthLoading)
  - [ ] Call updatePasswordUseCase
  - [ ] On success: emit(AuthLoaded(user))
  - [ ] On failure: emit(ProfileUpdateError(...))

#### Email Change Methods
- [ ] `requestEmailChange()`
  - [ ] emit(OtpLoading)
  - [ ] Call requestEmailChangeOtpUseCase
  - [ ] On success: emit(OtpSent(...))
  - [ ] On failure: emit(OtpError(...))

- [ ] `confirmEmailChange(newEmail, otpCode)`
  - [ ] emit(AuthLoading)
  - [ ] Call confirmEmailChangeUseCase
  - [ ] On success: Call fetchProfile() to refresh
  - [ ] On failure: emit(ProfileUpdateError(...))

#### Session Management Methods
- [ ] `fetchProfile()`
  - [ ] emit(AuthLoading)
  - [ ] Call fetchProfileUseCase
  - [ ] On success: emit(AuthLoaded(user))
  - [ ] On failure: emit(AuthError(...))

- [ ] `logout()`
  - [ ] emit(AuthLoading)
  - [ ] Call logoutUseCase
  - [ ] On success or failure:
    - [ ] _clearTokens() (always, even if fail)
    - [ ] emit(AuthUnauthenticated)

- [ ] `deleteAccount(email, password)`
  - [ ] emit(AuthLoading)
  - [ ] Call deleteAccountUseCase
  - [ ] On success:
    - [ ] _clearTokens()
    - [ ] emit(AuthUnauthenticated)
  - [ ] On failure: emit(AuthError(...))

- [ ] `googleSignIn(idToken)`
  - [ ] emit(AuthLoading)
  - [ ] Call googleSignInUseCase
  - [ ] On success:
    - [ ] _cacheTokens(user)
    - [ ] Check isProfileComplete:
      - [ ] If false: emit(ProfileIncomplete(user))
      - [ ] If true: emit(AuthLoaded(user))
  - [ ] On failure: emit(AuthError(...))

#### Helper Methods
- [ ] `_cacheTokens(UserAuthEntity user)`
  - [ ] Call TokenStorage.setAccessToken(user.accessToken)
  - [ ] Call TokenStorage.setRefreshToken(user.refreshToken)
  - [ ] Log success

- [ ] `_clearTokens()`
  - [ ] Call TokenStorage.clearTokens()
  - [ ] Clear `_pendingSignupUser`
  - [ ] Log success

- [ ] `_isInactiveAccountError(String message)` 
  - [ ] Check if message contains: "inactive", "deactivated", "disabled", "suspended", "blocked"
  - [ ] Return bool

- [ ] `_log(String event, {Map<String, dynamic>? data})`
  - [ ] Log with developer.log()
  - [ ] Include cubit name, event, and data

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

- [ ] Register all usecases as lazySingleton
  ```dart
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl()),
  );
  // ... all 13 usecases
  ```

- [ ] Register AuthCubit as factory
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

- [ ] Register AuthRepository and AuthRemoteDataSource

- [ ] Verify no circular dependencies

**Verification**:
```bash
flutter pub get
flutter analyze lib/core/di/
```

### Phase 2 Verification Checklist
```
[ ] All state classes defined and implement Equatable
[ ] All cubit methods emit correct states
[ ] result.fold() pattern used consistently
[ ] Token caching/clearing at right times
[ ] DI registered for all usecases and cubits
[ ] No compilation errors
[ ] Logging in place for debugging
```

---

## Phase 3: Presentation Layer - Navigation & Routing (1 week)

### Objective
Establish the navigation routes and implement the main navigation decision tree (splash screen logic).

### 3.1 Navigation Constants

Update `lib/core/routes/app_routes.dart`

- [ ] `MyRoutes` class with string constants:
  - [ ] `splashScreen = '/splash'`
  - [ ] `signup = '/signup'`
  - [ ] `verifyOtp = '/verify-otp'`
  - [ ] `completeProfile = '/complete-profile'`
  - [ ] `login = '/login'`
  - [ ] `forgotPassword = '/forgot-password'`
  - [ ] `homeScreen = '/home'`
  - [ ] `profileSettings = '/profile-settings'`

### 3.2 App Router

Update `lib/core/routes/app_router.dart`

- [ ] `AppRouter.generateRoute(RouteSettings settings)` method
- [ ] Switch cases for all routes
- [ ] Each route returns appropriate Screen widget
- [ ] Handle route arguments (e.g., user object for CompleteProfileScreen)
- [ ] Default case for undefined routes

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

- [ ] `SplashScreen` extends StatefulWidget
- [ ] `_SplashScreenState` with `initState()` override
- [ ] In `initState()`:
  - [ ] Delay 2 seconds
  - [ ] Check if valid token exists:
    ```dart
    bool _hasValidToken() {
      return TokenStorage.getAccessToken() != null;
    }
    ```
  - [ ] If no token: Navigate to `/signup`
  - [ ] If token exists:
    - [ ] Call `context.read<AuthCubit>().fetchProfile()`
    - [ ] Listen to cubit state stream:
      - [ ] `AuthLoaded`: Navigate to `/home`
      - [ ] `ProfileIncomplete`: Navigate to `/complete-profile` with user
      - [ ] `AuthError`: Navigate to `/login`

- [ ] Build method: Show splash image + loading indicator

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

- [ ] Set initial route to `MyRoutes.splashScreen`
- [ ] Set `onGenerateRoute: AppRouter.generateRoute`
- [ ] Verify MaterialApp config

```dart
MaterialApp(
  initialRoute: MyRoutes.splashScreen,
  onGenerateRoute: AppRouter.generateRoute,
  // ... other config
)
```

### Phase 3 Verification Checklist
```
[ ] All navigation routes defined in MyRoutes
[ ] AppRouter.generateRoute covers all routes
[ ] SplashScreen checks token and calls fetchProfile
[ ] State listener logic correct
[ ] No navigation loops
[ ] Token check working (TokenStorage integration ready)
[ ] main.dart initialRoute set to splash
```

---

## Phase 4: UI Screens (2 weeks)

### Objective
Implement all authentication screens. These screens are **UI-only** - they call cubit methods and listen to states.

### 4.1 Core UI Patterns

Before implementing screens, establish reusable patterns:

- [ ] `SignupTextField` widget
  - [ ] Handles email/password validation styling
  - [ ] Shows error messages
  - [ ] Obscure text for passwords

- [ ] `OtpInputField` widget (or use `pinput` package)
  - [ ] 6-digit input
  - [ ] Auto-submit on complete
  - [ ] Error state styling

- [ ] Custom button styling consistent across all auth screens

### 4.2 Screen Implementation Order

#### Screen 1: SignupScreen
**File**: `lib/feature/auth/presentation/screens/signup_screen.dart`

- [ ] TextEditingControllers for nickname, email, password
- [ ] Form validation (email format, password strength)
- [ ] BlocBuilder listening to AuthCubit:
  - [ ] If AuthLoading: Show loading spinner, disable button
  - [ ] If OtpSent: Auto-navigate to VerifyOtpScreen
  - [ ] If AuthError: Show error snackbar, keep form
- [ ] Sign Up button calls `authCubit.signup(nickname, email, password)`
- [ ] Links: "Already have account? Sign In" → LoginScreen
- [ ] Optional: Google Sign-In button

#### Screen 2: VerifyOtpScreen
**File**: `lib/feature/auth/presentation/screens/verify_otp_screen.dart`

- Constructor parameters: `email`, `flow` (signup/forgot_password/email_change)
- OTP input field (6 digits)
- Resend OTP button with countdown timer (60s)
- BlocBuilder listening to AuthCubit:
  - [ ] If OtpLoading: Show loading, disable input
  - [ ] If SignupOtpVerified: Auto-navigate to CompleteProfileScreen
  - [ ] If AuthLoaded (for forgot_password): Auto-navigate to HomeScreen
  - [ ] If OtpError: Show error, keep OTP input
- On submit: Call appropriate cubit method based on `flow`
  ```dart
  if (widget.flow == 'signup') {
    authCubit.verifySignupOtp(email, otpCode);
  } else if (widget.flow == 'forgot_password') {
    // Need additional password field for this flow
    authCubit.verifyForgotPasswordOtp(email, otpCode, newPassword);
  }
  ```

#### Screen 3: CompleteProfileScreen
**File**: `lib/feature/auth/presentation/screens/complete_profile_screen.dart`

- Constructor parameter: `user` (UserAuthEntity)
- Form fields:
  - [ ] Date of Birth picker (DatePicker)
  - [ ] Gender dropdown (Male, Female, Other)
  - [ ] Phone number input with E.164 formatting
- Form validation (DOB not future, phone valid format)
- BlocBuilder listening to AuthCubit:
  - [ ] If AuthLoading: Show loading, disable button
  - [ ] If AuthLoaded: Auto-navigate to HomeScreen
  - [ ] If ProfileUpdateError: Show error, keep form
- Continue button calls `authCubit.completeProfile(dob, gender, phone)`

#### Screen 4: LoginScreen
**File**: `lib/feature/auth/presentation/screens/login_screen.dart`

- TextEditingControllers for email, password
- Form validation
- BlocBuilder listening to AuthCubit:
  - [ ] If AuthLoading: Show loading, disable button
  - [ ] If AuthLoaded: Auto-navigate to HomeScreen
  - [ ] If ProfileIncomplete: Auto-navigate to CompleteProfileScreen
  - [ ] If AuthError: Show error snackbar
- Sign In button calls `authCubit.login(email, password)`
- Links: 
  - [ ] "Forgot Password?" → ForgotPasswordScreen
  - [ ] "New to Afiete? Sign Up" → SignupScreen
- Google Sign-In button

#### Screen 5: ForgotPasswordScreen
**File**: `lib/feature/auth/presentation/screens/forgot_password_screen.dart`

- TextEditingController for email
- Email validation
- BlocBuilder listening to AuthCubit:
  - [ ] If OtpLoading: Show loading, disable input
  - [ ] If OtpSent: Auto-navigate to VerifyOtpScreen with flow='forgot_password'
  - [ ] If AuthError: Show error
- "Send Recovery Code" button calls `authCubit.requestForgotPasswordOtp(email)`
- Back button → LoginScreen

#### Screen 6: ProfileSettingsScreen
**File**: `lib/feature/auth/presentation/screens/profile_settings_screen.dart`

- Display current user profile (from state)
- Sections:
  - [ ] **Basic Info**: Nickname (editable inline)
  - [ ] **Security**: Password (button → modal)
  - [ ] **Account**: Email (button → modal), Phone, Gender, DOB (button → modal)
  - [ ] **Danger Zone**: Delete Account (button → confirm modal)

- Nickname edit:
  - [ ] Inline edit field
  - [ ] Save calls `authCubit.updateProfileInfo(nickname: ...)`

- Password change:
  - [ ] Modal with old password + new password + confirm
  - [ ] Save calls `authCubit.updatePassword(current, new)`

- Email change:
  - [ ] Modal to request change
  - [ ] Calls `authCubit.requestEmailChange()`
  - [ ] Navigate to VerifyOtpScreen(flow: 'email_change')
  - [ ] On OTP verify: `authCubit.confirmEmailChange(newEmail, otp)`

- Phone/Gender/DOB change:
  - [ ] Modal asks for current password first
  - [ ] On verify: Show edit modal
  - [ ] Save calls `authCubit.updateProfileInfo(phoneNumber: ...)`

- Delete Account:
  - [ ] Confirm dialog: "This cannot be undone"
  - [ ] Email + password confirmation fields
  - [ ] BlocBuilder on AuthError/success states
  - [ ] On success: Auto-navigate to SignupScreen

- Logout:
  - [ ] Button calls `authCubit.logout()`
  - [ ] On success: Auto-navigate to SignupScreen

#### Screen 7: ResetPasswordScreen (optional, part of forgot flow)
- May be combined with VerifyOtpScreen for password field

### 4.3 Reusable Widgets

Create `lib/feature/auth/presentation/widgets/`:

- [ ] `AuthTextField` widget
  - [ ] Email/password validation styling
  - [ ] Error message display
  - [ ] Obscure text toggle for passwords

- [ ] `OtpInput` widget
  - [ ] 6 digit input
  - [ ] Auto-focus behavior
  - [ ] Paste support

- [ ] `CountdownTimer` widget
  - [ ] Countdown display (60s → 0s)
  - [ ] Re-enable Resend button on 0s

- [ ] `PasswordStrengthIndicator` widget
  - [ ] Visual feedback on password strength
  - [ ] Requirements display

### Phase 4 Verification Checklist
```
[ ] All 7 screens implemented
[ ] BlocBuilder used consistently
[ ] Form validation working
[ ] Navigation transitions smooth
[ ] Error messages user-friendly
[ ] Loading states show spinners
[ ] Token caching verified
[ ] No null pointer errors
[ ] Screen tests created (skeleton)
```

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

---

## Phase 6: Backend Integration & Refinement (Ongoing)

### Objective
Integrate with actual Django backend and refine based on real-world behavior.

### 6.1 Backend Readiness Checklist

Before Phase 6, ensure Django team has delivered:

- [ ] `/api/auth/signup/` endpoint
- [ ] `/api/auth/verify-signup-otp/` endpoint (returns access_token)
- [ ] `/api/auth/login/` endpoint
- [ ] `/api/auth/profile/` endpoint (GET + PATCH)
- [ ] `/api/auth/logout/` endpoint
- [ ] `/api/auth/delete-account/` endpoint
- [ ] `/api/auth/forgot-password/` endpoint
- [ ] `/api/auth/verify-forgot-password-otp/` endpoint
- [ ] `/api/auth/change-password/` endpoint
- [ ] `/api/auth/google-signin/` endpoint
- [ ] All endpoints documented with request/response schemas
- [ ] Token refresh mechanism (implicit in Dio interceptor)

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

- [ ] Remove debug logging
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

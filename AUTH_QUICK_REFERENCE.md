# Authentication Feature - Quick Reference Checklist

**Use this as a daily reference during implementation**

---

## Phase 1: Domain Layer (Week 1-2)

### Entities
```
lib/feature/auth/domain/entities/
├── [ ] auth_user_entity.dart          (UserAuthEntity + isProfileComplete)
└── [ ] otp_entity.dart                (OtpEntity)
```

### Repository Interface
```
lib/feature/auth/domain/repositories/
└── [ ] auth_repository.dart           (14 abstract methods)
```

### Use Cases (13 total)
```
lib/feature/auth/domain/usecase/
├── [ ] signup_usecase.dart
├── [ ] verify_signup_otp_usecase.dart
├── [ ] login_usecase.dart
├── [ ] fetch_profile_usecase.dart
├── [ ] update_profile_info_usecase.dart
├── [ ] logout_usecase.dart
├── [ ] delete_account_usecase.dart
├── [ ] google_signin_usecase.dart
├── [ ] request_forgot_password_otp_usecase.dart
├── [ ] verify_forgot_password_otp_usecase.dart
├── [ ] update_password_usecase.dart
├── [ ] request_email_change_otp_usecase.dart
└── [ ] confirm_email_change_usecase.dart
```

✅ **Phase 1 Complete When**: All domain files compile without errors, no imports missing

---

## Phase 2: Data Layer (Week 1-2)

### Models
```
lib/feature/auth/data/models/
├── [ ] user_model.dart                (with fromJson, toJson, toEntity)
└── [ ] otp_model.dart                 (with fromJson, toEntity)
```

### Datasources
```
lib/feature/auth/data/datasources/
├── [ ] auth_remote_datasource.dart    (abstract interface)
└── [ ] auth_remote_datasource_impl.dart (all 14 endpoint implementations)
```

### Repositories
```
lib/feature/auth/data/repositories/
└── [ ] auth_repository_impl.dart      (wraps datasource in Either)
```

### Error Handling
```
lib/core/error/
└── [ ] failure.dart                   (add ServerFailure._fromResponse factory)
        • 400 → "Email already registered" / "Password too weak"
        • 401 → "Account is inactive" (detect keywords)
        • 429 → "Too many attempts"
        • 5xx → "Server error. Try again later."
```

### DI Updates
```
lib/core/di/injection_container.dart
└── [ ] initAuth() function with:
        • AuthRemoteDataSource registration
        • AuthRepository registration
        • All 13 usecases
```

✅ **Phase 2 Complete When**: `flutter analyze lib/feature/auth/` passes, DI has no circular deps

---

## Phase 3: Presentation - Cubit (Week 2)

### State Definitions
```
lib/feature/auth/presentation/cubits/auth_state.dart (part file)
├── [ ] AuthState (abstract base)
├── [ ] AuthInitial
├── [ ] AuthLoading
├── [ ] OtpLoading
├── [ ] OtpSent (email, expiresInSeconds, message)
├── [ ] SignupOtpVerified (user)
├── [ ] AuthLoaded (user)
├── [ ] ProfileIncomplete (user)
├── [ ] ProfileUpdateError (message)
├── [ ] AuthError (message)
├── [ ] OtpError (message)
└── [ ] AuthUnauthenticated
```

### Cubit Implementation
```
lib/feature/auth/presentation/cubits/auth_cubit.dart
├── [ ] signup(nickname, email, password)
├── [ ] verifySignupOtp(email, otpCode)
├── [ ] completeProfile(dob, gender, phone)
├── [ ] login(email, password)
├── [ ] requestForgotPasswordOtp(email)
├── [ ] verifyForgotPasswordOtp(email, otpCode, newPassword)
├── [ ] updatePassword(current, new)
├── [ ] requestEmailChange()
├── [ ] confirmEmailChange(newEmail, otpCode)
├── [ ] fetchProfile()
├── [ ] logout()
├── [ ] deleteAccount(email, password)
├── [ ] googleSignIn(idToken)
├── [ ] _cacheTokens(user)
├── [ ] _clearTokens()
├── [ ] _isInactiveAccountError(message)
└── [ ] _log(event, data)
```

### Helper Utils
```
lib/core/utils/
└── [ ] token_storage.dart
        • setAccessToken(token)
        • getAccessToken() → String?
        • setRefreshToken(token)
        • getRefreshToken() → String?
        • clearTokens()
```

✅ **Phase 3 Complete When**: All cubit methods emit correct states, token caching works

---

## Phase 4: Navigation & Routing (Week 2-3)

### Routes
```
lib/core/routes/
├── [ ] app_routes.dart
│       └── MyRoutes constants:
│           • splashScreen
│           • signup
│           • verifyOtp
│           • completeProfile
│           • login
│           • forgotPassword
│           • homeScreen
│           • profileSettings
│
├── [ ] app_router.dart
│       └── AppRouter.generateRoute() with all route cases
│
└── [ ] Update main.dart
        • initialRoute = MyRoutes.splashScreen
        • onGenerateRoute = AppRouter.generateRoute
```

### Splash Screen
```
lib/feature/splash/presentation/screens/splash_screen.dart
├── [ ] Check _hasValidToken()
├── [ ] If no token → Navigate to signup
├── [ ] If token exists:
│       ├── [ ] Call fetchProfile()
│       ├── [ ] Listen to AuthLoaded → home
│       ├── [ ] Listen to ProfileIncomplete → complete_profile
│       └── [ ] Listen to AuthError → login
└── [ ] Show splash image + loading spinner
```

✅ **Phase 4 Complete When**: Navigation tree works, no loops, token check functional

---

## Phase 5: UI Screens (Week 3-4)

### SignupScreen
```
lib/feature/auth/presentation/screens/signup_screen.dart
├── [ ] TextField: Nickname
├── [ ] TextField: Email (validation)
├── [ ] TextField: Password (obscure, strength indicator)
├── [ ] Button: Sign Up
├── [ ] Link: "Already have account?"
├── [ ] BlocListener:
│       ├── [ ] AuthLoading → show spinner
│       ├── [ ] OtpSent → navigate to verifyOtp
│       └── [ ] AuthError → show snackbar
└── [ ] Optional: Google Sign-In button
```

### VerifyOtpScreen
```
lib/feature/auth/presentation/screens/verify_otp_screen.dart
├── [ ] Constructor: email, flow (signup/forgot_password/email_change)
├── [ ] OtpInput: 6 digits (pinput or custom)
├── [ ] Button: Verify
├── [ ] Button: Resend (with 60s countdown timer)
├── [ ] Display: "Code sent to user@example.com"
├── [ ] BlocListener:
│       ├── [ ] OtpLoading → show spinner
│       ├── [ ] SignupOtpVerified → navigate to completeProfile
│       ├── [ ] AuthLoaded (forgot_password) → navigate to home
│       └── [ ] OtpError → show error, keep input
└── [ ] Call appropriate cubit method based on flow
```

### CompleteProfileScreen
```
lib/feature/auth/presentation/screens/complete_profile_screen.dart
├── [ ] Constructor: user (UserAuthEntity)
├── [ ] Field: Date of Birth (DatePicker)
├── [ ] Field: Gender (Dropdown: Male, Female, Other)
├── [ ] Field: Phone Number (E.164 formatting)
├── [ ] Button: Continue
├── [ ] BlocListener:
│       ├── [ ] AuthLoading → show spinner
│       ├── [ ] AuthLoaded → navigate to home
│       └── [ ] ProfileUpdateError → show error
└── [ ] Validation: DOB not future, phone valid format
```

### LoginScreen
```
lib/feature/auth/presentation/screens/login_screen.dart
├── [ ] TextField: Email
├── [ ] TextField: Password
├── [ ] Link: "Forgot Password?"
├── [ ] Button: Sign In
├── [ ] Link: "New user? Sign Up"
├── [ ] BlocListener:
│       ├── [ ] AuthLoading → show spinner
│       ├── [ ] AuthLoaded → navigate to home
│       ├── [ ] ProfileIncomplete → navigate to completeProfile
│       └── [ ] AuthError → show error snackbar
└── [ ] Optional: Google Sign-In button
```

### ForgotPasswordScreen
```
lib/feature/auth/presentation/screens/forgot_password_screen.dart
├── [ ] TextField: Email
├── [ ] Button: Send Recovery Code
├── [ ] Button: Back
├── [ ] BlocListener:
│       ├── [ ] OtpLoading → show spinner
│       ├── [ ] OtpSent → navigate to verifyOtp(flow: 'forgot_password')
│       └── [ ] OtpError → show error
└── [ ] Email validation
```

### ProfileSettingsScreen
```
lib/feature/auth/presentation/screens/profile_settings_screen.dart
├── [ ] Section: Basic Info
│       ├── [ ] Display: Nickname (with edit button)
│       └── [ ] Inline edit with save/cancel
├── [ ] Section: Security
│       ├── [ ] Button: Change Password
│       ├── [ ] Modal: Old password + New password + Confirm
│       └── [ ] Call updatePassword()
├── [ ] Section: Account
│       ├── [ ] Display: Email (with edit button)
│       ├── [ ] Button: Change Phone
│       ├── [ ] Button: Change Gender
│       ├── [ ] Button: Change DOB
│       ├── [ ] All sensitive: Require password verification first
│       └── [ ] Call updateProfileInfo() for each
├── [ ] Section: Email Management
│       ├── [ ] Button: Change Email
│       ├── [ ] Modal: Request email change
│       ├── [ ] Navigate to verifyOtp(flow: 'email_change')
│       └── [ ] Call confirmEmailChange() on OTP verify
├── [ ] Section: Danger Zone
│       ├── [ ] Button: Delete Account
│       ├── [ ] Confirmation modal: Email + Password
│       └── [ ] Call deleteAccount()
├── [ ] Button: Logout
│       └── [ ] Navigate to signup
└── [ ] BlocListener on all AuthStates
```

### Reusable Widgets
```
lib/feature/auth/presentation/widgets/
├── [ ] auth_text_field.dart (with validation styling)
├── [ ] otp_input_field.dart (pinput wrapper or custom)
├── [ ] countdown_timer.dart (60s timer widget)
└── [ ] password_strength_indicator.dart (visual feedback)
```

✅ **Phase 5 Complete When**: All screens navigate correctly, forms validate, errors display

---

## Phase 6: Testing (Week 4-5)

### Unit Tests
```
test/feature/auth/domain/usecases/
├── [ ] signup_usecase_test.dart
├── [ ] verify_signup_otp_usecase_test.dart
├── [ ] login_usecase_test.dart
├── [ ] fetch_profile_usecase_test.dart
├── [ ] update_profile_info_usecase_test.dart
├── [ ] logout_usecase_test.dart
├── [ ] delete_account_usecase_test.dart
├── [ ] google_signin_usecase_test.dart
└── ... (remaining usecases)

test/feature/auth/data/repositories/
└── [ ] auth_repository_impl_test.dart
```

### Widget Tests
```
test/feature/auth/presentation/screens/
├── [ ] signup_screen_test.dart
├── [ ] verify_otp_screen_test.dart
├── [ ] complete_profile_screen_test.dart
├── [ ] login_screen_test.dart
├── [ ] forgot_password_screen_test.dart
└── [ ] profile_settings_screen_test.dart
```

### Integration Tests
```
test/feature/auth/integration/
├── [ ] signup_flow_test.dart (signup → OTP → profile → home)
├── [ ] login_flow_test.dart (login with complete/incomplete profile)
├── [ ] password_recovery_flow_test.dart
└── [ ] delete_account_flow_test.dart
```

### Error Scenario Tests
```
[ ] Invalid email → form error
[ ] Email exists → AuthError
[ ] Invalid OTP → OtpError
[ ] Network timeout → "Connection timed out"
[ ] 401 Unauthorized → logout + go to login
[ ] Account inactive → "Account is inactive"
[ ] 429 Rate limit → "Too many attempts"
[ ] 500 Server error → "Server error. Try again later"
```

### Coverage
```bash
flutter test --coverage lib/feature/auth/
# Target: >80% coverage
```

✅ **Phase 6 Complete When**: All tests passing, coverage >80%

---

## Phase 7: Backend Integration (Week 5-6)

### Before Connecting Backend
```
[ ] Implement TokenStorage (lib/core/utils/token_storage.dart)
[ ] Implement Dio interceptor with token attachment
[ ] Remove mock datasource
[ ] Configure real API base URL
[ ] Setup token refresh logic in Dio interceptor
```

### Backend Validation
```
[ ] Test signup → OTP verify → token received
[ ] Test login → token + profile data
[ ] Test fetchProfile → returns user with all fields
[ ] Test updateProfileInfo → PATCH returns updated user
[ ] Test deleteAccount → proper 401 if wrong password
[ ] Test logout → token invalidated
[ ] Test 401 → Dio interceptor refreshes token
[ ] Test rate limiting (429)
[ ] Test all error messages match UI expectations
```

### Endpoint Verification
```
Auth API Endpoints (14 total)
├── [ ] POST /api/auth/signup/               (request OTP)
├── [ ] POST /api/auth/verify-signup-otp/    (returns token)
├── [ ] POST /api/auth/login/                (returns token + profile)
├── [ ] GET /api/auth/profile/               (requires token)
├── [ ] PATCH /api/auth/profile/             (requires token)
├── [ ] POST /api/auth/logout/               (requires token)
├── [ ] DELETE /api/auth/delete-account/     (requires token)
├── [ ] POST /api/auth/forgot-password/      (request OTP)
├── [ ] POST /api/auth/verify-forgot-password-otp/ (reset password)
├── [ ] POST /api/auth/change-password/      (requires token)
├── [ ] POST /api/auth/request-email-change/ (requires token)
├── [ ] POST /api/auth/confirm-email-change/ (requires token)
├── [ ] POST /api/auth/google-signin/        (returns token)
└── [ ] POST /api/auth/resend-otp/           (optional, for testing)
```

✅ **Phase 7 Complete When**: All endpoints tested, token refresh working, logout on 401

---

## Daily Development Checklist

### Start of Day
- [ ] Pull latest changes
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze` to catch issues
- [ ] Check any errors from previous day's tests

### During Development
- [ ] Write code with proper null safety (`?` and `!` carefully)
- [ ] Use `const` where possible for Widgets/States
- [ ] Follow naming conventions (useCase not usecase, Entity not entity)
- [ ] Add logging with `developer.log()` for debugging
- [ ] Don't commit with debug code (`print()` instead of `developer.log()`)

### End of Day
- [ ] Run `flutter test` for affected areas
- [ ] Run `flutter analyze`
- [ ] Commit with meaningful messages
- [ ] Update checklist with completed items

---

## Quick Compile Commands

```bash
# Analyze for errors
flutter analyze lib/feature/auth/

# Run tests in one phase
flutter test test/feature/auth/domain/

# Format code (requires dart_format)
dart format lib/feature/auth/ test/feature/auth/

# Build for testing
flutter build apk --debug

# Check dependencies
flutter pub deps
```

---

## Common Mistakes to Avoid

- ❌ Calling updateProfileInfo before caching token
- ❌ Not checking isProfileComplete after login
- ❌ Using mutable state in AuthState subclasses
- ❌ Forgetting to clear tokens on logout
- ❌ Showing raw backend error messages to users
- ❌ Not handling 401 errors with token refresh
- ❌ Navigating without proper state transitions
- ❌ Using `const` on widgets with runtime theme values
- ❌ Forgetting `part 'auth_state.dart'` in auth_cubit.dart
- ❌ Not implementing `Equatable` on entities/models

---

## Success Indicators

✅ All auth flows work without errors  
✅ Token management automatic (cache/refresh/clear)  
✅ Profile completion enforced correctly  
✅ Error messages professional and helpful  
✅ Network errors handled gracefully  
✅ All screens responsive  
✅ Tests >80% coverage  
✅ No console warnings or debug code  
✅ Navigation tree is acyclic  
✅ Code follows clean architecture patterns  

---

**Print this checklist and update daily during implementation**

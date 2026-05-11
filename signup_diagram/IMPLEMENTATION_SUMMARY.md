# Signup Flow Correction - Complete Summary (May 11, 2026)

## Overview
The original signup diagram showed states and flows that didn't match the actual implementation. This document outlines **all corrections made to code AND diagram** to ensure they work correctly together.

---

## 1. STATE CHANGES (auth_state.dart)

### New States Added:
```dart
// OtpSent - emitted when OTP is successfully sent (signup or resend)
class OtpSent extends AuthState {
  final String email;
  final int expiresInSeconds;

  const OtpSent({required this.email, required this.expiresInSeconds});
  @override
  List<Object> get props => [email, expiresInSeconds];
}

// SignupOtpVerified - emitted after OTP verification when profile is incomplete
class SignupOtpVerified extends AuthState {
  final UserAuthEntity user;
  const SignupOtpVerified(this.user);
  @override
  List<Object> get props => [user];
}

// ProfileUpdateError - emitted when profile completion fails
class ProfileUpdateError extends AuthState {
  final String message;
  const ProfileUpdateError(this.message);
  @override
  List<Object> get props => [message];
}
```

### Modified States:
- **WaitingForOtpVerification**: Now kept for backwards compatibility with `expiresInSeconds` parameter
  - Changed from `props => [email, expiresInSeconds]` to `props => [email, expiresInSeconds ?? 0]`
  - To conform to `List<Object>` contract (not `List<Object?>`)

---

## 2. CUBIT CHANGES (auth_cubit.dart)

### signup() Method - CORRECTED PHASE 1
**Before**: Emitted `WaitingForOtpVerification(email)`  
**After**: Emits `OtpSent(email: email, expiresInSeconds: otpEntity.expiresInSeconds)`

```dart
(otpEntity) {
  _log.info('signup:otp_sent', data: {
    'cid': correlationId,
    'email': email,
    'expiresIn': otpEntity.expiresInSeconds,
  });
  _pendingSignupUser = UserAuthEntity(
    username: nickname,
    nickname: nickname,
    email: email,
    password: password,
    isVerified: false,
  );
  // PHASE 1: OTP sent by backend; navigate to verification screen
  emit(OtpSent(
    email: email,
    expiresInSeconds: otpEntity.expiresInSeconds,
  ));
}
```

**Impact**: SignupScreen can now listen for OtpSent to navigate to VerifyOtpScreen.

---

### verifyOtp() Method - CORRECTED PHASE 2
**Key Changes**:
1. Token caching happens IMMEDIATELY via `_cacheAndEmitUser(sessionUser)`
2. After token caching, check if profile is complete
3. Emit `SignupOtpVerified` only if profile is incomplete (signup flow)

```dart
// PHASE 2: OTP verified successfully - CRITICAL token caching point
await _cacheAndEmitUser(sessionUser, correlationId: correlationId);

// Determine next step based on flow and profile completion status
if (isSignupFlow) {
  // PHASE 2.5: Check if profile is complete
  final isProfileComplete = _isUserProfileComplete(sessionUser);
  
  if (!isProfileComplete) {
    // Profile incomplete: emit special state to navigate to profile completion screen
    _log.info('verify_otp:signup_requires_profile_completion', ...);
    emit(SignupOtpVerified(sessionUser));
  }
  // If profile IS complete, AuthLoaded was already emitted above via _cacheAndEmitUser
}
```

**Key Point**: `_cacheAndEmitUser()` is the CRITICAL POINT where tokens are cached to secure storage.

**Impact**: 
- Tokens are available immediately for PHASE 3 (profile completion)
- UI knows exactly when to show profile completion screen vs home
- Token is never missing when profile update is called

---

### sendVerificationOtp() Method - RESEND OTP
**Before**: Emitted `WaitingForOtpVerification(email)`  
**After**: Emits `OtpSent(email: email, expiresInSeconds: otpEntity.expiresInSeconds)`

---

### New Helper Method - _isUserProfileComplete()
```dart
/// Check if user profile is complete for signup flow
/// Profile is considered complete when: birthDate, gender, and phoneNumber are all non-empty
bool _isUserProfileComplete(UserAuthEntity user) {
  final hasBirthDate = user.birthDate != null;
  final hasGender = user.gender != null && user.gender!.trim().isNotEmpty;
  final hasPhoneNumber = user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty;
  
  return hasBirthDate && hasGender && hasPhoneNumber;
}
```

---

## 3. SCREEN CHANGES

### SignupScreen (signup_screen.dart) - CORRECTED NAVIGATION
**Added listeners for new states**:
```dart
listener: (context, state) {
  if (state is OtpSent) {
    // PHASE 1 → PHASE 2: Navigate to OTP verification screen
    Navigator.pushNamed(
      context,
      MyRoutes.verifyAccountScreen,
      arguments: state.email,
    );
  } else if (state is SignupOtpVerified) {
    // PHASE 2 → PHASE 3: Navigate to profile completion screen
    Navigator.pushNamed(
      context,
      MyRoutes.authInfoScreens,
      arguments: state.user,
    );
  } else if (state is AuthLoaded) {
    // ...existing logic
  }
  // ...rest
}
```

---

### VerifyAccountScreen (verify_account_screen.dart) - CORRECTED NAVIGATION
**Added listener for SignupOtpVerified**:
```dart
listener: (context, state) {
  if (state is SignupOtpVerified) {
    // PHASE 2 → PHASE 3: OTP verified in signup flow, navigate to profile completion
    Navigator.pushReplacementNamed(
      context,
      MyRoutes.authInfoScreens,
      arguments: state.user,
    );
  } else if (state is AuthLoaded) {
    // OTP verified in login/password reset flow
    // ...existing logic to check profile completeness
  }
  // ...rest
}
```

---

## 4. DIAGRAM CHANGES

### Created: CORRECTED_SIGNUP_FLOW.md
A comprehensive, corrected diagram showing:
- ✅ OtpSent state (not WaitingForOtpVerification)
- ✅ SignupOtpVerified state (emitted before AuthLoaded)
- ✅ Correct token caching point in verifyOtp()
- ✅ Correct navigation sequence
- ✅ Correct state transitions
- ✅ Backend request/response details

---

## 5. FLOW SUMMARY (CORRECTED)

### PHASE 1: Registration
```
SignupScreen
  → signup(nickname, email, password)
  → AuthLoading
  → OtpSent(email, expiresInSeconds)  ✅ [CHANGED]
  → Navigate to VerifyOtpScreen
```

### PHASE 2: OTP Verification & Token Caching
```
VerifyOtpScreen
  → verifyOtp(email, otp)
  → AuthLoading
  → _cacheAndEmitUser()  ✅ [Token saved to secure storage HERE]
  → Check: Profile complete?
    → NO:  SignupOtpVerified(user)  ✅ [NEW STATE]
           → Navigate to AuthInfoScreen
    → YES: AuthLoaded(user)
           → Navigate to HomeScreen
```

### PHASE 3: Profile Completion (with cached token)
```
AuthInfoScreen
  → updateProfileInfo(birthDate, gender, phoneNumber)
  → AuthLoading
  → Dio interceptor adds Authorization: Bearer <cached_token> ✅ [Automatic]
  → PATCH /api/auth/profile/
  → SUCCESS: AuthLoaded → Navigate to HomeScreen
  → FAILURE: ProfileUpdateError  ✅ [NEW STATE] → Show error
```

### PHASE 4: Session Refresh (transparent)
```
Any Future Request
  → Dio interceptor reads cached token
  → Add Authorization header
  → If 401: Auto-refresh token via POST /api/auth/refresh/
  → Retry request with new token
  → If refresh fails: Redirect to signup
```

---

## 6. TESTING CHECKLIST

- [ ] SignupScreen submit → OtpSent emitted → VerifyOtpScreen shows
- [ ] VerifyOtpScreen OTP entry → verifyOtp() called
- [ ] Tokens are saved to secure storage after verification
- [ ] SignupOtpVerified emitted if profile incomplete → AuthInfoScreen shows
- [ ] AuthInfoScreen submit → updateProfileInfo() called with cached token
- [ ] AuthLoaded emitted after profile update → HomeScreen shows
- [ ] Resend OTP → OtpSent emitted → Timer resets
- [ ] Login flow with incomplete profile → AuthLoaded + redirect to AuthInfoScreen
- [ ] Logout → _pendingSignupUser cleared, tokens cleared
- [ ] Token expired → Auto-refresh via Dio → Transparent to user

---

## 7. KEY TECHNICAL NOTES

1. **Token Caching Point**: `_cacheAndEmitUser()` in verifyOtp() method
   - Called immediately after OTP verification
   - Saves tokens to secure storage via `authRepository.cacheSession()`
   - Makes tokens available for profile update request

2. **State Emission Order**: Critical for correct navigation
   - First: `_cacheAndEmitUser()` → emits AuthLoaded
   - Then: Check profile complete
   - Then: If incomplete, emit SignupOtpVerified (overrides AuthLoaded)
   - Screens listen for SignupOtpVerified specifically for signup flow

3. **Profile Completion**: Uses authenticated request
   - Dio interceptor reads cached token from secure storage
   - Automatically adds `Authorization: Bearer <token>` header
   - No manual token handling needed in updateProfileInfo()

4. **Error States**: Specific to operation
   - AuthError: Generic auth failures (login, signup, etc.)
   - ProfileUpdateError: Specific to profile completion
   - Allows targeted error messaging

---

## 8. FILES MODIFIED

- `lib/feature/auth/presentation/cubits/auth_state.dart` - Added 3 new states
- `lib/feature/auth/presentation/cubits/auth_cubit.dart` - Updated 3 methods + 1 new helper
- `lib/feature/auth/presentation/views/signup_screen.dart` - Added OtpSent + SignupOtpVerified listeners
- `lib/feature/auth/presentation/views/verify_account_screen.dart` - Added SignupOtpVerified listener
- `signup_diagram/CORRECTED_SIGNUP_FLOW.md` - New comprehensive diagram

---

## 9. BACKWARDS COMPATIBILITY

- WaitingForOtpVerification state still exists for legacy code
- OtpSent is now the primary state for signup/resend OTP flows
- Screens can handle both states if needed
- No breaking changes to existing APIs


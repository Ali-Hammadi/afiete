# Afiete Auth & Profile Management Flow Documentation
**Last Updated:** May 12, 2026  
**Status:** Verified Backend Contract

---

## Table of Contents
1. [Phase 1: Signup & OTP Verification](#phase-1-signup--otp-verification)
2. [Phase 2: Login](#phase-2-login)
3. [Phase 3: Logout](#phase-3-logout)
4. [Phase 4: Account Deletion](#phase-4-account-deletion)
5. [Phase 5: Password Reset (Forgot Password)](#phase-5-password-reset-forgot-password)
6. [Phase 6: Password Change (Settings)](#phase-6-password-change-settings)
7. [Phase 7: Profile Info Update](#phase-7-profile-info-update)
8. [Phase 8: Error Handling & Edge Cases](#phase-8-error-handling--edge-cases)

---

## Phase 1: Signup & OTP Verification

### Overview
User creates account, receives OTP via email, verifies OTP, completes profile info.

### Step 1.1: Initiate Signup
**Endpoint:** `POST /api/patients/register/`

**Request Body:**
```json
{
  "user": {
    "nickname": "string",
    "email": "user@example.com",
    "password": "string"
  }
}
```

**Success Response (201):**
```json
{
  "user": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "is_verified": false
  },
  "otp_expires_in": 600
}
```

**Error Responses:**
- **400**: Email already exists / Invalid data format
- **422**: Validation failed (weak password, invalid email)

**Frontend Action:**
- Save pending signup user locally
- Show "Check your email for verification code"
- Navigate to VerifyAccountScreen

---

### Step 1.2: Request Resend Verification Code
**Endpoint:** `POST /api/users/otp/resend`

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Success Response (200):**
```json
{
  "message": "OTP sent successfully",
  "otp_expires_in": 600
}
```

**Error Responses:**
- **400**: User already verified
- **404**: Email not found / User deleted by admin → **Trigger app reset to splash**
- **429**: Too many resend requests

**Frontend Action:**
- Show countdown timer (60s before enabling resend button)
- Reset PIN input
- Show "Code resent" snackbar

---

### Step 1.3: Verify OTP (Signup Flow)
**Endpoint:** `POST /api/users/otp/verify`

**Request Body:**
```json
{
  "email": "user@example.com",
  "code": "string"  // 4-digit code
}
```

**Success Response (200):**
```json
{
  "access_token": "string",
  "refresh_token": "string",
  "user": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "is_verified": true,
    "birth_date": null,
    "gender": null,
    "phone": null,
    "age": null,
    "nickname": null,
    "psychological_history": null
  }
}
```

**Error Responses:**
- **400**: Invalid OTP / OTP expired
- **404**: No User matches the given query → **Trigger app reset to splash**
- **429**: Too many verification attempts

**Frontend Action:**
1. Cache access_token + refresh_token immediately
2. Check if profile is complete:
   - If missing (birth_date, gender, phone): Navigate to AuthInfoScreen (profile completion)
   - If complete: Navigate to HomeScreen
3. Emit `SignupOtpVerified` state if profile incomplete
4. Emit `AuthLoaded` state if profile complete

---

### Step 1.4: Complete Profile Information (Signup)
**Endpoint:** `PATCH /api/patients/profile/`

**Request Body:**
```json
{
  "user": {
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "string"
  },
  "psychological_history": "string",
  "nickname": "string"
}
```

**Success Response (200):**
```json
{
  "user": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "123456789",
    "age": 25,
    "is_verified": true
  },
  "psychological_history": "string",
  "nickname": "string"
}
```

**Error Responses:**
- **400**: Invalid date format / Invalid gender (must be male/female)
- **401**: Unauthorized / Token missing
- **404**: User not found → **Trigger app reset to splash**
- **422**: Validation failed

**Frontend Action:**
- Cache updated user data
- Emit `AuthLoaded(user)` state
- Navigate to HomeScreen
- Mark signup flow as complete

---

## Phase 2: Login

### Overview
User enters email and password, authenticates, profile is loaded.

### Step 2.1: Login
**Endpoint:** `POST /api/users/login/`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "string"
}
```

**Success Response (200):**
```json
{
  "access_token": "string",
  "refresh_token": "string",
  "user": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "is_verified": true,
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "123456789",
    "age": 25,
    "nickname": "John Doe",
    "psychological_history": null
  }
}
```

**Error Responses:**
- **400**: Invalid credentials / User not verified (needs OTP verification)
- **401**: Email/password mismatch
- **403**: Account inactive/disabled/blocked/suspended → **Show user-friendly error**
- **404**: User not found (account deleted) → **Trigger app reset to splash**

**Frontend Action:**
1. Cache access_token + refresh_token
2. Cache user data locally
3. Emit `AuthLoaded(user)` state
4. Navigate to HomeScreen

---

## Phase 3: Logout

### Overview
User logs out, session is cleared, app returns to signup screen.

### Step 3.1: Logout
**Endpoint:** `POST /api/users/logout/`

**Request Body:**
```json
{}
```

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (200):**
```json
{
  "message": "Logged out successfully"
}
```

**Error Responses:**
- **401**: Unauthorized / Token invalid/expired
- **404**: User not found (account deleted)

**Frontend Action (Regardless of Response):**
1. Clear cached session (access_token, refresh_token, user data)
2. Clear pending signup session
3. Clear all local SharedPreferences (except language/theme)
4. Clear image/video caches
5. Reset auth cubit state to `AuthInitial()`
6. Emit logout event if using EventBus
7. Navigate to splash screen
8. Splash screen shows signup screen

**Important:** Logout failures should still clear local tokens (done in cubit, not waiting for server).

---

## Phase 4: Account Deletion

### Overview
User requests account deletion with password verification, account is hard-deleted from backend.

### Step 4.1: Request Account Deletion
**Endpoint:** `DELETE /api/users/account/delete/`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "string"
}
```

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (204 or 200):**
```json
{
  "message": "Account deleted successfully"
}
```

**Error Responses:**
- **400**: Invalid password / Incorrect password
- **401**: Unauthorized / Missing token
- **403**: Account already marked for deletion
- **404**: User not found

**Frontend Action:**
1. Call `NuclearResetHelper.performNuclearReset()`
   - Clear SharedPreferences completely
   - Clear secure storage
   - Clear image/video caches
   - Reset DI graph and recreate singletons
2. Emit `AuthReset('Account deleted successfully.')`
3. Navigate to splash screen → signup screen
4. App state is fresh (like first install)

---

## Phase 5: Password Reset (Forgot Password)

### Overview
User forgot password, requests OTP via email, verifies OTP, sets new password.

### Step 5.1: Request Password Reset OTP
**Endpoint:** `POST /api/users/auth/forgot-password/`

**Request Body:**
```json
{
  "email": "string"
}
```

**Success Response (200):**
```json
{
  "message": "OTP sent to email",
  "otp_expires_in": 600
}
```

**Error Responses:**
- **400**: User not verified / Invalid request
- **404**: Email not found / User deleted → **Trigger app reset to splash**
- **429**: Too many requests

**Frontend Action:**
- Navigate to ForgotPasswordScreen
- Show "Check your email for reset code"
- Show countdown timer (60s)

---

### Step 5.2: Verify Password Reset OTP
**Endpoint:** `POST /api/users/auth/verify-otp/`

**Request Body:**
```json
{
  "email": "user@example.com",
  "code": "string"
}
```

**Success Response (200):**
```json
{
  "message": "OTP verified",
  "token": "string"  // Temporary token for password reset
}
```

**Error Responses:**
- **400**: Invalid OTP / OTP expired
- **404**: User not found → **Trigger app reset to splash**
- **429**: Too many attempts

**Frontend Action:**
- Show "OTP verified, enter new password"
- Enable ResetPasswordScreen
- Store temporary token for next step

---

### Step 5.3: Reset Password
**Endpoint:** `POST /api/users/auth/reset-password/`

**Request Body:**
```json
{
  "email": "user@example.com",
  "new_password": "stringst",
  "confirm_password": "stringst"
}
```

**Success Response (200):**
```json
{
  "message": "Password reset successfully"
}
```

**Error Responses:**
- **400**: Passwords don't match / Weak password
- **404**: User not found / Invalid token → **Trigger app reset to splash**

**Frontend Action:**
1. Show "Password reset successfully"
2. Clear password reset flow data
3. Navigate to LoginScreen
4. User can now login with new password

---

## Phase 6: Password Change (Settings)

### Overview
User changes password from settings (requires current password).

### Step 6.1: Change Password
**Endpoint:** `POST /api/users/password/change`

**Request Body:**
```json
{
  "password": "string",
  "new_password": "string",
  "confirm_password": "string"
}
```

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (200):**
```json
{
  "message": "Password changed successfully",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "user@example.com"
  }
}
```

**Error Responses:**
- **400**: Current password incorrect / Passwords don't match / Weak password
- **401**: Unauthorized / Token invalid/expired
- **403**: Operation forbidden
- **404**: User not found → **Trigger app reset to splash**

**Frontend Action:**
- Show "Password changed successfully"
- Emit `AuthLoaded(updatedUser)` state
- Optionally refresh profile from backend
- Navigate back to SettingsScreen

---

## Phase 7: Profile Info Update

### Overview
User updates profile information (birth_date, gender, phone, nickname, psychological_history).

### Step 7.1: Fetch Current Profile (Optional)
**Endpoint:** `GET /api/patients/profile/`

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (200):**
```json
{
  "user": {
    "email": "user@example.com",
    "username": "user@example.com",
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "123456789",
    "age": 25
  },
  "psychological_history": "string",
  "nickname": "string"
}
```

**Error Responses:**
- **401**: Unauthorized / Token expired/invalid
- **404**: User not found → **Trigger app reset to splash**

**Frontend Action:**
- Cache latest user profile
- Pre-fill form fields

---

### Step 7.2: Update Profile Information
**Endpoint:** `PATCH /api/patients/profile/`

**Request Body:**
```json
{
  "user": {
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "string"
  },
  "psychological_history": "string",
  "nickname": "string"
}
```

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (200):**
```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "user@example.com",
    "birth_date": "2026-05-12",
    "gender": "male",
    "phone": "123456789",
    "age": 25,
    "nickname": "John Doe"
  },
  "psychological_history": "string",
  "nickname": "string"
}
```

**Error Responses:**
- **400**: Invalid data format / Invalid date / Invalid gender (must be male/female) / Invalid phone
- **401**: Unauthorized / Token invalid/expired
- **403**: Forbidden
- **404**: User not found → **Trigger app reset to splash**
- **422**: Validation failed

**Frontend Action:**
1. Cache updated user data
2. Emit `AuthProfileUpdated(updatedUser)` state
3. Show "Profile updated successfully"
4. Optionally refresh full profile from backend
5. Stay on ProfileInfoScreen or navigate back

---

## Phase 8: Error Handling & Edge Cases

### 8.1: Global Error Mapping

| Status Code | Message | Frontend Action |
|-------------|---------|-----------------|
| **400** | Validation error | Show field-specific error inline |
| **401** | Token expired | Retry with refresh token; if fails, navigate to login |
| **403** | Account inactive/disabled/blocked/suspended | Show user-friendly message about account restrictions |
| **404** | "No User matches the given query" | **Trigger `NuclearResetHelper.performResetAndGoToSplash()`** |
| **404** | Other resource not found | Show generic "Not found" error |
| **409** | Conflict (email exists) | Show "This email is already registered" |
| **422** | Validation error | Show detailed field errors |
| **429** | Rate limited | Show "Too many requests, try again later" |
| **5xx** | Server error | Show "Server error, try again later" |

---

### 8.2: Missing User (404) Handling

**Triggers:**
- Any endpoint returns 404 with `{"detail": "No User matches the given query."}`
- Scenario: Admin deleted user account while user is in the app

**Detection (Dio Interceptor):**
- Check: `statusCode == 404 && message.contains("No User matches the given query")`

**Action (Centralized in DioFactory):**
```dart
// In DioFactory.onError interceptor
if (_isMissingUserResponse(statusCode, responseData)) {
  await NuclearResetHelper.performResetAndGoToSplash(MyRoutes.splashScreen);
  // This clears everything and navigates to splash
}
```

**Result:**
- User is immediately taken to splash screen
- App state is fresh (like first install)
- No cached session data remains
- User can create new account or login if not actually deleted

---

### 8.3: Token Refresh Flow

**Trigger:** Any endpoint returns 401

**Flow:**
1. Dio interceptor detects 401
2. Attempts to refresh access_token using refresh_token
3. **Success:** Retry original request with new token
4. **Failure:** Clear tokens, navigate to login
5. **Race condition protection:** Serialize refresh requests using `Completer`

**Code:**
```dart
// In DioFactory.onError interceptor
if (unauthorized && !alreadyRetried) {
  final refreshed = await _tryRefreshToken(dio);
  if (refreshed) {
    // Retry request
  } else {
    // Clear tokens and navigate to login
    await NuclearResetHelper.performResetAndGoToSplash(MyRoutes.splashScreen);
  }
}
```

---

### 8.4: Inactive Account (403) Handling

**Response:**
```json
{
  "detail": "This account is inactive or restricted on the server"
}
```

**Detection:**
- Message contains: "inactive", "disabled", "blocked", "suspended", "deactivated"

**Frontend Action:**
- Show professional user-facing message:
  - "This account is inactive or restricted. Please contact support if you believe this is an error."
- Do NOT clear session (user may regain access)
- Do NOT navigate away automatically
- Show "Contact Support" button if available

**Where Handled:**
- `AuthCubit.login()` method checks `_isInactiveAccountError()`

---

### 8.5: Session Restoration on App Cold Start

**Flow (SplashScreen):**
1. Check for pending signup session
   - If exists: Navigate to VerifyAccountScreen (user was in OTP verification)
2. Check for cached access token
   - If exists and valid: Call `restoreSession()`
3. `restoreSession()` does:
   - Emit `AuthLoaded(cachedUser)`
   - Call `refreshProfileFromBackend()` to sync with server
4. If refresh returns 404 (user deleted): Emit `AuthReset()` → Navigate to signup
5. If no token: Navigate to signup

**Error Handling in refreshProfileFromBackend():**
```dart
// If fetch returns 404 "No User matches..."
if (_isMissingUserError(failure.errorMessage)) {
  await _resetAuthStateAfterMissingUser(correlationId: cid);
  return false;
}
```

---

### 8.6: OTP Code Not Received

**Possible Causes:**
1. Email address incorrect/typo
2. OTP sent but landed in spam folder
3. Backend email service failure
4. User account already verified (no OTP sent)

**Frontend Handling:**
1. Show "Resend code" button after 60s countdown
2. Allow maximum 5 resend attempts (rate limited at 429)
3. Show alternative contact method if available
4. If 3+ attempts fail: Suggest checking spam folder

**Backend Response (429):**
```json
{
  "detail": "Too many resend requests. Please try again later."
}
```

---

### 8.7: Invalid OTP Scenarios

| Scenario | Response | Frontend Action |
|----------|----------|-----------------|
| Wrong code entered | 400: "Invalid OTP" | Show "Code is invalid, try again" |
| Code expired (>10min) | 400: "OTP expired" | Show "Code expired, request new code" |
| Too many attempts (>5) | 429: Rate limited | Show "Too many attempts, try later" |
| Code already used | 400: "OTP already used" | Show "This code was already used" |

---

### 8.8: Email Already Exists

**Scenario:** User tries to signup with email that already has unverified account

**Response (400):**
```json
{
  "detail": "User with this email already exists but not verified"
}
```

**Frontend Action:**
1. Cache pending signup data locally
2. Navigate to VerifyAccountScreen
3. Show "We sent a verification code to your email"
4. User enters code from existing OTP

---

### 8.9: Request Timeout

**Timeout Values:**
- Connection timeout: 20 seconds
- Send timeout: 20 seconds
- Receive timeout: 20 seconds

**Frontend Action:**
- Show "Connection timed out, please try again"
- Retry logic should be at UI layer (retry button)
- Do NOT auto-retry in interceptor

---

### 8.10: Network Disconnection

**Detection:**
- DioException type: `connectionError`

**Frontend Action:**
- Show "No internet connection"
- Offer "Retry" button
- Do NOT navigate away
- Persist form data

---

## Summary Table: All Endpoints

| Phase | Endpoint | Method | Auth | Purpose |
|-------|----------|--------|------|---------|
| 1.1 | `/api/patients/register/` | POST | ✗ | Create account |
| 1.2 | `/api/users/otp/resend` | POST | ✗ | Resend verification code |
| 1.3 | `/api/users/otp/verify` | POST | ✗ | Verify OTP (signup/login) |
| 1.4 | `/api/patients/profile/` | PATCH | ✓ | Complete profile (signup) |
| 2.1 | `/api/users/login/` | POST | ✗ | Login |
| 3.1 | `/api/users/logout/` | POST | ✓ | Logout |
| 4.1 | `/api/users/account/delete/` | DELETE | ✓ | Delete account |
| 5.1 | `/api/users/auth/forgot-password/` | POST | ✗ | Request password reset OTP |
| 5.2 | `/api/users/auth/verify-otp/` | POST | ✗ | Verify password reset OTP |
| 5.3 | `/api/users/auth/reset-password/` | POST | ✗ | Reset password |
| 6.1 | `/api/users/password/change` | POST | ✓ | Change password (settings) |
| 7.1 | `/api/patients/profile/` | GET | ✓ | Fetch profile |
| 7.2 | `/api/patients/profile/` | PATCH | ✓ | Update profile |

---

## Critical Implementation Notes

### Token Management
- Access token is stored in `TokenStorage.saveTokens(accessToken, refreshToken)`
- Access token is attached to all authenticated requests via Dio interceptor
- Refresh token is used only in token refresh flow
- **Both tokens must be cleared together on logout/account deletion/401 failure**

### Profile Completion Check
```dart
bool _isUserProfileComplete(UserAuthEntity user) {
  return user.birthDate != null &&
      user.age != null &&
      user.gender != null &&
      user.gender!.isNotEmpty &&
      user.phoneNumber != null &&
      user.phoneNumber!.isNotEmpty;
}
```

### Missing User Reset (404 with "No User matches...")
- Triggered from Dio interceptor (centralized)
- Calls `NuclearResetHelper.performResetAndGoToSplash()`
- Clears SharedPreferences, token storage, caches, and DI graph
- Navigates to splash screen
- Next app cold start shows signup screen

### Gender Validation
- Backend expects: `"male"` or `"female"` (lowercase English)
- Frontend normalizes:
  - Input: "M", "F", "ذكر", "أنثى" → Output: "male", "female"
  - Must validate before sending to backend

### Phone Number Validation
- Required: 9-15 digits
- Allowed: Numbers + common separators (-, +, spaces)
- Backend stores: Digits only or formatted

### Birth Date Format
- Send: ISO 8601 format (`YYYY-MM-DD`)
- Example: `"2026-05-12"`

---

## Version History
| Date | Version | Changes |
|------|---------|---------|
| 2026-05-12 | 1.0 | Initial verified backend contract documentation |


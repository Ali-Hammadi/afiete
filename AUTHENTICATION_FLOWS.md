# Afiete Authentication - Functional Flows & State Transitions

## 1. Multi-Step Signup Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          SIGNUP JOURNEY                                  │
└─────────────────────────────────────────────────────────────────────────┘

SCREEN 1: SignupScreen (Enter credentials)
┌──────────────────────────────┐
│ Nickname: [_____________]    │
│ Email: [_________________]   │
│ Password: [______________]   │
│ [Sign Up Button]             │
└──────┬───────────────────────┘
       │
       └──→ authCubit.signup(nickname, email, password)
            ├─→ SignupUseCase → BackendRepository
            │   └─→ POST /api/auth/signup/
            │       ├─→ Validate email uniqueness
            │       ├─→ Generate OTP code
            │       └─→ Send OTP to email
            │
            ├─ emit(AuthLoading)
            │
            └─→ Result: OtpEntity
                ├─→ FAILURE: emit(AuthError("Email already registered"))
                │   └─→ Show inline error, keep form filled
                │
                └─→ SUCCESS: emit(OtpSent(email, expiresInSeconds))
                    └─→ Navigate to VerifyOtpScreen


SCREEN 2: VerifyOtpScreen (Verify OTP code)
┌──────────────────────────────┐
│ We sent a code to:           │
│ user@example.com             │
│                              │
│ Enter 6-digit code:          │
│ [_][_][_][_][_][_]          │
│                              │
│ [Resend OTP] (60s timer)     │
│                              │
│ [Verify] [Cancel]            │
└──────┬───────────────────────┘
       │
       └──→ authCubit.verifySignupOtp(email, otpCode)
            ├─→ VerifySignupOtpUseCase → BackendRepository
            │   └─→ POST /api/auth/verify-signup-otp/
            │       ├─→ Validate OTP code
            │       ├─→ Set is_verified = true
            │       └─→ **CRITICAL**: Login user to get access_token
            │
            ├─ emit(OtpLoading)
            │
            └─→ Result: UserAuthEntity (with accessToken)
                ├─→ FAILURE: emit(OtpError("Invalid OTP. Try again."))
                │   └─→ Show error, keep OTP input
                │
                └─→ SUCCESS: _cacheTokens(user)
                    │
                    ├─→ Check: user.isProfileComplete?
                    │   ├─ FALSE: emit(SignupOtpVerified(user))
                    │   │         └─→ Navigate to CompleteProfileScreen
                    │   │
                    │   └─ TRUE: emit(AuthLoaded(user)) [rare]
                    │            └─→ Navigate to HomeScreen
                    │
                    └─→ Store: _pendingSignupUser = user


SCREEN 3: CompleteProfileScreen (Fill required profile fields)
┌──────────────────────────────┐
│ Complete Your Profile        │
│                              │
│ Date of Birth:               │
│ [MM/DD/YYYY picker]          │
│                              │
│ Gender:                      │
│ ◯ Male  ◯ Female  ◯ Other  │
│                              │
│ Phone Number:                │
│ [+1 (__) ___-____]          │
│                              │
│ [Continue]                   │
└──────┬───────────────────────┘
       │
       └──→ authCubit.completeProfile(
           dateOfBirth, gender, phoneNumber
          )
            ├─→ UpdateProfileInfoUseCase → BackendRepository
            │   └─→ PATCH /api/auth/profile/
            │       (with Bearer {access_token})
            │       └─→ Update user profile fields
            │
            ├─ emit(AuthLoading)
            │
            └─→ Result: UserAuthEntity (complete)
                ├─→ FAILURE: emit(ProfileUpdateError("Phone format invalid"))
                │   └─→ Show inline error
                │
                └─→ SUCCESS: emit(AuthLoaded(user))
                    └─→ Navigate to HomeScreen


┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • OTP verification MUST call login endpoint to get access_token         │
│ • Token caching happens IMMEDIATELY after OTP verification              │
│ • Profile completion requires authenticated request (token in header)   │
│ • No token = updateProfileInfo fails with 401 error                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Login Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          LOGIN JOURNEY                                   │
└─────────────────────────────────────────────────────────────────────────┘

SCREEN 1: LoginScreen (Enter credentials)
┌──────────────────────────────┐
│ Email: [________________]     │
│ Password: [______________]   │
│ [Forgot Password?]           │
│                              │
│ [Sign In Button]             │
│                              │
│ [Sign Up] [Google Sign-In]   │
└──────┬───────────────────────┘
       │
       └──→ authCubit.login(email, password)
            ├─→ LoginUseCase → BackendRepository
            │   └─→ POST /api/auth/login/
            │       └─→ Validate credentials
            │
            ├─ emit(AuthLoading)
            │
            └─→ Result: UserAuthEntity (with accessToken, profile)
                ├─→ FAILURE:
                │   ├─ Email not found: emit(AuthError("Email not registered"))
                │   ├─ Wrong password: emit(AuthError("Invalid password"))
                │   ├─ Account inactive: emit(AuthError("Account is inactive..."))
                │   └─→ Keep form, show error
                │
                └─→ SUCCESS: _cacheTokens(user)
                    │
                    ├─→ Check: user.isProfileComplete?
                    │   ├─ FALSE: emit(ProfileIncomplete(user))
                    │   │         └─→ Navigate to CompleteProfileScreen
                    │   │            (user still needs to fill DOB, Gender, Phone)
                    │   │
                    │   └─ TRUE: emit(AuthLoaded(user))
                    │            └─→ Navigate to HomeScreen
                    │
                    └─→ Home: Fetch additional data (doctors, bookings, etc.)


┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • Cache token immediately after successful login                        │
│ • Check if profile is complete; redirect if incomplete                  │
│ • If user never completed signup, show CompleteProfileScreen            │
│ • If all done, show HomeScreen                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Password Recovery Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      FORGOT PASSWORD JOURNEY                             │
└─────────────────────────────────────────────────────────────────────────┘

SCREEN 1: ForgotPasswordScreen (Request OTP)
┌──────────────────────────────┐
│ Forgot Password?             │
│                              │
│ Enter your email address:    │
│ [________________]           │
│                              │
│ [Send Recovery Code]         │
│ [Back to Login]              │
└──────┬───────────────────────┘
       │
       └──→ authCubit.requestForgotPasswordOtp(email)
            ├─→ RequestForgotPasswordOtpUseCase → BackendRepository
            │   └─→ POST /api/auth/forgot-password/
            │       └─→ Validate email exists
            │       └─→ Generate OTP
            │       └─→ Send to email
            │
            ├─ emit(OtpLoading)
            │
            └─→ Result: OtpEntity
                ├─→ FAILURE: emit(OtpError("Email not found"))
                │
                └─→ SUCCESS: emit(OtpSent(email, expiresInSeconds))
                    └─→ Navigate to VerifyOtpScreen(flow: 'forgot_password')


SCREEN 2: VerifyOtpScreen (Verify OTP)
┌──────────────────────────────┐
│ We sent a code to:           │
│ user@example.com             │
│                              │
│ Enter code:                  │
│ [_][_][_][_][_][_]          │
│                              │
│ [Verify] [Resend]            │
└──────┬───────────────────────┘
       │
       └──→ authCubit.verifyForgotPasswordOtp(
           email, otpCode, newPassword
          )
            ├─→ VerifyForgotPasswordOtpUseCase → BackendRepository
            │   └─→ POST /api/auth/verify-forgot-password-otp/
            │       └─→ Validate OTP
            │       └─→ Update password in DB
            │       └─→ Return success
            │
            ├─ emit(OtpLoading)
            │
            └─→ Result: OtpEntity (or success message)
                ├─→ FAILURE: emit(OtpError("Invalid OTP"))
                │
                └─→ SUCCESS: 
                    ├─→ _cacheTokens(user) [if login happens]
                    ├─→ auto-login(email, newPassword)
                    │   └─→ Calls login() → OtpLoading
                    └─→ emit(AuthLoaded(user))
                        └─→ Navigate to HomeScreen


SCREEN 3: ResetPasswordScreen (Enter new password)
┌──────────────────────────────┐
│ Create New Password          │
│                              │
│ New Password:                │
│ [________________]           │
│ (Must be 8+ chars)          │
│                              │
│ Confirm Password:            │
│ [________________]           │
│                              │
│ [Reset Password]             │
└──────┬───────────────────────┘
       │
       (Password validation happens on verifyOtp screen)


┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • RequestForgotPasswordOtp: No auth required (public endpoint)           │
│ • VerifyForgotPasswordOtp: Contains new password, triggers auto-login    │
│ • After password reset, user is logged in with new credentials          │
│ • If profile incomplete, redirect to CompleteProfileScreen              │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Session Management Flows

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      SESSION MANAGEMENT                                  │
└─────────────────────────────────────────────────────────────────────────┘

A. LOGOUT FLOW

ACTION: User clicks "Sign Out" in profile menu
        ↓
    authCubit.logout()
        ├─→ LogoutUseCase → BackendRepository
        │   └─→ POST /api/auth/logout/
        │       (with Bearer {access_token})
        │       └─→ Server invalidates token (optional)
        │
        ├─ emit(AuthLoading)
        │
        └─→ Result: void
            └─→ FAILURE or SUCCESS:
                └─→ _clearTokens() [Always clear, even if logout fails]
                └─→ _pendingSignupUser = null
                └─→ emit(AuthUnauthenticated)
                └─→ Navigate to SignupScreen


B. DELETE ACCOUNT FLOW

ACTION: User goes to Settings → Delete Account
        ↓
    [Confirmation Dialog]
    "This action cannot be undone.
     Enter email and password to confirm."
        ↓
    authCubit.deleteAccount(email, password)
        ├─→ DeleteAccountUseCase → BackendRepository
        │   └─→ DELETE /api/auth/delete-account/
        │       Body: { email, password }
        │       └─→ Hard delete user from database
        │       └─→ Cannot recover
        │
        ├─ emit(AuthLoading)
        │
        └─→ Result: void
            ├─→ FAILURE: emit(AuthError("Incorrect password"))
            │   └─→ Keep dialog, show error
            │
            └─→ SUCCESS:
                ├─→ _clearTokens()
                ├─→ emit(AuthUnauthenticated)
                ├─→ Show "Account deleted" snackbar
                └─→ Navigate to SignupScreen


C. FETCH PROFILE (On app resume / periodic refresh)

ACTION: User navigates to home or profile settings
        ↓
    authCubit.fetchProfile()
        ├─→ FetchProfileUseCase → BackendRepository
        │   └─→ GET /api/auth/profile/
        │       (with Bearer {access_token})
        │
        ├─ emit(AuthLoading)
        │
        └─→ Result: UserAuthEntity (fresh from server)
            ├─→ FAILURE:
            │   ├─ 401 Unauthorized (token expired):
            │   │  └─→ Attempt refresh token
            │   │  └─→ If refresh fails: logout & go to LoginScreen
            │   │
            │   └─→ Other errors: emit(AuthError(message))
            │
            └─→ SUCCESS: emit(AuthLoaded(user))
                └─→ Update UI with fresh profile data


┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • Logout clears tokens even if server call fails                        │
│ • Delete Account requires verification (email + password)               │
│ • Fetch Profile validates token freshness (implement refresh logic)     │
│ • 401 errors trigger token refresh or logout                            │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Profile Update Flows (Account Settings)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      PROFILE UPDATES                                     │
└─────────────────────────────────────────────────────────────────────────┘

A. SIMPLE UPDATE: Change Nickname
──────────────────────────────────

SCREEN: ProfileSettingsScreen
┌──────────────────────────────┐
│ Your Nickname:               │
│ [Current Value]              │
│ [Edit Button]                │
└──────┬───────────────────────┘
       │
       └─→ [Show inline edit field]
           [New Nickname: ____________]
           [Save] [Cancel]
           │
           └─→ authCubit.updateProfileInfo(nickname: newNickname)
               ├─→ UpdateProfileInfoUseCase
               │   └─→ PATCH /api/auth/profile/
               │       Body: { nickname: "newValue" }
               │       (Bearer {access_token})
               │
               ├─ emit(AuthLoading)
               │
               └─→ Result: UserAuthEntity
                   ├─→ FAILURE: emit(ProfileUpdateError("..."))
                   │
                   └─→ SUCCESS: emit(AuthLoaded(user))
                       └─→ Update UI, show "Saved" toast


B. SENSITIVE UPDATE: Change Password
─────────────────────────────────────

SCREEN: SecuritySettingsScreen
┌──────────────────────────────┐
│ Change Password              │
│                              │
│ Current Password:            │
│ [________________]           │
│                              │
│ New Password:                │
│ [________________]           │
│ (8+ chars, numbers, caps)   │
│                              │
│ Confirm Password:            │
│ [________________]           │
│                              │
│ [Update Password]            │
└──────┬───────────────────────┘
       │
       └─→ authCubit.updatePassword(
           currentPassword, newPassword
          )
            ├─→ UpdatePasswordUseCase
            │   └─→ POST /api/auth/change-password/
            │       Body: { 
            │         current_password, new_password 
            │       }
            │       (Bearer {access_token})
            │
            ├─ emit(AuthLoading)
            │
            └─→ Result: UserAuthEntity
                ├─→ FAILURE:
                │   ├─ Current password wrong:
                │   │  emit(ProfileUpdateError("Current password incorrect"))
                │   └─→ Show error, keep form
                │
                └─→ SUCCESS: emit(AuthLoaded(user))
                    └─→ Show "Password updated" toast
                    └─→ Auto-logout after 2s to re-login with new password


C. SENSITIVE UPDATE: Change Gender/Phone/DOB
──────────────────────────────────────────────

FLOW: Identical to password change
- User selects field
- App shows password verification modal first
  [Current Password: ___________]
  [Verify]
- If password correct: Show field edit screen
- Save calls updateProfileInfo() with password verified

Example: Change Phone Number
SCREEN: ProfileSettingsScreen
┌──────────────────────────────┐
│ Phone Number: +1 (555) 1234  │
│ [Edit Button]                │
└──────┬───────────────────────┘
       │
       └─→ [Show password verification modal]
           [Current Password: ___________]
           [Verify]
           │
           └─→ If verified:
               [Enter New Phone: +1 (___) ____-_____]
               [Save]
               │
               └─→ authCubit.updateProfileInfo(
                   phoneNumber: "+15551234567"
                  )
                  ├─→ PATCH /api/auth/profile/
                  │   (Bearer {access_token})
                  │
                  └─→ SUCCESS: emit(AuthLoaded(user))


D. CHANGE EMAIL ADDRESS
──────────────────────────

FLOW:
1. User clicks "Change Email"
2. First, verify current password
3. Enter new email
4. App sends POST /api/auth/request-email-change/
5. OTP sent to NEW email address
6. User verifies OTP from new email
7. Email is changed in backend

SCREEN 1: Change Email Form
┌──────────────────────────────┐
│ Change Email Address         │
│ Current: user@old.com        │
│ Current Password:            │
│ [________________]           │
│ New Email:                   │
│ [________________]           │
│ [Send Verification Code]     │
└──────┬───────────────────────┘
       │
       └─→ authCubit.requestEmailChange()
           ├─→ RequestEmailChangeOtpUseCase
           │   └─→ POST /api/auth/request-email-change/
           │       (Bearer {access_token})
           │
           └─→ emit(OtpSent(...))
               └─→ Navigate to VerifyOtpScreen(flow: 'email_change')

SCREEN 2: Verify OTP from new email
[OTP verification screen, see #1 above]
   └─→ authCubit.confirmEmailChange(newEmail, otpCode)
       ├─→ ConfirmEmailChangeUseCase
       │   └─→ POST /api/auth/confirm-email-change/
       │       Body: { new_email, otp_code }
       │
       └─→ SUCCESS: emit(AuthLoaded(user))
                    └─→ Show "Email updated" toast
                    └─→ fetchProfile() to refresh

┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • Non-sensitive: Nickname (direct PATCH)                                │
│ • Sensitive: Password, Gender, Phone, DOB (password verification first) │
│ • Email change: Request OTP → Verify OTP (full 2-step)                  │
│ • All sensitive changes should re-verify identity for security          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6. Google Sign-In Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      GOOGLE SIGN-IN JOURNEY                              │
└─────────────────────────────────────────────────────────────────────────┘

SCREEN: LoginScreen or SignupScreen
┌──────────────────────────────┐
│ [Google Sign-In Button]      │
│ "Sign in with Google"        │
└──────┬───────────────────────┘
       │
       └─→ [Google OAuth Flow]
           ├─→ User taps Google button
           ├─→ Google Sign-In plugin shows modal
           ├─→ User selects Google account
           ├─→ User authorizes app
           └─→ Return idToken


       └─→ authCubit.googleSignIn(idToken)
           ├─→ GoogleSignInUseCase
           │   └─→ POST /api/auth/google-signin/
           │       Body: { id_token: "..." }
           │       └─→ Backend validates idToken with Google
           │       └─→ Creates or updates user
           │       └─→ Returns user + access_token
           │
           ├─ emit(AuthLoading)
           │
           └─→ Result: UserAuthEntity
               ├─→ FAILURE:
               │   ├─ Invalid token: emit(AuthError("Sign-in failed"))
               │   └─→ Show error
               │
               └─→ SUCCESS: _cacheTokens(user)
                   │
                   ├─→ Check: user.isProfileComplete?
                   │   ├─ FALSE: emit(ProfileIncomplete(user))
                   │   │         └─→ Navigate to CompleteProfileScreen
                   │   │
                   │   └─ TRUE: emit(AuthLoaded(user))
                   │            └─→ Navigate to HomeScreen
                   │
                   └─→ Merge account if email already exists


┌─────────────────────────────────────────────────────────────────────────┐
│ KEY POINTS:                                                              │
│ • Google plugin returns idToken (not user info)                         │
│ • Backend validates token with Google servers                           │
│ • Same profile completion check as regular signup                       │
│ • Auto-creates account if email doesn't exist                           │
│ • May require profile completion on first sign-in                       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 7. Navigation Decision Tree

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     NAVIGATION LOGIC (Root Router)                        │
└──────────────────────────────────────────────────────────────────────────┘

APP STARTS
    ↓
    └─→ Check: _hasValidToken()?
        │
        ├─ NO:  Navigate to SignupScreen
        │
        └─ YES: Call fetchProfile()
            ├─→ emit(AuthLoading)
            │
            └─→ RESPONSE:
                ├─ AuthLoaded(user):
                │  └─→ Navigate to HomeScreen
                │
                ├─ ProfileIncomplete(user):
                │  └─→ Navigate to CompleteProfileScreen
                │      (user: user object)
                │
                ├─ 401 Unauthorized (token expired):
                │  ├─→ Attempt refresh token
                │  │   ├─ Refresh success: Navigate to HomeScreen
                │  │   └─ Refresh fail: Clear tokens
                │  │
                │  └─→ Navigate to LoginScreen
                │
                └─ AuthError:
                   └─→ Navigate to LoginScreen


SIGNUP FLOW NAVIGATION:
SignupScreen → [enter credentials]
    ↓
VerifyOtpScreen → [verify OTP]
    ├─ Profile complete: HomeScreen
    └─ Profile incomplete: CompleteProfileScreen
        ↓
        HomeScreen


LOGIN FLOW NAVIGATION:
LoginScreen → [enter credentials]
    ├─ Profile complete: HomeScreen
    └─ Profile incomplete: CompleteProfileScreen
        ↓
        HomeScreen


FORGOT PASSWORD NAVIGATION:
ForgotPasswordScreen → [enter email]
    ↓
VerifyOtpScreen → [verify OTP + new password]
    ├─ Auto-login success
    ├─ Profile complete: HomeScreen
    └─ Profile incomplete: CompleteProfileScreen
        ↓
        HomeScreen


PROFILE SETTINGS NAVIGATION:
HomeScreen → [user menu] → [Settings]
    ↓
ProfileSettingsScreen
    ├─ Change Nickname: inline edit
    ├─ Change Password: SecuritySettingsScreen
    ├─ Change Email: ChangeEmailScreen → VerifyOtpScreen
    ├─ Change Phone/Gender/DOB: PasswordVerifyModal → EditFieldScreen
    └─ Delete Account: ConfirmDeleteModal → [back to LoginScreen]


HOME NAVIGATION:
After login/signup complete, standard app navigation:
HomeScreen ↔ DoctorsScreen ↔ BookingsScreen ↔ ProfileSettingsScreen

Logout anywhere: → SignupScreen

```

---

## 8. State Machine Summary

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  AUTH CUBIT STATE MACHINE                                │
└─────────────────────────────────────────────────────────────────────────┘

                          ┌──────────────────┐
                          │  AuthInitial     │
                          │  (no state)      │
                          └────────┬─────────┘
                                   │
                ┌──────────────────┼──────────────────┐
                │                  │                  │
                ▼                  ▼                  ▼
         ┌────────────┐    ┌────────────────┐  ┌──────────────┐
         │ AuthLoading│    │  OtpSent       │  │ AuthLoaded   │
         │            │    │  (wait for OTP)│  │ (logged in)  │
         └──┬────┬────┘    └─────┬──────────┘  └──────┬───────┘
            │    │               │                     │
            │    └─ SUCCESS ─ emit ────────────────────┤
            │                │                         │
            └─ FAIL ─┐        └──→ VerifyOtp/         │
                     │            SignupOtpVerified   │
                     ▼                                │
                ┌──────────┐                          │
                │ AuthError│ ◄──────────────────────┘
                │ (failure)│
                └──────────┘


STATES:
├─ AuthInitial           → No user state (fresh start)
├─ AuthLoading           → API call in progress
├─ OtpLoading            → OTP request/verification in progress
├─ OtpSent               → OTP sent, waiting for user input
├─ SignupOtpVerified     → OTP verified, needs profile completion
├─ AuthLoaded            → User authenticated, profile complete
├─ ProfileIncomplete     → Logged in, needs profile completion
├─ ProfileUpdateError    → Profile update failed
├─ AuthError             → Auth operation failed (login/signup/etc)
├─ OtpError              → OTP verification failed
└─ AuthUnauthenticated   → Logged out, clear state


TRANSITIONS:
signup()
  AuthInitial → AuthLoading → OtpSent
           or → AuthLoading → AuthError

verifySignupOtp()
  OtpSent → OtpLoading → SignupOtpVerified (token cached)
         or → OtpLoading → OtpError

completeProfile()
  SignupOtpVerified → AuthLoading → AuthLoaded
                   or → AuthLoading → ProfileUpdateError

login()
  AuthInitial → AuthLoading → AuthLoaded
             or → AuthLoading → ProfileIncomplete
             or → AuthLoading → AuthError

logout()
  AuthLoaded → AuthLoading → AuthUnauthenticated
            or (fail) → AuthUnauthenticated (token cleared anyway)

deleteAccount()
  AuthLoaded → AuthLoading → AuthUnauthenticated
            or → AuthLoading → AuthError

fetchProfile()
  AuthLoaded → AuthLoading → AuthLoaded (same state, data refreshed)
            or → AuthLoading → AuthError


┌─────────────────────────────────────────────────────────────────────────┐
│ IMPORTANT:                                                               │
│ • Multiple states can trigger same screen (OtpSent for signup/forgot)   │
│ • State determines which cubit action to call on screen                 │
│ • Token caching happens immediately after successful auth               │
│ • Errors don't clear token (unless 401, then refresh)                  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

**Last Updated**: 2026-05-09  
**Document Type**: Functional Specification (Flows & State Transitions)

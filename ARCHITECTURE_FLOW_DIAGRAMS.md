# Architecture & Flow Diagrams

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     AFIETE FLUTTER APP                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐                                            │
│  │  PRESENTATION    │                                            │
│  ├──────────────────┤                                            │
│  │ • ProfileScreen  │  User Actions                              │
│  │ • PasswordScreen │  (Edit, Change)                            │
│  │ • Dialogs        │                                            │
│  └────────┬─────────┘                                            │
│           │                                                      │
│           │ BlocBuilder watches state                            │
│           ▼                                                      │
│  ┌──────────────────┐                                            │
│  │   STATE MGMT     │                                            │
│  ├──────────────────┤                                            │
│  │ • AuthCubit      │  ┌─ changePassword()                       │
│  │   - Cubits       │  │  updateProfileInfo()                    │
│  │   - States       │  │  confirmEmailChange()                   │
│  │ • emit()         │  │  refreshProfileFromBackend()            │
│  │ • fold()         │  └─ Manages state transitions              │
│  └────────┬─────────┘                                            │
│           │                                                      │
│           │ Injects Repository                                   │
│           ▼                                                      │
│  ┌──────────────────┐                                            │
│  │   DOMAIN LAYER   │                                            │
│  ├──────────────────┤                                            │
│  │ • UseCases       │  Business Logic                            │
│  │ • Repositories   │  Error Handling                            │
│  │ • Entities       │  Return Either<Failure, Success>           │
│  │ • Failures       │                                            │
│  └────────┬─────────┘                                            │
│           │                                                      │
│           │ Calls Repository                                     │
│           ▼                                                      │
│  ┌──────────────────┐                                            │
│  │   DATA LAYER     │                                            │
│  ├──────────────────┤                                            │
│  │ • DataSource     │  REST API Calls                            │
│  │ • Dio HTTP       │  JSON Serialization                        │
│  │ • TokenStorage   │  Cache Management                          │
│  │ • SharedPrefs    │  (SharedPreferences)                       │
│  └────────┬─────────┘                                            │
│           │                                                      │
│           │ HTTP Requests                                        │
│           ▼                                                      │
│  ┌──────────────────┐                                            │
│  │  BACKEND API     │                                            │
│  ├──────────────────┤                                            │
│  │ • JWT Token      │  POST /change-password                     │
│  │ • Authentication │  PUT /profile                              │
│  │ • Database       │  GET /profile (fetch)                      │
│  │ • Validation     │                                            │
│  └──────────────────┘                                            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Password Change Flow

```
USER INTERFACE
===============

User opens Settings
        ↓
  [Profile Info Screen]
        ↓
User clicks "Edit" password
        ↓
  ┌─────────────────────────┐
  │  Password Change Dialog  │
  ├─────────────────────────┤
  │ Old Password: [_______] │
  │ New Password: [_______] │
  │ Confirm:     [_______] │
  │             [SAVE]      │
  └─────────────┬───────────┘
                │
                ▼ Validation
         ┌──────────────┐
         │ Form Valid?  │
         └──────┬───────┘
                │
         ┌──────┴──────┐
         │             │
        NO             YES
         │              │
         │              ▼
         │         [Loading spinner]
         │              │
         │              ▼ authCubit.changePassword()


STATE MANAGEMENT LAYER
=======================

changePassword(email, currentPassword, newPassword)
        │
        ├─ Log: 'change_password:start'
        │
        ▼
authRepository.changePassword()
        │
        ├─ Returns Either<Failure, String>
        │
        ├─ On Failure (Left):
        │   ├─ Log error
        │   └─ emit(AuthError(message))
        │
        ├─ On Success (Right):
        │   ├─ Log 'change_password:success'
        │   │
        │   ├─ Update local user:
        │   │   user = user.copyWith(password: newPassword)
        │   │
        │   ├─ Cache update:
        │   │   _cacheAndEmitUser(user, asProfileUpdated: true)
        │   │   └─ authRepository.cacheSession()
        │   │   └─ emit(AuthProfileUpdated(user))
        │   │
        │   ├─ Background refresh:
        │   │   refreshProfileFromBackend()
        │   │   └─ Fetch fresh data from backend
        │   │   └─ Merge & re-cache
        │   │   └─ emit(AuthProfileUpdated(freshUser))
        │   │
        │   └─ Return true
        │
        ▼ BlocListener

USER INTERFACE (Updated)
========================

        ┌─────────────────┐
        │  Success!       │
        │ "Password       │
        │  changed"       │
        └────────┬────────┘
                 │
                 ├─ Snackbar shown
                 │
                 ├─ Profile refreshed
                 │
                 └─ Dialog closes

        ┌─────────────────┐
        │ Profile Info    │
        │ Screen (Updated)│
        │ - Password:     │
        │   ••••••••••    │
        │ - All fields    │
        │   synced        │
        └─────────────────┘

DATA PERSISTENCE
=================

SharedPreferences
├─ Key: 'auth_cached_user'
├─ Value: JSON
│  ├─ username: "john"
│  ├─ email: "john@example.com"
│  ├─ password: "new_hashed_pwd"  ← UPDATED
│  ├─ nickname: "John"
│  ├─ birthDate: "1990-01-15"
│  ├─ gender: "Male"
│  ├─ phoneNumber: "+1234567890"
│  ├─ token: "jwt_token"
│  └─ isVerified: true
│
TokenStorage (Separate)
├─ Key: 'auth_token'
└─ Value: "jwt_token"

BACKEND
=======

API Endpoint: POST /api/auth/change-password
    │
    ├─ Header: Authorization: Bearer {token}
    │
    ├─ Body:
    │  ├─ email: "john@example.com"
    │  ├─ current_password: "old_pwd"
    │  └─ new_password: "new_pwd"
    │
    ├─ Validation:
    │  ├─ User exists?
    │  ├─ Current password correct?
    │  └─ New password meets requirements?
    │
    ├─ Success (200):
    │  ├─ Hash new password
    │  ├─ Update user.password in DB
    │  └─ Return: {message: "Password changed"}
    │
    └─ Error (400/401/500):
       └─ Return error message
```

## Profile Update Flow (Other Fields)

```
USER INTERFACE
===============

Settings → Profile Info Screen
        │
        ├─ Display:
        │  ├─ Nickname: "John"
        │  ├─ Email: "john@example.com"
        │  ├─ Gender: "Male"
        │  ├─ Birth Date: "01/15/1990"
        │  └─ Phone: "+1234567890"
        │
        │ User clicks "Edit" on any field
        │
        ▼ Show appropriate dialog
        │
   ┌────────────────────────┐
   │ Dialog (Field Type)    │
   │ • TextFormField (text) │
   │ • DatePicker (date)    │
   │ • Radio buttons (enum) │
   ├────────────────────────┤
   │ [Cancel]  [Save]       │
   └────────┬───────────────┘
            │
            ▼

STATE MANAGEMENT
=================

_editField(user) 
        │
        ├─ Get value from dialog
        │
        ▼ Field changed?
        │
   ┌─ YES ─────────────────────────────┐
   │                                    │
   ▼                                    │
_saveProfileInfo(user, fieldValue)     │
        │                               │
        ├─ Log 'update_profile:start'   │
        │                               │
        ├─ Call:                        │
        │ authCubit.updateProfileInfo(  │
        │   nickname: ?, birthDate: ?,  │
        │   gender: ?, phoneNumber: ?   │
        │ )                             │
        │                               │
        ▼                               │
updateProfileInfoUseCase.call()        │
        │                               │
        ├─ Returns:                     │
        │ Either<Failure, UserEntity>   │
        │                               │
        ├─ On Failure:                  │
        │   └─ emit(AuthError)          │
        │   └─ Show error snackbar      │
        │                               │
        ├─ On Success:                  │
        │   ├─ Log 'update:success'     │
        │   │                           │
        │   ├─ Merge user:              │
        │   │   updated = _mergeWith()  │
        │   │                           │
        │   ├─ Cache immediately:       │
        │   │   _cacheAndEmitUser()     │
        │   │   └─ Save to SharedPrefs  │
        │   │   └─ emit(AuthProfileUp.) │
        │   │   └─ UI rebuilds          │
        │   │                           │
        │   └─ Background refresh:      │
        │       refreshProfileFromBackend()
        │       │                       │
        │       ├─ Fetch GET /profile   │
        │       ├─ Merge response       │
        │       ├─ Re-cache             │
        │       └─ emit(AuthProfileUp.) │
        │                               │
        └─────────────────────────────┘

UI UPDATES
===========

[Loading indicator shown]
        │
        ▼ (50-100ms)

Profile field updated instantly
from cache:
    User sees nickname changed
    immediately
        │
        │ (Async in background)
        │
        ▼ (500-1500ms later)

Full profile refreshed
from backend:
    If any discrepancy,
    corrected value shown
        │
        ▼

Snackbar: "Profile updated"
        │
        ▼

User continues working
```

## Email Change Flow (Special)

```
USER OPENS EMAIL EDIT
═══════════════════════

[Email Change Dialog]
    │
    ├─ Password: [_______]
    ├─ New Email: [_______]
    │
    └─ [Cancel]  [Save]
         │
         ▼

STATE: requestEmailChangeWithPassword()
════════════════════════════════════════

API: POST /request-email-change
Body: {email, password, newEmail}
        │
        ├─ Backend validates
        │
        ├─ Generates OTP
        │
        └─ Sends email to newEmail
             with OTP code
                │
                ▼

UI: "OTP sent to new email"
════════════════════════════

[OTP Verification Dialog]
    │
    ├─ OTP Code: [____]
    │
    └─ [Cancel]  [Verify]
         │
         ▼

STATE: confirmEmailChange()
════════════════════════════

API: POST /confirm-email-change
Body: {newEmail, otp}
        │
        ├─ Backend validates OTP
        │
        ├─ Updates user.email
        │
        └─ Returns updated user
                │
                ▼

Cubit:
    ├─ Update cache
    ├─ emit(AuthProfileUpdated)
    ├─ refreshProfileFromBackend()
    └─ Return true
        │
        ▼

UI: "Email updated successfully"
═════════════════════════════════

Profile shows:
    Email: new@example.com

All fields synced with backend
```

## Cache & Persistence Strategy

```
OPERATION SEQUENCE
═══════════════════

1. IMMEDIATE (0-50ms)
   ┌─ User Action ─────────┐
   │ Edit password/field   │
   └──────────┬────────────┘
              │
              ▼
        Validate Input
              │
         ┌────┴────┐
        YES        NO
         │          └─ Show Error
         │
         ▼
    Call Backend API
    (Dio HTTP POST/PUT)
              │

2. BACKEND PROCESSING (200-1000ms)
   ┌──────────────────────────┐
   │ Backend                  │
   ├──────────────────────────┤
   │ • Validate input         │
   │ • Update database        │
   │ • Generate response      │
   │ • Send back             │
   └──────────────┬───────────┘
                  │
                  ├─ Success ──┐
                  │             │
                  ├─ Error      │
                  │             │
                  └─────────────┼─> Response
                                │

3. RECEIVE & PROCESS (100-500ms)
   ┌────────────────────────────┐
   │ Cubit receives response    │
   ├────────────────────────────┤
   │ If Error:                  │
   │   └─ emit(AuthError)       │
   │   └─ Show snackbar         │
   │                            │
   │ If Success:                │
   │   ├─ Update user via       │
   │   │   copyWith()           │
   │   │                        │
   │   ├─ IMMEDIATELY:          │
   │   │   _cacheAndEmitUser()  │
   │   │   └─ Call repository   │
   │   │       .cacheSession()  │
   │   │   └─ Save to           │
   │   │       SharedPreferences│
   │   │   └─ emit(AuthProfile) │
   │   │   └─ BlocBuilder       │
   │   │       rebuilds UI      │
   │   │                        │
   │   └─ (Async) Background:   │
   │       refreshProfileFrom.. │
   │       └─ GET /profile      │
   │       └─ Merge response    │
   │       └─ Re-cache          │
   │       └─ emit(AuthProfile) │
   │       └─ UI refreshes      │
   └────────────────────────────┘
                 │
                 ▼

4. LOCAL STORAGE
   ┌──────────────────────────┐
   │ SharedPreferences        │
   ├──────────────────────────┤
   │ Key:                     │
   │   'auth_cached_user'     │
   │                          │
   │ Value (JSON):            │
   │ {                        │
   │   username: "john",      │
   │   email: "john@...",     │
   │   password: "new_pwd",   │ ← UPDATED
   │   nickname: "John",      │
   │   birthDate: "1990...",  │
   │   gender: "Male",        │
   │   phoneNumber: "...",    │
   │   token: "jwt_token",    │
   │   isVerified: true       │
   │ }                        │
   │                          │
   │ Updated: 2x per operation
   │   1. Immediate with API  │
   │   2. After refresh       │
   └──────────────────────────┘
                 │
                 ▼

5. UI UPDATES
   ┌──────────────────────────┐
   │ BlocBuilder<AuthCubit>   │
   ├──────────────────────────┤
   │ Watches AuthState        │
   │                          │
   │ On AuthProfileUpdated:   │
   │   └─ Get user from state │
   │   └─ Update display      │
   │   └─ Show fresh data     │
   └──────────────────────────┘
```

## Error Handling Flow

```
ERROR SCENARIOS
════════════════

┌─ Invalid Input
│  │
│  └─> emit(AuthError)
│      └─> Snackbar: "Field required"
│          User retries
│
├─ Network Error
│  │
│  ├─ POST times out
│  │
│  └─> emit(AuthError)
│      └─> Snackbar: "Connection failed"
│      └─> Cache still valid
│      └─> User can retry
│
├─ Authentication Error (401)
│  │
│  ├─ Token expired
│  │
│  └─> emit(AuthError)
│      └─> Snackbar: "Session expired"
│      └─> Suggest re-login
│
├─ Validation Error (400)
│  │
│  ├─ Backend validation failed
│  │
│  └─> emit(AuthError)
│      └─> Snackbar: Backend message
│          (e.g., "Email already exists")
│          User corrects and retries
│
├─ Server Error (500)
│  │
│  ├─ Backend crashed
│  │
│  └─> emit(AuthError)
│      └─> Snackbar: "Server error"
│      └─> Cache still valid
│      └─> User can retry later
│
└─ Partial Success
   │
   ├─ API returns but partial data
   │
   └─> _mergeWithCurrentUser()
       └─ Keeps good data
       └─ Uses cached data for missing
       └─ No data loss
```

## State Transitions

```
USER STATES
════════════

AuthInitial
    │ (on app start)
    ├─ No user logged in
    ├─ No cache available
    │
    ▼

AuthLoading
    │ (transition state)
    ├─ Fetching from backend
    ├─ Usually not shown to user
    │
    ▼

AuthLoaded
    │ (stable state - login/restore)
    ├─ User object available
    ├─ Profile info displayed
    │
    ├─ User changes password ─┐
    ├─ User updates field ────┤─> emit(AuthProfileUpdated)
    ├─ User changes email ───┘
    │
    ▼

AuthProfileUpdated
    │ (after any profile change)
    ├─ User object with new data
    ├─ Profile refreshed from backend
    ├─ Back to normal operation
    │
    └─> Further changes emit AuthProfileUpdated again

AuthError
    │ (failure state)
    ├─ Error message available
    ├─ UI shows snackbar
    ├─ Previous state not cleared
    ├─ User can retry
    │
    └─> Retry action → back to previous state

WaitingForOtpVerification
    │ (special state for email change)
    ├─ User entered password + new email
    ├─ OTP sent
    ├─ Waiting for OTP input
    │
    ├─ User enters OTP ─> confirmEmailChange()
    │
    └─> Back to AuthProfileUpdated
```

---

This architecture ensures:
- ✅ Instant UI feedback (0-100ms)
- ✅ Background consistency (500-2000ms)
- ✅ Offline capability
- ✅ No data loss
- ✅ Proper error handling
- ✅ Type safety

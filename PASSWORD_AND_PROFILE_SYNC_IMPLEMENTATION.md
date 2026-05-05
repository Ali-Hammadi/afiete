# Password Change & Profile Sync Implementation Guide

## Overview
This document describes the implemented password change and profile data synchronization feature in the Afiete Flutter app. Users can now change their password and update all profile information with automatic backend synchronization.

## Features Implemented

### 1. **Password Change with Backend Sync** ✅
- User can change password from Profile Info screen
- New password is validated (min 6 characters, confirmation match)
- Backend validates and updates password
- Local cache is updated with new password
- Full profile is refreshed from backend to ensure consistency
- All subsequent API calls use new password if re-authentication needed

**UI Location**: Settings → Profile Info → Password Edit

### 2. **Profile Data Synchronization** ✅
- All profile field updates automatically sync with backend
- Supported fields:
  - Nickname
  - Email (with OTP verification)
  - Gender
  - Birth Date
  - Phone Number
  - Password

- Each update follows this flow:
  1. User edits field
  2. Backend API updates data
  3. Local cache updates immediately for fast UI response
  4. Full profile refreshed from backend
  5. UI updates automatically via BlocBuilder

### 3. **Automatic Cache Management** ✅
- UserAuthEntity cached in SharedPreferences after every update
- Profile data persists across app sessions
- Token storage managed separately
- Efficient merging of local and remote data

## Technical Implementation

### Modified Files

#### `lib/feature/auth/presentation/cubits/auth_cubit.dart`

**Method: `changePassword()`**
```dart
Future<bool> changePassword({
  required String email,
  required String currentPassword,
  required String newPassword,
}) async
```

**What it does**:
1. Calls `authRepository.changePassword()` to update backend
2. On success:
   - Updates cached user with new password
   - Caches updated user to SharedPreferences
   - Refreshes full profile from backend
3. Returns `true` on success, `false` on failure
4. Emits `AuthProfileUpdated` state for UI updates

**Code Flow**:
```
changePassword() 
  → authRepository.changePassword() [backend API call]
  → _cacheAndEmitUser() [update local cache]
  → refreshProfileFromBackend() [sync with backend]
  → Returns true/false
```

**Method: `updateProfileInfo()`**
```dart
Future<bool> updateProfileInfo({
  String? nickname,
  required DateTime birthDate,
  required String gender,
  String? phoneNumber,
}) async
```

**What it does**:
1. Calls `updateProfileInfoUseCase()` with profile data
2. On success:
   - Merges returned data with current user state
   - Caches updated user to SharedPreferences
   - **NEW**: Refreshes full profile from backend
3. Returns `true` on success, `false` on failure

**Code Flow**:
```
updateProfileInfo()
  → updateProfileInfoUseCase() [backend API call]
  → _mergeWithCurrentUser() [merge local + remote]
  → _cacheAndEmitUser() [update cache]
  → refreshProfileFromBackend() [NEW: sync with backend]
  → Returns true
```

**Method: `refreshProfileFromBackend()`**
```dart
Future<bool> refreshProfileFromBackend() async
```

**What it does**:
1. Fetches latest user data from backend
2. Merges with current user state (preserves token, cached data)
3. Caches merged user
4. Emits `AuthProfileUpdated` state
5. UI automatically rebuilds with fresh data

## Data Synchronization Flow

### Password Change Flow
```
User opens Profile Info Screen
         ↓
User taps "Edit" on Password field
         ↓
Dialog shows: Old Password, New Password, Confirm Password
         ↓
User enters values and taps "Save"
         ↓
changePassword() called
         ↓
Backend API: POST /api/auth/change-password
  Headers: Authorization: Bearer {token}
  Body: {email, currentPassword, newPassword}
         ↓
If Success (200):
  • Update local cache: user.password = newPassword
  • Save to SharedPreferences
  • Fetch fresh profile from backend
  • Emit AuthProfileUpdated state
  • UI shows "Password changed successfully"
         ↓
If Failure:
  • Emit AuthError state
  • Show error message to user
```

### Profile Field Update Flow
```
User opens Profile Info Screen
         ↓
User taps "Edit" on any field (nickname, email, gender, etc.)
         ↓
Dialog shows appropriate input (text field, date picker, radio buttons)
         ↓
User changes value and taps "Save"
         ↓
updateProfileInfo() called
         ↓
Backend API: PUT /api/auth/profile
  Headers: Authorization: Bearer {token}
  Body: {nickname, birthDate, gender, phoneNumber}
         ↓
If Success (200):
  • Merge response with current user
  • Save to SharedPreferences
  • Fetch fresh profile from backend
  • Emit AuthProfileUpdated state
  • UI shows "Profile updated successfully"
         ↓
If Failure:
  • Emit AuthError state
  • Show error message to user
```

### Email Change Flow (Special Handling)
```
User taps "Edit" on Email field
         ↓
Dialog shows: Current Password + New Email
         ↓
User enters values and taps "Save"
         ↓
requestEmailChangeWithPassword() called
         ↓
Backend API: POST /api/auth/request-email-change
  Sends OTP to new email address
         ↓
If Success:
  • Show snackbar: "OTP sent to new email"
  • Show OTP input dialog
         ↓
User enters OTP and taps "Verify"
         ↓
confirmEmailChange() called
         ↓
Backend API: POST /api/auth/confirm-email-change
  Body: {newEmail, otp}
         ↓
If Success (200):
  • Update user.email = newEmail
  • Save to SharedPreferences
  • Fetch fresh profile from backend [AUTO]
  • Emit AuthProfileUpdated state
  • Show "Email updated successfully"
         ↓
If Failure:
  • Show "Invalid OTP" or error message
```

## UI Integration

### ProfileInfoScreen Updates
The profile information screen automatically displays the latest data through BlocBuilder:

```dart
BlocConsumer<AuthCubit, AuthState>(
  builder: (context, state) {
    final user = _currentUser(state);  // Gets AuthLoaded or AuthProfileUpdated
    // Display user.nickname, user.email, user.password (as ••••), etc.
  },
)
```

**State Handling**:
- `AuthLoaded`: Initial login state
- `AuthProfileUpdated`: After any profile update (password, email, other fields)
- `AuthError`: Display error messages
- `AuthInitial`: Not logged in

**Auto-refresh on Screen Open**:
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AuthCubit>().refreshProfileFromBackend();
  });
}
```

## Caching Strategy

### SharedPreferences Storage
The user entity is cached in SharedPreferences with key `auth_cached_user`:

```dart
{
  "username": "john_doe",
  "nickname": "John",
  "email": "john@example.com",
  "password": "new_hashed_password",  // Updated after password change
  "token": "jwt_token",
  "isVerified": true,
  "birthDate": "1990-01-15T00:00:00.000Z",
  "age": 34,
  "gender": "Male",
  "phoneNumber": "+1234567890"
}
```

### Cache Update Timing
1. **Immediate Update** (after API success):
   - Local user entity updated via `copyWith()`
   - Saved to SharedPreferences
   - UI updated via `_cacheAndEmitUser()`

2. **Background Refresh**:
   - `refreshProfileFromBackend()` fetches fresh data
   - Merges with local state to preserve any pending data
   - Re-saves to SharedPreferences

### Cache Restoration
On app startup:
```dart
Future<bool> restoreSession() async {
  final cachedUser = await authRepository.getCachedSession();
  if (cachedUser != null) {
    emit(AuthLoaded(cachedUser));
    // Background refresh ensures fresh data
    await refreshProfileFromBackend();
    return true;
  }
  emit(AuthInitial());
  return false;
}
```

## Error Handling

### Password Change Errors
- **Invalid Current Password**: "Invalid current password"
- **Password Too Weak**: "Password must be at least 6 characters"
- **Network Error**: "Connection failed, please try again"
- **Server Error**: "Server error occurred, please try later"

### Profile Update Errors
- **Validation Error**: Field-specific validation messages
- **Email Already Exists**: "Email already registered"
- **Network Error**: "Connection failed, please try again"
- **Unauthorized**: "Session expired, please login again"

### Error Recovery
- Errors emitted as `AuthError` state
- UI shows snackbar with error message
- User can retry the action
- On retry, profile is not refreshed if update failed
- On success, full profile refresh ensures consistency

## Testing the Implementation

### Test Case 1: Change Password
1. Open Settings → Profile Info
2. Tap "Edit" on Password field
3. Enter old password (current)
4. Enter new password (min 6 chars)
5. Confirm new password
6. Tap "Save"
7. Expected: Success message, profile stays in sync

### Test Case 2: Update Profile Field
1. Open Settings → Profile Info
2. Tap "Edit" on any field (e.g., Nickname)
3. Enter new value
4. Tap "Save"
5. Expected: Field updated, profile refreshed from backend

### Test Case 3: Change Email
1. Open Settings → Profile Info
2. Tap "Edit" on Email field
3. Enter password and new email
4. Tap "Save"
5. Expected: "OTP sent to new email"
6. Enter OTP code
7. Tap "Verify"
8. Expected: "Email updated successfully", profile refreshed

### Test Case 4: Offline Behavior
1. Change a profile field
2. Disconnect internet
3. Field still shows updated value (from cache)
4. Reconnect internet
5. App syncs profile in background
6. Latest data from backend shown

### Test Case 5: Multi-field Update Consistency
1. Change password
2. Change another field (e.g., email) immediately after
3. Expected: Both changes persisted and synced

## API Contract (Backend Expected)

### Change Password Endpoint
```
POST /api/auth/change-password
Headers: Authorization: Bearer {token}
Body: {
  "email": "user@example.com",
  "current_password": "old_pass",
  "new_password": "new_pass"
}
Response (200): { "message": "Password changed successfully" }
```

### Update Profile Endpoint
```
PUT /api/auth/profile
Headers: Authorization: Bearer {token}
Body: {
  "username": "john_doe",
  "nickname": "John",
  "birth_date": "1990-01-15",
  "gender": "Male",
  "phone_number": "+1234567890"
}
Response (200): {
  "username": "john_doe",
  "nickname": "John",
  "email": "john@example.com",
  "birth_date": "1990-01-15",
  "gender": "Male",
  "phone_number": "+1234567890",
  ...other fields
}
```

### Fetch Profile Endpoint
```
GET /api/auth/profile
Headers: Authorization: Bearer {token}
Response (200): {
  "username": "john_doe",
  "nickname": "John",
  "email": "john@example.com",
  "birth_date": "1990-01-15",
  "gender": "Male",
  "phone_number": "+1234567890",
  "is_verified": true,
  ...other fields
}
```

## Architecture Benefits

### 1. **Offline First**
- UI updates immediately with local cache
- Backend sync happens asynchronously
- User sees instant feedback even on slow networks

### 2. **Eventual Consistency**
- Local cache updated immediately
- Backend refresh ensures accuracy
- Merge logic preserves pending local changes

### 3. **Automatic Sync**
- No manual refresh buttons needed
- Profile stays in sync automatically
- Background refresh on app open

### 4. **Type Safety**
- UserAuthEntity with all fields properly typed
- copyWith() pattern for immutable updates
- No null-coalescing issues

### 5. **State Management**
- Clean BLoC pattern with Cubit
- AuthLoaded and AuthProfileUpdated states separate concerns
- Error states properly captured

## Notes for Future Improvements

1. **Password Complexity Validation**: Add regex validation for strong passwords
2. **Rate Limiting**: Implement cooldown for password change attempts
3. **Security**: Hash password in local cache (already done in backend)
4. **Verification**: Add email verification on profile open
5. **Offline Sync Queue**: Queue changes made offline, sync when online
6. **Change Notification**: Show "changes synced successfully" notification
7. **Session Management**: Auto-logout if token expires during change
8. **Audit Log**: Backend should track password changes with timestamps

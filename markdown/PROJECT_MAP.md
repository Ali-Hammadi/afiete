# PROJECT_MAP

## [TECH_STACK]
- Flutter app (Dart)
- State management: flutter_bloc / cubit
- Networking: dio
- Local persistence/session: shared_preferences via TokenStorage + auth cache in AuthRepository
- DI: get_it
- Logging: core async-safe logger utility through loggerFor(...)

### Time And Dependency Snapshot
- System date (yyyy-MM): 2026-05
- Dependency check executed with flutter pub outdated on 2026-05
- Key stable updates available (not applied in this surgical task):
  - bloc 8.1.4 -> 9.2.1
  - flutter_bloc 8.1.6 -> 9.1.1
  - get_it 7.7.0 -> 9.2.1
  - google_sign_in 6.3.0 -> 7.2.0

## [SYSTEM_FLOW]
1. Signup step 1:
- User inputs nickname -> email -> password.
- App sends signup payload to backend.
- Backend sends OTP.

2. Signup step 2:
- User inputs OTP on verify screen.
- App verifies OTP with backend.
- Session tokens are cached immediately after successful OTP verification.
- App routes to profile completion screen auth_info_screen.

3. Signup step 3:
- User completes profile fields in auth_info_screen.
- App sends profile payload to backend.
- App caches merged authenticated user/session and routes to home.

4. Session persistence and app exit:
- Closing app uses Exit App action and does not call logout.
- Session remains cached and restored at splash if token/session exists.
- Logout remains explicit action that clears local session and tokens.

## [ARCHITECTURE]
- Feature-first layout:
  - feature/auth: signup, otp verify, profile completion, session states
  - feature/settings: logout and app-exit user actions
  - feature/splash: startup session restoration
- Surgical design decisions for this change:
  - No broad refactor.
  - Kept existing cubit/repository boundaries.
  - Added only one new UX branch in settings (Exit App) and one flow guarantee in AuthCubit (signup OTP always routes to profile completion).

## [ORPHANS & PENDING]
- None for requested scope.
- Optional future hardening (not required for current request):
  - Add widget tests for signup OTP -> auth_info navigation guarantee.
  - Add widget tests for Exit App dialog action path.

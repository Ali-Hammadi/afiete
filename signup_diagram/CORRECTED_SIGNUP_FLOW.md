=================================================================================================
                  CORRECTED MULTI-STEP SIGNUP & TOKEN MANAGEMENT FLOW (FINAL)
                      WITH ACCURATE STATE TRANSITIONS & TOKEN CACHING
=================================================================================================

================================= [ PHASE 1: REGISTRATION ] =====================================

┌─────────────────────┐        ┌───────────────────────┐        ┌───────────────────────────────┐
│   SignupScreen (UI) │        │      AuthCubit        │        │      BackendRepository        │
│                     │        │                       │        │                               │
│ 1. Enter Form Data: │ ──────>│ signup(               │ ──────>│ POST /api/patients/register/  │
│ - Nickname          │        │  nickname,            │        │ Body: {                       │
│ - Email             │        │  email,               │        │   "user": {                   │
│ - Password          │        │  password             │        │     "nickname": ...,          │
│                     │        │ )                     │        │     "email": ...,             │
│ [Sign Up]           │        │                       │        │     "password": ...           │
└──────┬──────────────┘        │ emit(AuthLoading)     │        │   }                           │
       │                       │                       │        │ }                             │
       │                       │                       │        │                               │
       │                       │ emit(OtpSent(         │<───────│ 1. Validate Uniqueness        │
       │                       │  email,               │        │ 2. Send 4-Digit OTP to Email  │
       │                       │  expiresInSeconds     │        │ 3. Return OtpEntity           │
       │                       │ ))                    │        │                               │
       │                       └──────┬────────────── ┘        └───────────────────────────────┘
       │                              │
       │<─────────────────────────────┘
       │
       └─ SignupScreen listener catches OtpSent
          └─> Navigate to VerifyOtpScreen(email)


====================== [ PHASE 2: VERIFICATION & TOKEN ACQUISITION ] ===============================

┌─────────────────────┐        ┌───────────────────────┐        ┌───────────────────────────────┐
│ VerifyOtpScreen(UI) │        │      AuthCubit        │        │      BackendRepository        │
│                     │        │                       │        │                               │
│ 1. Enter 4-Digit    │        │                       │        │ POST /api/auth/verify/        │
│    OTP [_][_][_][_] │ ──────>│ verifyOtp(email, otp)│ ──────>│ Body: {                       │
│ 2. Resend? [Timer]  │        │                       │        │   "email": ...,               │
│                     │        │ emit(AuthLoading)     │        │   "code": ...                 │
└─────────────────────┘        └───────────┬───────────┘        │ }                             │
                                           │                    │                               │
                                           │                    │ 1. Validate OTP Code         │
                                           │                    │ 2. Generate/Cache Tokens     │
                                           │                    │    OR return verified user   │
                                           │                    │    without tokens             │
                                           │                    │ 3. Return UserAuthEntity     │
                                           │                    │    (maybe with accessToken,   │
                                           │                    │     refreshToken)             │
                                           │<──────(Success)─────│                               │
                                           V                    └───────────────────────────────┘
                            ┌──────────────────────────────────┐
                            │  CRITICAL TOKEN CACHING POINT:   │
                            │ _cacheAndEmitUser() called here  │
                            │ Token saved to secure storage     │
                            │ (TokenStorage via SecurePrefs)    │
                            └──────────────┬───────────────────┘
                                           │
                                 ┌─────────────┴──────────────┐
                                 │                             │
                       Check: access token present?         
                                 │                             │
                          YES ◄─────────────►  NO            
                          │                    │             
                          V                    V             
                Check: profile complete?   Attempt login   
                       (birthDate &&         fallback using  
                        gender && phone)     pending password
                                 │                    │        
                          NO ◄─────────────►  YES    │        
                          │                    │      │        
                          V                    V      V        
                  ┌─────────────────┐   ┌──────────────┐   ┌──────────────┐
                  │ emit(            │   │  emit(       │   │ emit(AuthErr)│
                  │ SignupOtpVerified│   │ AuthLoaded)  │   │ if fallback  │
                  │ )               │   │              │   │ fails        │
                  └────────┬────────┘   └──────┬───────┘   └──────────────┘
                             │                   │             
                     Navigate to         Navigate to        
                     authInfoScreens      homeScreen        
                     (Complete Profile)                     


====================== [ PHASE 3: PROFILE COMPLETION (AUTHENTICATED) ] ==========================

┌─────────────────────────┐        ┌───────────────────────┐        ┌───────────────────────────────┐
│ AuthInfoScreen (UI)     │        │      AuthCubit        │        │     DIO AUTH INTERCEPTOR      │
│ aka CompleteProfile     │        │                       │        │                               │
│                         │        │                       │        │ 1. Request interceptor:      │
│ 1. Enter Data:          │ ──────>│ updateProfileInfo(   │        │    - Read token from Storage  │
│ - Date of Birth (picker)│        │  birthDate,          │ ──────>│    - Add Authorization Header │
│ - Gender (dropdown)     │        │  gender,             │        │      Authorization: Bearer {} │
│ - Phone (text)          │        │  phoneNumber         │        │                               │
│                         │        │ )                    │        │ 2. POST /api/auth/profile/   │
│ [Continue] button       │        │                      │        │ 3. Return updated User       │
└────────┬────────────────┘        │ emit(AuthLoading)    │        │    (isProfileComplete=true)  │
         │                         │                      │        └───────────────┬───────────────┘
         │                         │ emit(AuthLoaded)    │<───────────(Success)───┘
         │                         │        OR            │
         │                         │ emit(               │
         │                         │ ProfileUpdateError) │
         │                         └──────┬──────────────┘
         │                                │
         │<───────────────────────────────┘
         │
         └─ AuthInfoScreen listens to:
            - AuthLoaded → navigate to /home
            - ProfileUpdateError → show error inline


================================= [ PHASE 4: SESSION HANDLING (DIO INTERCEPTOR) ] =============
(Happens automatically in background for ANY future authenticated request)

       [ Any Subsequent Request via Dio ]
                 │
                 V
     [ Add Authorization Header ]
       (Dio interceptor reads cached token)
                 │
                 V
     [ Send Request with Bearer Token ]
                 │
                 ├─ HTTP 200 OK ────────────────────> Proceed normally
                 │
                 └─ HTTP 401 UNAUTHORIZED ──────────┐
                                                    │
                                        [ Error Interceptor ]
                                        │
                                        ├─ Lock interceptor (prevent duplicate refresh)
                                        │
                                        ├─ Read refresh_token from Secure Storage
                                        │
                                        ├─ POST /api/auth/refresh/
                                        │   (with refresh_token in body)
                                        │
                                        ├─ SUCCESS: Save new access_token + refresh_token
                                        │   └──> Retry original request with new token
                                        │
                                        └─ FAILURE: 
                                            ├─ emit(SessionExpired)
                                            ├─ Clear all cached tokens
                                            └─ Redirect to /signup


================================= [ PHASE 5: STATE MACHINE (FINAL) ] ===========================

SIGNUP FLOW STATES:
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│  AuthInitial                                                 │
│      │                                                       │
│      └──> signup() ─────> AuthLoading                        │
│                              │                              │
│                              ├─> OtpSent (email, expiry)    │
│                              │   (Navigate to VerifyScreen)  │
│                              │                              │
│                              └─> AuthError                  │
│                                  (Show error inline)        │
│                                                               │
│  OtpSent                                                     │
│      │                                                       │
│      └──> verifyOtp() ──> AuthLoading                       │
│                              │                              │
│                   ┌──────────┤                              │
│                   │          │                              │
│                   V          V                              │
│            (No token)    (Has token)                        │
│              Retry login   + Profile?                       │
│              fallback        │                              │
│                              ├─ NO: SignupOtpVerified      │
│                              │     (Navigate to Profile)   │
│                              │                              │
│                              └─ YES: AuthLoaded            │
│                                    (Navigate to Home)      │
│                                                               │
│  SignupOtpVerified                                           │
│      │                                                       │
│      └──> updateProfileInfo() ──> AuthLoading              │
│                                      │                      │
│                                      ├─> AuthLoaded         │
│                                      │   (Navigate to Home) │
│                                      │                      │
│                                      └─> ProfileUpdateError │
│                                          (Show error)       │
│                                                               │
└─────────────────────────────────────────────────────────────┘

LOGIN FLOW STATES:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  AuthInitial                                                │
│      │                                                      │
│      └──> login(email, password) ──> AuthLoading            │
│                                          │                  │
│                              ┌───────────┤                  │
│                              │           │                  │
│                              V           V                  │
│                          (Error)    (Success)               │
│                       AuthError    + Profile?               │
│                     (Show error)        │                   │
│                                         ├─ NO: Navigate to  │
│                                         │  AuthInfoScreen   │
│                                         │  (Complete it)    │
│                                         │                   │
│                                         └─ YES: AuthLoaded  │
│                                            (Go to Home)     │
│                                                             │
│  AuthLoaded ──────> Token expires ──> Auto-refresh via DIO  │
│  (Home screen)    (in background)     (No user action)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘


================================= [ KEY CORRECTIONS FROM DIAGRAM ] ==================================

1. ✅ OtpSent state: NOW EMITTED after signup (not WaitingForOtpVerification)
2. ✅ SignupOtpVerified state: NOW EMITTED after OTP verification if profile incomplete
3. ✅ Token caching: Happens IMMEDIATELY in verifyOtp() via _cacheAndEmitUser()
4. ✅ Profile completion: Uses authenticated request (token in Dio header)
5. ✅ States are specific: OtpSent, SignupOtpVerified, ProfileUpdateError (not generic)
6. ✅ Nested payload: signup() sends { "user": { ... } } to backend
7. ✅ OTP field name: Backend expects "code", NOT "otp_code"
8. ✅ Dio interceptor: Automatically adds Authorization header from cached token
9. ✅ Session refresh: Happens transparently without user intervention
10. ✅ Error handling: ProfileUpdateError state for profile completion failures

============================================================================================
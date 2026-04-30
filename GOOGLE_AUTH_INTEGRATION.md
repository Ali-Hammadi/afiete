# Google Authentication Integration Summary

## Frontend Status ✅

### Completed:
1. **Endpoint Updated**: Changed Google login route from `/api/auth/google-login` to **`/api/patients/google/auth/`**
2. **OAuth Web Client ID Integration**: Added `serverClientId` parameter to GoogleSignIn initialization to request `id_token`
3. **Error Handling**: Implemented comprehensive error handling with clear messages for:
   - Missing id_token
   - Configuration errors (ApiException 10)
   - Cancelled sign-ins
   - Google Play Services issues

### Current Issue:
- **ApiException: 10** (DEVELOPER_ERROR) — This is expected until Android OAuth client is configured in Google Cloud Console
- The Flutter app is correctly sending the `id_token` to the backend endpoint

---

## Backend Implementation Required ✅

### Endpoint: `POST /api/patients/google/auth/`

**Purpose**: Accept Google `id_token`, verify it, and create/authenticate a patient user.

### Request Body:
```json
{
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEyMzQ..."
}
```

### Response (Success - 200/201):
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": "user-uuid",
    "username": "john@example.com",
    "email": "john@example.com",
    "nickname": "john",
    "is_verified": true,
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

### Response (Error - 400):
```json
{
  "message": "Invalid id_token or verification failed"
}
```

---

## Implementation Checklist for Backend Team:

1. **Install google-auth library**:
   ```bash
   pip install google-auth google-auth-httplib2 google-auth-oauthlib
   ```

2. **Create Django View**:
   ```python
   from rest_framework.views import APIView
   from rest_framework.response import Response
   from rest_framework import status
   from google.auth.transport import requests as google_requests
   from google.oauth2 import id_token
   from django.conf import settings
   
   class GoogleAuthView(APIView):
       def post(self, request):
           id_token_str = request.data.get('id_token')
           
           if not id_token_str:
               return Response(
                   {'message': 'id_token is required'},
                   status=status.HTTP_400_BAD_REQUEST
               )
           
           try:
               # Verify id_token using Google's public certificates
               idinfo = id_token.verify_oauth2_token(
                   id_token_str,
                   google_requests.Request(),
                   audience=settings.GOOGLE_OAUTH_CLIENT_ID  # Web Client ID
               )
               
               # Extract user info
               email = idinfo.get('email')
               name = idinfo.get('name', '')
               
               # Create or update patient user
               patient, created = Patient.objects.get_or_create(
                   email=email,
                   defaults={
                       'username': email,
                       'nickname': name or email.split('@')[0],
                       'is_verified': True
                   }
               )
               
               # Generate JWT tokens
               access_token = generate_access_token(patient)
               refresh_token = generate_refresh_token(patient)
               
               return Response({
                   'access_token': access_token,
                   'refresh_token': refresh_token,
                   'user': {
                       'id': str(patient.id),
                       'username': patient.username,
                       'email': patient.email,
                       'nickname': patient.nickname,
                       'is_verified': patient.is_verified,
                       'token': access_token
                   }
               }, status=status.HTTP_200_OK)
               
           except ValueError as e:
               return Response(
                   {'message': f'Invalid id_token: {str(e)}'},
                   status=status.HTTP_400_BAD_REQUEST
               )
           except Exception as e:
               return Response(
                   {'message': 'Authentication failed'},
                   status=status.HTTP_500_INTERNAL_SERVER_ERROR
               )
   ```

3. **Register URL**:
   ```python
   # urls.py
   from django.urls import path
   from .views import GoogleAuthView
   
   urlpatterns = [
       path('api/patients/google/auth/', GoogleAuthView.as_view(), name='google_auth'),
   ]
   ```

4. **Settings Configuration**:
   ```python
   # settings.py
   GOOGLE_OAUTH_CLIENT_ID = 'your-web-client-id.apps.googleusercontent.com'
   ```

---

## Frontend -> Backend Flow:

```
User taps "Sign in with Google"
    ↓
GoogleSignIn.signIn() → requests id_token
    ↓
App sends: POST /api/patients/google/auth/ 
           { "id_token": "..." }
    ↓
Backend verifies id_token using Google's public keys
    ↓
Backend creates/updates Patient record
    ↓
Backend returns JWT tokens + user info
    ↓
Frontend saves tokens & caches user session
    ↓
User logged in ✓
```

---

## Testing the Integration:

Once the backend view is implemented:

1. Frontend will automatically connect and test
2. No further client changes needed
3. Monitor logs for any token validation errors

---

## Current Frontend Details:

- **Web Client ID Used**: `1003547921607-12juc731vap30cbmmfjtkf38tr09ck8b.apps.googleusercontent.com`
- **Endpoint**: `/api/patients/google/auth/`
- **Token Key**: `id_token`
- **Android Package**: `com.example.afiete`


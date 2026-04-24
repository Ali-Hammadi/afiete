# Afiete Django Backend Requirements

## Objective
This document defines exactly what the Django backend team should implement for the Flutter app to work end-to-end.

It includes:
- Required endpoints
- Required request keys, query parameters, and response keys
- Authentication and authorization rules
- Validation and error response contracts
- Implementation checklist for backend delivery

## Base API Rules

### Base URL
- Production base URL: `https://workserveys.pythonanywhere.com`
- API prefix: `/api`

### Authentication
- Use JWT bearer auth for protected endpoints.
- Header format: `Authorization: Bearer <access_token>`
- Token endpoints:
	- `POST /api/token/`
	- `POST /api/token/refresh/`
	- `POST /api/token/verify/`

### Content Type
- Request content type: `application/json`
- Response content type: `application/json`

### Date/Time Format
- Use ISO-8601 timestamps for datetime values.
- Use `YYYY-MM-DD` for date-only values.

### Naming Convention
- Frontend currently accepts both camelCase and snake_case in some places, but backend should prefer one consistent style.
- Recommended: snake_case at API level, but keep compatibility aliases where frontend already expects camelCase.

## Standard Response Contract (Required)

Use one of these stable formats for all endpoints:

### Success (object)
```json
{
	"message": "optional human-readable message",
	"data": {}
}
```

### Success (list)
```json
{
	"data": [],
	"count": 0,
	"next": null,
	"previous": null
}
```

### Error
```json
{
	"message": "Validation failed",
	"errors": {
		"field_name": ["error details"]
	}
}
```

Status code requirements:
- `200` successful read/update
- `201` successful create
- `204` successful delete (no body)
- `400` validation error
- `401` unauthorized
- `403` forbidden
- `404` not found
- `409` conflict
- `422` semantic validation failure (optional)
- `500` server error

## Endpoints Already Present In Current OpenAPI

These exist in `tmp_openapi.yaml` and should remain stable.

### Auth and User
1. `POST /api/users/login/`
	- Body:
		- `email` (string, required)
		- `password` (string, required)
	- Response: login confirmation (frontend then calls token endpoint).

2. `POST /api/token/`
	- Body:
		- `email` (string, required)
		- `password` (string, required)
	- Response:
		- `access` (string, required)
		- `refresh` (string, required)

3. `POST /api/token/refresh/`
	- Body:
		- `refresh` (string, required)
	- Response:
		- `access` (string, required)

4. `POST /api/token/verify/`
	- Body:
		- `token` (string, required)

5. `POST /api/users/otp/resend`
	- Body:
		- `email` (email, required)

6. `POST /api/users/otp/verify`
	- Body:
		- `email` (email, required)
		- `code` (string, required)

### Patient
7. `POST /api/patients/register/`
	- Body:
		- `user.email` (required)
		- `user.password` (required)
		- `user.nickname` (optional)

8. `PUT/PATCH /api/patients/profile/`
	- Body:
		- `user.birth_date` (date)
		- `user.gender` (`male|female|""|null`)
		- `user.phone` (string)
		- `psychological_history` (string, optional)

### Doctor
9. `POST /api/doctors/register/`
	- Body:
		- `user.email` (required)
		- `user.password` (required)
		- `user.first_name` (optional)
		- `user.last_name` (optional)

10. `PUT/PATCH /api/doctors/profile/update`
	- Body:
		- `user.birth_date` (date)
		- `user.gender` (`male|female|""|null`)
		- `user.phone` (string)
		- `job_title.title` (string)
		- `experience` (int)
		- `specialization` (string)

11. `GET/POST /api/doctors/profile/education/`
	- POST Body:
		- `degree` (string, required)
		- `institution` (string, required)
		- `graduation_year` (int, optional)
		- `license_number` (string, optional)
		- `certificate` (uri string, optional)

12. `GET/PUT/PATCH/DELETE /api/doctors/profile/education/{id}/`
	- Path:
		- `id` (required)

## Required By Flutter But Missing Or Incomplete

The following endpoints are actively used by the Flutter code and must be implemented to avoid runtime failures.

## 1) Doctors Catalog

1. `GET /api/doctors`
	- Query (optional):
		- `specialization` (string)
	- Response list item required keys:
		- `id`
		- `name`
		- `specialization`
		- `experience`
		- `rating`
		- `imageUrl`
		- `description`
		- `isOnline`
		- `ratingValue`
		- `createdAt`
		- `availableTimes` (array of datetime strings)
		- `availableDurations` (array of int)
		- `availableSessionTypes` (array of strings)
		- `consultationFee` object with:
			- `textChat`
			- `videoCall`
			- `voiceCall`
	- Accepted response containers:
		- `{ "doctors": [...] }` or direct list `[...]`

2. `GET /api/doctors/{id}`
	- Path:
		- `id` (string, required)
	- Response: one doctor object using keys above.

## 2) Appointments

1. `GET /api/appointments/list`
	- Response accepted by app:
		- direct array `[...]`
		- or `{ "appointments": [...] }`
		- or `{ "data": [...] }`
	- Item keys:
		- `id`
		- `doctorId`
		- `patientId`
		- `doctorName`
		- `scheduledAt`
		- `durationSlots`
		- `consultationFee.textChat`
		- `consultationFee.videoCall`
		- `consultationFee.voiceCall`
		- `sessionType`
		- `status`
		- `requiresPayment` (bool)

2. `POST /api/appointments/create`
	- Body:
		- `doctorId` (string, required)
		- `patientId` (string, required)
		- `doctorName` (string, required)
		- `scheduledAt` (datetime, required)
		- `durationSlots` (int, required)
		- `consultationFee` (object, required)
		- `sessionType` (string, required)
		- Optional payment keys currently sent by payment flow:
			- `amount`
			- `currency`
			- `method`
	- Response:
		- `201`
		- either `{ "appointment": {...} }` or direct appointment object.

3. `POST /api/appointments/cancel`
	- Body:
		- `appointmentId` (string, required)
	- Response:
		- `200`

4. `POST /api/appointments/reschedule`
	- Body:
		- `appointmentId` (string, required)
		- `newScheduledAt` (datetime, required)
	- Response:
		- `200`
		- either `{ "appointment": {...} }` or direct appointment object.

## 3) Sessions

1. `GET /api/sessions/upcoming`
	- Response:
		- `{ "sessions": [Session] }`

2. `GET /api/sessions/past`
	- Response:
		- `{ "sessions": [Session] }`

Session object required keys:
- `id`
- `doctorId`
- `doctorName`
- `doctorSpecialization`
- `doctorImageUrl` (nullable)
- `scheduledAt`
- `durationMinutes`
- `sessionType`
- `status`

3. `POST /api/sessions/join`
	- Body:
		- `sessionId` (string, required)
	- Response: session object.

4. `POST /api/sessions/cancel`
	- Body:
		- `sessionId` (string, required)
		- `doctorId` (string, required)
	- Response: `200`

5. `POST /api/sessions/reschedule`
	- Body:
		- `sessionId` (string, required)
		- `newScheduledAt` (datetime, required)
	- Response: session object.

6. `POST /api/sessions/review`
	- Body:
		- `sessionId` (string, required)
		- `rating` (int, required, recommended range 1..5)
		- `comment` (string, required)
	- Response `201` with:
		- `id`
		- `sessionId`
		- `rating`
		- `comment`
		- `createdAt`

## 4) Assignments

1. `GET /api/assignments/questions`
	- Response accepted:
		- `{ "questions": [...] }`
		- or `{ "data": [...] }`
	- Question keys:
		- `id` (or `_id`)
		- `questionText` (or `question`, or `text`)
		- `options` (or `choices`) with 5 options aligned to app scale.
		- `validation` (optional)

2. `POST /api/assignments/submit`
	- Body:
		- `answers` (array, required)
		- Answer item keys:
			- `questionId`
			- `selectedOption`
	- Response accepted:
		- `{ "result": {...} }` or direct object
	- Result keys:
		- `resultId` (or `id`)
		- `score` (int)
		- `severity` (or `level`)
		- `summary` (or `message`)
		- `recommendation.doctorIds` or `recommendedDoctorIds`
		- `recommendation.specialties` or `recommendedSpecialties`

## 5) Settings And Medical Profile

1. `GET /api/settings/medical-profile`
	- Query:
		- `userId` (string, required)
	- Response accepted:
		- direct object OR `{ "data": {...} }`
	- Required keys:
		- `prescriptions` (array)
		- `notes` (array)

Prescription item accepted keys:
- `prescriptionNumber` or `prescription_number` or `id`
- `medicine` or `name`
- `dosage` or `amount`
- `schedule` or `timing`
- `nextRefill` or `next_refill`
- `documentType` or `document_type`
- `doctorName` or `doctor_name`
- `capturedAt` or `captured_at`
- `imagePath` or `image_path`

Note item keys:
- `title`
- `content` (or `note`)
- `updatedAt` (or `updated_at`)

2. `PATCH /api/settings/medical-profile/notes`
	- Body:
		- `userId` (string, required)
		- `noteTitle` (string, required)
		- `previousUpdatedAt` (datetime/string, required for optimistic lock)
		- `newTitle` (string, required)
		- `newContent` (string, required)
	- Response:
		- updated medical profile object (direct or inside `data`)

3. `POST /api/settings/medical-profile/notes/share`
	- Body:
		- `userId` (string, required)
		- `noteTitle` (string, required)
		- `noteContent` (string, required)
		- `doctorId` (string, required)
	- Response:
		- `message` key required.

4. `POST /api/settings/reports`
	- Body:
		- `userId` (string, required)
		- `reason` (string, required)
		- `details` (string, required)
	- Response:
		- `message` key required.

## 6) Reports Module

1. `POST /api/reports/submit`
	- Body:
		- `userId` (string, required)
		- `reportType` (string, required: app|doctor|session|payment or similar)
		- `targetId` (string, optional)
		- `targetName` (string, optional)
		- `reason` (string, required)
		- `description` (string, required)
	- Response accepted:
		- `{ "report": {...} }`
		- or `{ "data": {...} }`
		- or direct report object.

2. `GET /api/reports/history`
	- Query:
		- `userId` (string, required)
	- Response accepted:
		- direct list
		- or `{ "reports": [...] }`
		- or `{ "data": [...] }`
		- or `{ "items": [...] }`

3. `GET /api/reports/by-type`
	- Query:
		- `userId` (string, required)
		- `reportType` (string, required)
	- Response: same accepted list wrappers as history.

Report object keys required:
- `id` (or `_id`)
- `userId` (or `user_id`)
- `reportType` (or `report_type`)
- `targetId` (or `target_id`)
- `targetName` (or `target_name`)
- `reason`
- `description`
- `status`
- `createdAt` (or `created_at`)
- `resolvedAt` (or `resolved_at`)

## 7) Voice Calls

1. `GET /voice/calls`
	- Query:
		- `patientId` (required)
	- Response: list of call objects.

2. `POST /voice/calls/start`
	- Body:
		- `doctorId` (required)
		- `patientId` (required)
		- `sessionId` (required)
	- Response: call object.

3. `POST /voice/calls/{callId}/end`
	- Path:
		- `callId` (required)
	- Response: call object.

Voice call object keys:
- `id`
- `doctorId`
- `patientId`
- `sessionId`
- `startedAt`
- `endedAt` (nullable)
- `status` (`ringing|ongoing|ended|missed`)

## 8) Video Calls

1. `GET /video/calls`
	- Query:
		- `patientId` (required)
	- Response: list of call objects.

2. `POST /video/calls/start`
	- Body:
		- `doctorId` (required)
		- `patientId` (required)
		- `sessionId` (required)
	- Response: call object.

3. `POST /video/calls/{callId}/end`
	- Path:
		- `callId` (required)
	- Response: call object.

Video call object keys:
- `id`
- `doctorId`
- `patientId`
- `sessionId`
- `startedAt`
- `endedAt` (nullable)
- `status` (`ringing|ongoing|ended|missed`)

## Gaps Explicitly Flagged By Frontend

These are currently expected in app code but may return 404 or unsupported behavior:

1. `POST /api/auth/google-login`
	- Body: `id_token`
	- Needed to complete Google Sign-In flow.

2. `POST /api/auth/delete-account`
	- Needed for account deletion flow.

3. Email-change workflow currently overloaded on OTP endpoints.
	- Existing endpoints are verification-centric for current email.
	- Backend should support secure change-email flow for new email addresses.

Recommended robust email-change endpoints:
- `POST /api/users/email-change/request`
	- Body: `new_email`
- `POST /api/users/email-change/confirm`
	- Body: `new_email`, `otp`

## Backend Implementation Requirements

## Security
1. Enforce object-level permissions (users can only access their own records unless admin/doctor role allows).
2. Validate role constraints for patient-only and doctor-only endpoints.
3. Apply DRF throttling for login, OTP resend, OTP verify, and report submission.
4. Hash and store OTP securely with expiry and attempt limits.

## Validation
1. Return field-level errors for invalid payloads.
2. Validate all required IDs exist and belong to proper relation scope.
3. Validate enum-like fields (`gender`, `sessionType`, `status`, `reportType`, `reason`).
4. Reject invalid state transitions (example: ending an already ended call).

## Reliability
1. Use atomic transactions for create/cancel/reschedule and payment-related writes.
2. Add optimistic locking where `previousUpdatedAt` is sent (medical note update).
3. Add idempotency strategy for payment submission and appointment creation retries.

## Performance
1. Add pagination to list endpoints with `page` and `page_size` where lists can grow.
2. Add DB indexes for frequently filtered fields:
	- `doctor.specialization`
	- `appointments.patient_id`
	- `appointments.doctor_id`
	- `sessions.scheduled_at`
	- `reports.user_id`
	- `reports.report_type`

## Observability
1. Structured logging for auth errors, failed payments, and scheduling conflicts.
2. Add Sentry or similar error monitoring integration.
3. Include request correlation ID support in logs.

## Final Delivery Checklist For Django Team

1. Implement all missing endpoints listed above.
2. Ensure response keys match Flutter-required keys exactly.
3. Return correct status codes for all success/error scenarios.
4. Publish updated OpenAPI spec including all new endpoints.
5. Provide Postman collection or Swagger examples for each endpoint.
6. Confirm JWT refresh flow works with expired access token and valid refresh token.
7. Confirm role and ownership permissions by test cases.
8. Confirm OTP and email-change flows by integration tests.
9. Confirm appointment/session/report endpoints by integration tests.
10. Share a backend changelog to frontend team with any intentional key-name differences.

## Suggested Milestones

1. Milestone 1: Auth hardening + profile compatibility
2. Milestone 2: Doctors, appointments, sessions
3. Milestone 3: Assignments, settings medical profile, reports
4. Milestone 4: Voice/video calls + Google login + delete account
5. Milestone 5: Documentation, QA, and production readiness checks

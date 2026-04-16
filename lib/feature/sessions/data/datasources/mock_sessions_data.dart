class MockSessionsData {
  // Mock sessions
  static const List<Map<String, dynamic>> mockSessions = [
    {
      'id': 'session_001',
      'doctorId': 'doc_001',
      'doctorName': 'Dr. Ahmed Malik',
      'doctorSpecialization': 'psychiatrist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'patientId': 'user_001',
      'scheduledAt': '2024-04-20T10:00:00Z',
      'completedAt': null,
      'durationMinutes': 60,
      'sessionType': 'video_call',
      'status': 'upcoming',
      'isUpcoming': true,
      'notes': 'First consultation for anxiety assessment',
    },
    {
      'id': 'session_002',
      'doctorId': 'doc_002',
      'doctorName': 'Dr. Fatima Zahra',
      'doctorSpecialization': 'clinicalPsychologist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'patientId': 'user_001',
      'scheduledAt': '2024-04-15T14:00:00Z',
      'completedAt': '2024-04-15T14:45:00Z',
      'durationMinutes': 45,
      'sessionType': 'text_chat',
      'status': 'completed',
      'isUpcoming': false,
      'notes': 'Follow-up on CBT techniques. Patient showing good progress.',
    },
    {
      'id': 'session_003',
      'doctorId': 'doc_003',
      'doctorName': 'Dr. Mohammed Hassan',
      'doctorSpecialization': 'psychotherapist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Mohammed+Hassan',
      'patientId': 'user_002',
      'scheduledAt': '2024-04-18T16:30:00Z',
      'completedAt': '2024-04-18T17:30:00Z',
      'durationMinutes': 60,
      'sessionType': 'voice_call',
      'status': 'completed',
      'isUpcoming': false,
      'notes': 'Marriage counseling session - Both partners engaged positively.',
    },
    {
      'id': 'session_004',
      'doctorId': 'doc_004',
      'doctorName': 'Dr. Leila Mansour',
      'doctorSpecialization': 'cbtTherapist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Leila+Mansour',
      'patientId': 'user_003',
      'scheduledAt': '2024-04-21T09:00:00Z',
      'completedAt': null,
      'durationMinutes': 50,
      'sessionType': 'video_call',
      'status': 'upcoming',
      'isUpcoming': true,
      'notes': 'OCD management - Week 4 of treatment plan',
    },
    {
      'id': 'session_005',
      'doctorId': 'doc_005',
      'doctorName': 'Dr. Sarah Ali',
      'doctorSpecialization': 'counselor',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Sarah+Ali',
      'patientId': 'user_001',
      'scheduledAt': '2024-04-12T15:00:00Z',
      'completedAt': '2024-04-12T15:30:00Z',
      'durationMinutes': 30,
      'sessionType': 'voice_call',
      'status': 'completed',
      'isUpcoming': false,
      'notes': 'Stress management techniques discussed. Patient to practice daily.',
    },
    {
      'id': 'session_006',
      'doctorId': 'doc_006',
      'doctorName': 'Dr. Omar Taha',
      'doctorSpecialization': 'traumaTherapist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Omar+Taha',
      'patientId': 'user_002',
      'scheduledAt': '2024-04-25T11:00:00Z',
      'completedAt': null,
      'durationMinutes': 60,
      'sessionType': 'video_call',
      'status': 'upcoming',
      'isUpcoming': true,
      'notes': 'EMDR therapy - Session 3 of treatment protocol',
    },
    {
      'id': 'session_007',
      'doctorId': 'doc_001',
      'doctorName': 'Dr. Ahmed Malik',
      'doctorSpecialization': 'psychiatrist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'patientId': 'user_003',
      'scheduledAt': '2024-04-10T10:00:00Z',
      'completedAt': '2024-04-10T11:00:00Z',
      'durationMinutes': 60,
      'sessionType': 'video_call',
      'status': 'completed',
      'isUpcoming': false,
      'notes': 'Medication adjustment discussed. Patient to monitor side effects.',
    },
    {
      'id': 'session_008',
      'doctorId': 'doc_002',
      'doctorName': 'Dr. Fatima Zahra',
      'doctorSpecialization': 'clinicalPsychologist',
      'doctorImageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'patientId': 'user_002',
      'scheduledAt': '2024-04-22T13:00:00Z',
      'completedAt': null,
      'durationMinutes': 60,
      'sessionType': 'video_call',
      'status': 'upcoming',
      'isUpcoming': true,
      'notes': 'Anxiety management review and goal setting',
    },
  ];

  // Mock session reviews/ratings
  static const List<Map<String, dynamic>> mockReviews = [
    {
      'id': 'review_001',
      'sessionId': 'session_002',
      'rating': 5,
      'reviewText': 'Excellent session! Dr. Fatima was very professional and helpful. She provided clear guidance on anxiety management techniques.',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'createdAt': '2024-04-15T15:00:00Z',
    },
    {
      'id': 'review_002',
      'sessionId': 'session_003',
      'rating': 4,
      'reviewText': 'Good session. Dr. Mohammed helped us understand our communication issues better. Would recommend.',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'createdAt': '2024-04-18T18:00:00Z',
    },
    {
      'id': 'review_003',
      'sessionId': 'session_005',
      'rating': 5,
      'reviewText': 'Dr. Sarah is wonderful! Her stress management techniques are practical and easy to implement. Feeling much better already.',
      'doctorId': 'doc_005',
      'patientId': 'user_001',
      'createdAt': '2024-04-12T16:00:00Z',
    },
    {
      'id': 'review_004',
      'sessionId': 'session_007',
      'rating': 4,
      'reviewText': 'Dr. Ahmed explained everything clearly. The medication adjustment makes sense. Looking forward to next session.',
      'doctorId': 'doc_001',
      'patientId': 'user_003',
      'createdAt': '2024-04-10T12:00:00Z',
    },
    {
      'id': 'review_005',
      'sessionId': 'session_002',
      'rating': 5,
      'reviewText': 'Highly competent and empathetic therapist. Highly recommend Dr. Fatima to anyone seeking psychological support.',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'createdAt': '2024-04-15T20:00:00Z',
    },
  ];

  // Mock session notes (doctor notes)
  static const List<Map<String, dynamic>> mockSessionNotes = [
    {
      'id': 'note_001',
      'sessionId': 'session_002',
      'doctorId': 'doc_002',
      'content': 'Patient reports improvement in anxiety levels. CBT techniques being applied well. Recommend continuing current approach.',
      'createdAt': '2024-04-15T14:45:00Z',
    },
    {
      'id': 'note_002',
      'sessionId': 'session_003',
      'doctorId': 'doc_003',
      'content': 'Marital communication improving. Both partners cooperating well in therapy. Continue weekly sessions.',
      'createdAt': '2024-04-18T17:30:00Z',
    },
    {
      'id': 'note_003',
      'sessionId': 'session_005',
      'doctorId': 'doc_005',
      'content': 'Patient learning stress management techniques. Positive attitude towards treatment. Good progress.',
      'createdAt': '2024-04-12T15:30:00Z',
    },
    {
      'id': 'note_004',
      'sessionId': 'session_007',
      'doctorId': 'doc_001',
      'content': 'Medication adjustment approved. Patient to monitor for any adverse effects. Follow-up in 2 weeks.',
      'createdAt': '2024-04-10T11:00:00Z',
    },
  ];

  static List<Map<String, dynamic>> getMockSessions() => mockSessions;

  static List<Map<String, dynamic>> getMockUpcomingSessions() {
    return mockSessions.where((s) => s['isUpcoming'] == true).toList();
  }

  static List<Map<String, dynamic>> getMockCompletedSessions() {
    return mockSessions.where((s) => s['status'] == 'completed').toList();
  }

  static List<Map<String, dynamic>> getMockSessionsByPatient(String patientId) {
    return mockSessions.where((s) => s['patientId'] == patientId).toList();
  }

  static List<Map<String, dynamic>> getMockSessionsByDoctor(String doctorId) {
    return mockSessions.where((s) => s['doctorId'] == doctorId).toList();
  }

  static List<Map<String, dynamic>> getMockReviews() => mockReviews;

  static List<Map<String, dynamic>> getMockReviewsByDoctor(String doctorId) {
    return mockReviews.where((r) => r['doctorId'] == doctorId).toList();
  }

  static List<Map<String, dynamic>> getMockReviewsByPatient(String patientId) {
    return mockReviews.where((r) => r['patientId'] == patientId).toList();
  }

  static double getAverageRatingForDoctor(String doctorId) {
    final doctorReviews = getMockReviewsByDoctor(doctorId);
    if (doctorReviews.isEmpty) return 0.0;
    final sum = doctorReviews.fold(0, (sum, r) => sum + (r['rating'] as int));
    return sum / doctorReviews.length;
  }

  static List<Map<String, dynamic>> getMockSessionNotes() => mockSessionNotes;

  static Map<String, dynamic>? getMockSessionById(String id) {
    try {
      return mockSessions.firstWhere((s) => s['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockReviewById(String id) {
    try {
      return mockReviews.firstWhere((r) => r['id'] == id);
    } catch (e) {
      return null;
    }
  }
}

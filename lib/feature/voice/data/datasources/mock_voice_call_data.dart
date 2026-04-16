class MockVoiceCallData {
  // Mock voice calls
  static const List<Map<String, dynamic>> mockVoiceCalls = [
    {
      'id': 'acall_001',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'sessionId': 'session_001',
      'doctorName': 'Dr. Ahmed Malik',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-19T10:00:00Z',
      'endedAt': '2024-04-19T10:35:00Z',
      'status': 'ended',
      'durationInSeconds': 2100,
      'isRecorded': true,
      'recordingUrl': 'https://example.com/recordings/acall_001.m4a',
      'callType': 'consultation',
    },
    {
      'id': 'acall_002',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'sessionId': 'session_002',
      'doctorName': 'Dr. Fatima Zahra',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-15T14:00:00Z',
      'endedAt': '2024-04-15T14:40:00Z',
      'status': 'ended',
      'durationInSeconds': 2400,
      'isRecorded': true,
      'recordingUrl': 'https://example.com/recordings/acall_002.m4a',
      'callType': 'follow_up',
    },
    {
      'id': 'acall_003',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'sessionId': 'session_003',
      'doctorName': 'Dr. Mohammed Hassan',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-18T16:30:00Z',
      'endedAt': null,
      'status': 'ongoing',
      'durationInSeconds': 0,
      'isRecorded': false,
      'recordingUrl': null,
      'callType': 'consultation',
    },
    {
      'id': 'acall_004',
      'doctorId': 'doc_004',
      'patientId': 'user_003',
      'sessionId': 'session_004',
      'doctorName': 'Dr. Leila Mansour',
      'patientName': 'Mohammed Saeed',
      'startedAt': null,
      'endedAt': null,
      'status': 'ringing',
      'durationInSeconds': 0,
      'isRecorded': false,
      'recordingUrl': null,
      'callType': 'consultation',
    },
    {
      'id': 'acall_005',
      'doctorId': 'doc_005',
      'patientId': 'user_001',
      'sessionId': 'session_005',
      'doctorName': 'Dr. Sarah Ali',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-12T15:00:00Z',
      'endedAt': '2024-04-12T15:20:00Z',
      'status': 'ended',
      'durationInSeconds': 1200,
      'isRecorded': true,
      'recordingUrl': 'https://example.com/recordings/acall_005.m4a',
      'callType': 'quick_check_in',
    },
    {
      'id': 'acall_006',
      'doctorId': 'doc_006',
      'patientId': 'user_002',
      'sessionId': 'session_006',
      'doctorName': 'Dr. Omar Taha',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-10T11:00:00Z',
      'endedAt': '2024-04-10T12:05:00Z',
      'status': 'ended',
      'durationInSeconds': 3900,
      'isRecorded': true,
      'recordingUrl': 'https://example.com/recordings/acall_006.m4a',
      'callType': 'consultation',
    },
    {
      'id': 'acall_007',
      'doctorId': 'doc_002',
      'patientId': 'user_003',
      'sessionId': 'session_007',
      'doctorName': 'Dr. Fatima Zahra',
      'patientName': 'Mohammed Saeed',
      'startedAt': '2024-04-08T10:00:00Z',
      'endedAt': null,
      'status': 'missed',
      'durationInSeconds': 0,
      'isRecorded': false,
      'recordingUrl': null,
      'callType': 'consultation',
    },
    {
      'id': 'acall_008',
      'doctorId': 'doc_001',
      'patientId': 'user_002',
      'sessionId': 'session_008',
      'doctorName': 'Dr. Ahmed Malik',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-05T09:00:00Z',
      'endedAt': '2024-04-05T09:50:00Z',
      'status': 'ended',
      'durationInSeconds': 3000,
      'isRecorded': true,
      'recordingUrl': 'https://example.com/recordings/acall_008.m4a',
      'callType': 'consultation',
    },
  ];

  // Mock voice call quality metrics
  static const List<Map<String, dynamic>> mockAudioMetrics = [
    {
      'callId': 'acall_001',
      'averageBitrate': 128,
      'audioCodec': 'opus',
      'audioQuality': 'excellent',
      'packetLoss': 0.0,
      'latency': 35,
      'jitter': 5,
    },
    {
      'callId': 'acall_002',
      'averageBitrate': 96,
      'audioCodec': 'opus',
      'audioQuality': 'good',
      'packetLoss': 0.3,
      'latency': 55,
      'jitter': 8,
    },
    {
      'callId': 'acall_005',
      'averageBitrate': 128,
      'audioCodec': 'opus',
      'audioQuality': 'excellent',
      'packetLoss': 0.1,
      'latency': 40,
      'jitter': 6,
    },
    {
      'callId': 'acall_006',
      'averageBitrate': 96,
      'audioCodec': 'opus',
      'audioQuality': 'good',
      'packetLoss': 0.5,
      'latency': 60,
      'jitter': 10,
    },
  ];

  // Mock call transcripts
  static const List<Map<String, dynamic>> mockCallTranscripts = [
    {
      'id': 'transcript_001',
      'callId': 'acall_001',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'content': 'Doctor: Hello Ahmed, how are you feeling today?\n'
          'Patient: Good, but I have been having some trouble sleeping.\n'
          'Doctor: I see. Let me recommend some techniques...',
      'generatedAt': '2024-04-19T10:40:00Z',
      'isAccurate': true,
    },
    {
      'id': 'transcript_002',
      'callId': 'acall_002',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'content': 'Doctor: How are the anxiety exercises going?\n'
          'Patient: Much better! I have been practicing them daily.\n'
          'Doctor: Excellent! Keep up the good work.',
      'generatedAt': '2024-04-15T14:45:00Z',
      'isAccurate': true,
    },
  ];

  // Mock voice call feedback
  static const List<Map<String, dynamic>> mockVoiceCallFeedback = [
    {
      'id': 'vfeedback_001',
      'callId': 'acall_001',
      'userId': 'user_001',
      'rating': 5,
      'audioQuality': 5,
      'doctorResponsiveness': 5,
      'comment': 'Crystal clear audio quality. Doctor was very attentive.',
      'submittedAt': '2024-04-19T11:00:00Z',
    },
    {
      'id': 'vfeedback_002',
      'callId': 'acall_002',
      'userId': 'user_001',
      'rating': 4,
      'audioQuality': 4,
      'doctorResponsiveness': 5,
      'comment': 'Good quality overall. Minor audio cuts a couple of times.',
      'submittedAt': '2024-04-15T14:50:00Z',
    },
    {
      'id': 'vfeedback_003',
      'callId': 'acall_005',
      'userId': 'user_001',
      'rating': 5,
      'audioQuality': 5,
      'doctorResponsiveness': 5,
      'comment': 'Excellent quick check-in call. Very professional.',
      'submittedAt': '2024-04-12T15:25:00Z',
    },
  ];

  static List<Map<String, dynamic>> getMockVoiceCalls() => mockVoiceCalls;

  static List<Map<String, dynamic>> getMockVoiceCallsByPatient(String patientId) {
    return mockVoiceCalls
        .where((call) => call['patientId'] == patientId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockVoiceCallsByDoctor(String doctorId) {
    return mockVoiceCalls
        .where((call) => call['doctorId'] == doctorId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockVoiceCallsByStatus(String status) {
    return mockVoiceCalls
        .where((call) => call['status'] == status)
        .toList();
  }

  static Map<String, dynamic>? getMockVoiceCallById(String id) {
    try {
      return mockVoiceCalls.firstWhere((call) => call['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockAudioMetricsById(String callId) {
    try {
      return mockAudioMetrics.firstWhere((metric) => metric['callId'] == callId);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockTranscriptByCallId(String callId) {
    try {
      return mockCallTranscripts.firstWhere((t) => t['callId'] == callId);
    } catch (e) {
      return null;
    }
  }

  static List<Map<String, dynamic>> getMockVoiceCallFeedbackByCall(String callId) {
    return mockVoiceCallFeedback
        .where((feedback) => feedback['callId'] == callId)
        .toList();
  }

  static double getAverageRatingForVoiceCall(String callId) {
    final feedback = getMockVoiceCallFeedbackByCall(callId);
    if (feedback.isEmpty) return 0.0;
    final sum = feedback.fold(0, (sum, f) => sum + (f['rating'] as int));
    return sum / feedback.length;
  }

  static String formatDuration(int durationSeconds) {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

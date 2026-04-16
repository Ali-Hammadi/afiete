class MockVideoCallData {
  // Mock video calls
  static const List<Map<String, dynamic>> mockVideoCalls = [
    {
      'id': 'vcall_001',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'sessionId': 'session_001',
      'doctorName': 'Dr. Ahmed Malik',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-15T10:00:00Z',
      'endedAt': '2024-04-15T10:45:00Z',
      'status': 'ended',
      'durationInSeconds': 2700,
      'recordingUrl': 'https://example.com/recordings/vcall_001.mp4',
      'isRecorded': true,
    },
    {
      'id': 'vcall_002',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'sessionId': 'session_002',
      'doctorName': 'Dr. Fatima Zahra',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-10T14:00:00Z',
      'endedAt': '2024-04-10T14:50:00Z',
      'status': 'ended',
      'durationInSeconds': 3000,
      'recordingUrl': 'https://example.com/recordings/vcall_002.mp4',
      'isRecorded': true,
    },
    {
      'id': 'vcall_003',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'sessionId': 'session_003',
      'doctorName': 'Dr. Mohammed Hassan',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-18T16:30:00Z',
      'endedAt': null,
      'status': 'ongoing',
      'durationInSeconds': 0,
      'recordingUrl': null,
      'isRecorded': false,
    },
    {
      'id': 'vcall_004',
      'doctorId': 'doc_004',
      'patientId': 'user_003',
      'sessionId': 'session_004',
      'doctorName': 'Dr. Leila Mansour',
      'patientName': 'Mohammed Saeed',
      'startedAt': null,
      'endedAt': null,
      'status': 'ringing',
      'durationInSeconds': 0,
      'recordingUrl': null,
      'isRecorded': false,
    },
    {
      'id': 'vcall_005',
      'doctorId': 'doc_001',
      'patientId': 'user_002',
      'sessionId': 'session_005',
      'doctorName': 'Dr. Ahmed Malik',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-12T10:00:00Z',
      'endedAt': '2024-04-12T10:30:00Z',
      'status': 'ended',
      'durationInSeconds': 1800,
      'recordingUrl': 'https://example.com/recordings/vcall_005.mp4',
      'isRecorded': true,
    },
    {
      'id': 'vcall_006',
      'doctorId': 'doc_005',
      'patientId': 'user_001',
      'sessionId': 'session_006',
      'doctorName': 'Dr. Sarah Ali',
      'patientName': 'Ahmed Ali',
      'startedAt': '2024-04-08T15:00:00Z',
      'endedAt': '2024-04-08T15:25:00Z',
      'status': 'ended',
      'durationInSeconds': 1500,
      'recordingUrl': 'https://example.com/recordings/vcall_006.mp4',
      'isRecorded': true,
    },
    {
      'id': 'vcall_007',
      'doctorId': 'doc_006',
      'patientId': 'user_002',
      'sessionId': 'session_007',
      'doctorName': 'Dr. Omar Taha',
      'patientName': 'Fatima Hassan',
      'startedAt': '2024-04-05T11:00:00Z',
      'endedAt': '2024-04-05T12:10:00Z',
      'status': 'ended',
      'durationInSeconds': 4200,
      'recordingUrl': 'https://example.com/recordings/vcall_007.mp4',
      'isRecorded': true,
    },
    {
      'id': 'vcall_008',
      'doctorId': 'doc_002',
      'patientId': 'user_003',
      'sessionId': 'session_008',
      'doctorName': 'Dr. Fatima Zahra',
      'patientName': 'Mohammed Saeed',
      'startedAt': null,
      'endedAt': null,
      'status': 'missed',
      'durationInSeconds': 0,
      'recordingUrl': null,
      'isRecorded': false,
    },
  ];

  // Mock video call quality metrics
  static const List<Map<String, dynamic>> mockCallMetrics = [
    {
      'callId': 'vcall_001',
      'averageBitrate': 2500,
      'averageFrameRate': 30,
      'audioQuality': 'excellent',
      'videoQuality': 'excellent',
      'packetLoss': 0.1,
      'latency': 45,
    },
    {
      'callId': 'vcall_002',
      'averageBitrate': 2000,
      'averageFrameRate': 24,
      'audioQuality': 'good',
      'videoQuality': 'good',
      'packetLoss': 0.5,
      'latency': 65,
    },
    {
      'callId': 'vcall_005',
      'averageBitrate': 1500,
      'averageFrameRate': 20,
      'audioQuality': 'good',
      'videoQuality': 'fair',
      'packetLoss': 1.2,
      'latency': 85,
    },
  ];

  // Mock video call feedback
  static const List<Map<String, dynamic>> mockCallFeedback = [
    {
      'id': 'feedback_001',
      'callId': 'vcall_001',
      'userId': 'user_001',
      'rating': 5,
      'audioQuality': 5,
      'videoQuality': 5,
      'connectionStability': 5,
      'comment': 'Excellent connection and call quality. Very satisfied.',
      'submittedAt': '2024-04-15T10:50:00Z',
    },
    {
      'id': 'feedback_002',
      'callId': 'vcall_002',
      'userId': 'user_001',
      'rating': 4,
      'audioQuality': 4,
      'videoQuality': 4,
      'connectionStability': 3,
      'comment': 'Good overall but some occasional freezing.',
      'submittedAt': '2024-04-10T14:55:00Z',
    },
    {
      'id': 'feedback_003',
      'callId': 'vcall_005',
      'userId': 'user_002',
      'rating': 3,
      'audioQuality': 3,
      'videoQuality': 3,
      'connectionStability': 2,
      'comment': 'Connection was a bit unstable but still manageable.',
      'submittedAt': '2024-04-12T10:35:00Z',
    },
  ];

  static List<Map<String, dynamic>> getMockVideoCalls() => mockVideoCalls;

  static List<Map<String, dynamic>> getMockVideoCallsByPatient(String patientId) {
    return mockVideoCalls
        .where((call) => call['patientId'] == patientId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockVideoCallsByDoctor(String doctorId) {
    return mockVideoCalls
        .where((call) => call['doctorId'] == doctorId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockVideoCallsByStatus(String status) {
    return mockVideoCalls
        .where((call) => call['status'] == status)
        .toList();
  }

  static Map<String, dynamic>? getMockVideoCallById(String id) {
    try {
      return mockVideoCalls.firstWhere((call) => call['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockCallMetricsById(String callId) {
    try {
      return mockCallMetrics.firstWhere((metric) => metric['callId'] == callId);
    } catch (e) {
      return null;
    }
  }

  static List<Map<String, dynamic>> getMockCallFeedbackByCall(String callId) {
    return mockCallFeedback
        .where((feedback) => feedback['callId'] == callId)
        .toList();
  }

  static double getAverageRatingForCall(String callId) {
    final feedback = getMockCallFeedbackByCall(callId);
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

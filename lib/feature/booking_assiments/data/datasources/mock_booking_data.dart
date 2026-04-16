class MockBookingData {
  // Mock appointments/bookings
  static const List<Map<String, dynamic>> mockAppointments = [
    {
      'id': 'apt_001',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'doctorName': 'Dr. Ahmed Malik',
      'scheduledAt': '2024-04-20T10:00:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 50, 'currency': 'USD'},
      'sessionType': 'video_call',
      'status': 'confirmed',
      'requiresPayment': true,
      'createdAt': '2024-04-15T09:30:00Z',
    },
    {
      'id': 'apt_002',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'doctorName': 'Dr. Fatima Zahra',
      'scheduledAt': '2024-04-21T14:00:00Z',
      'durationSlots': 2,
      'consultationFee': {'amount': 100, 'currency': 'USD'},
      'sessionType': 'text_chat',
      'status': 'pending',
      'requiresPayment': true,
      'createdAt': '2024-04-14T11:15:00Z',
    },
    {
      'id': 'apt_003',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'doctorName': 'Dr. Mohammed Hassan',
      'scheduledAt': '2024-04-22T16:30:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 40, 'currency': 'USD'},
      'sessionType': 'voice_call',
      'status': 'completed',
      'requiresPayment': false,
      'createdAt': '2024-04-10T13:00:00Z',
    },
    {
      'id': 'apt_004',
      'doctorId': 'doc_004',
      'patientId': 'user_003',
      'doctorName': 'Dr. Leila Mansour',
      'scheduledAt': '2024-04-25T09:00:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 60, 'currency': 'USD'},
      'sessionType': 'video_call',
      'status': 'cancelled',
      'requiresPayment': false,
      'createdAt': '2024-04-18T10:45:00Z',
    },
    {
      'id': 'apt_005',
      'doctorId': 'doc_001',
      'patientId': 'user_002',
      'doctorName': 'Dr. Ahmed Malik',
      'scheduledAt': '2024-04-24T11:00:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 50, 'currency': 'USD'},
      'sessionType': 'video_call',
      'status': 'confirmed',
      'requiresPayment': true,
      'createdAt': '2024-04-19T08:30:00Z',
    },
    {
      'id': 'apt_006',
      'doctorId': 'doc_005',
      'patientId': 'user_001',
      'doctorName': 'Dr. Sarah Ali',
      'scheduledAt': '2024-04-23T15:00:00Z',
      'durationSlots': 2,
      'consultationFee': {'amount': 80, 'currency': 'USD'},
      'sessionType': 'text_chat',
      'status': 'pending',
      'requiresPayment': true,
      'createdAt': '2024-04-18T14:20:00Z',
    },
    {
      'id': 'apt_007',
      'doctorId': 'doc_002',
      'patientId': 'user_003',
      'doctorName': 'Dr. Fatima Zahra',
      'scheduledAt': '2024-04-26T13:30:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 45, 'currency': 'USD'},
      'sessionType': 'voice_call',
      'status': 'completed',
      'requiresPayment': false,
      'createdAt': '2024-04-12T12:00:00Z',
    },
    {
      'id': 'apt_008',
      'doctorId': 'doc_006',
      'patientId': 'user_002',
      'doctorName': 'Dr. Omar Taha',
      'scheduledAt': '2024-04-27T10:30:00Z',
      'durationSlots': 1,
      'consultationFee': {'amount': 55, 'currency': 'USD'},
      'sessionType': 'video_call',
      'status': 'confirmed',
      'requiresPayment': true,
      'createdAt': '2024-04-20T09:15:00Z',
    },
  ];

  static List<Map<String, dynamic>> getMockAppointments() => mockAppointments;

  static List<Map<String, dynamic>> getMockAppointmentsByPatient(
    String patientId,
  ) {
    return mockAppointments
        .where((apt) => apt['patientId'] == patientId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockAppointmentsByDoctor(
    String doctorId,
  ) {
    return mockAppointments
        .where((apt) => apt['doctorId'] == doctorId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockAppointmentsByStatus(String status) {
    return mockAppointments.where((apt) => apt['status'] == status).toList();
  }

  static Map<String, dynamic>? getMockAppointmentById(String id) {
    try {
      return mockAppointments.firstWhere((apt) => apt['id'] == id);
    } catch (e) {
      return null;
    }
  }
}

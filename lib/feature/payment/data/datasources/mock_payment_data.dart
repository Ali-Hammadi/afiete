class MockPaymentData {
  // Mock payment transactions
  static const List<Map<String, dynamic>> mockPayments = [
    {
      'id': 'pay_001',
      'transactionRef': 'TXN-001-2024-04-19',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'doctorName': 'Dr. Ahmed Malik',
      'amount': 50,
      'currency': 'USD',
      'method': 'card',
      'status': 'success',
      'sessionType': 'video_call',
      'appointmentId': 'apt_001',
      'createdAt': '2024-04-19T10:30:00Z',
      'processedAt': '2024-04-19T10:35:00Z',
    },
    {
      'id': 'pay_002',
      'transactionRef': 'TXN-002-2024-04-18',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'doctorName': 'Dr. Fatima Zahra',
      'amount': 100,
      'currency': 'USD',
      'method': 'wallet',
      'status': 'success',
      'sessionType': 'text_chat',
      'appointmentId': 'apt_002',
      'createdAt': '2024-04-18T14:00:00Z',
      'processedAt': '2024-04-18T14:02:00Z',
    },
    {
      'id': 'pay_003',
      'transactionRef': 'TXN-003-2024-04-17',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'doctorName': 'Dr. Mohammed Hassan',
      'amount': 40,
      'currency': 'USD',
      'method': 'card',
      'status': 'success',
      'sessionType': 'voice_call',
      'appointmentId': 'apt_003',
      'createdAt': '2024-04-17T16:45:00Z',
      'processedAt': '2024-04-17T16:47:00Z',
    },
    {
      'id': 'pay_004',
      'transactionRef': 'TXN-004-2024-04-16',
      'doctorId': 'doc_004',
      'patientId': 'user_003',
      'doctorName': 'Dr. Leila Mansour',
      'amount': 60,
      'currency': 'USD',
      'method': 'card',
      'status': 'failed',
      'sessionType': 'video_call',
      'appointmentId': 'apt_004',
      'createdAt': '2024-04-16T09:15:00Z',
      'processedAt': '2024-04-16T09:17:00Z',
      'failureReason': 'Card declined',
    },
    {
      'id': 'pay_005',
      'transactionRef': 'TXN-005-2024-04-19',
      'doctorId': 'doc_001',
      'patientId': 'user_002',
      'doctorName': 'Dr. Ahmed Malik',
      'amount': 50,
      'currency': 'USD',
      'method': 'wallet',
      'status': 'pending',
      'sessionType': 'video_call',
      'appointmentId': 'apt_005',
      'createdAt': '2024-04-19T08:45:00Z',
      'processedAt': null,
    },
    {
      'id': 'pay_006',
      'transactionRef': 'TXN-006-2024-04-18',
      'doctorId': 'doc_005',
      'patientId': 'user_001',
      'doctorName': 'Dr. Sarah Ali',
      'amount': 80,
      'currency': 'USD',
      'method': 'card',
      'status': 'success',
      'sessionType': 'text_chat',
      'appointmentId': 'apt_006',
      'createdAt': '2024-04-18T14:30:00Z',
      'processedAt': '2024-04-18T14:32:00Z',
    },
    {
      'id': 'pay_007',
      'transactionRef': 'TXN-007-2024-04-15',
      'doctorId': 'doc_002',
      'patientId': 'user_003',
      'doctorName': 'Dr. Fatima Zahra',
      'amount': 45,
      'currency': 'USD',
      'method': 'wallet',
      'status': 'success',
      'sessionType': 'voice_call',
      'appointmentId': 'apt_007',
      'createdAt': '2024-04-15T12:20:00Z',
      'processedAt': '2024-04-15T12:22:00Z',
    },
    {
      'id': 'pay_008',
      'transactionRef': 'TXN-008-2024-04-19',
      'doctorId': 'doc_006',
      'patientId': 'user_002',
      'doctorName': 'Dr. Omar Taha',
      'amount': 55,
      'currency': 'USD',
      'method': 'card',
      'status': 'success',
      'sessionType': 'video_call',
      'appointmentId': 'apt_008',
      'createdAt': '2024-04-19T09:20:00Z',
      'processedAt': '2024-04-19T09:22:00Z',
    },
  ];

  // Mock payment methods
  static const List<Map<String, dynamic>> mockPaymentMethods = [
    {
      'id': 'method_001',
      'userId': 'user_001',
      'type': 'card',
      'cardBrand': 'Visa',
      'lastFourDigits': '4242',
      'expiryMonth': 12,
      'expiryYear': 2025,
      'isDefault': true,
      'isActive': true,
    },
    {
      'id': 'method_002',
      'userId': 'user_001',
      'type': 'card',
      'cardBrand': 'Mastercard',
      'lastFourDigits': '5555',
      'expiryMonth': 6,
      'expiryYear': 2026,
      'isDefault': false,
      'isActive': true,
    },
    {
      'id': 'method_003',
      'userId': 'user_002',
      'type': 'wallet',
      'balance': 250.50,
      'currency': 'USD',
      'isDefault': true,
      'isActive': true,
    },
    {
      'id': 'method_004',
      'userId': 'user_003',
      'type': 'card',
      'cardBrand': 'Visa',
      'lastFourDigits': '6789',
      'expiryMonth': 3,
      'expiryYear': 2025,
      'isDefault': true,
      'isActive': true,
    },
  ];

  // Mock payment invoices
  static const List<Map<String, dynamic>> mockInvoices = [
    {
      'id': 'inv_001',
      'paymentId': 'pay_001',
      'invoiceNumber': 'INV-2024-0001',
      'doctorName': 'Dr. Ahmed Malik',
      'patientName': 'Ahmed Ali',
      'amount': 50,
      'currency': 'USD',
      'description': 'Video consultation - Mental health',
      'date': '2024-04-19T10:30:00Z',
      'dueDate': '2024-04-26T10:30:00Z',
      'status': 'paid',
    },
    {
      'id': 'inv_002',
      'paymentId': 'pay_002',
      'invoiceNumber': 'INV-2024-0002',
      'doctorName': 'Dr. Fatima Zahra',
      'patientName': 'Ahmed Ali',
      'amount': 100,
      'currency': 'USD',
      'description': 'Text chat consultation - Anxiety management',
      'date': '2024-04-18T14:00:00Z',
      'dueDate': '2024-04-25T14:00:00Z',
      'status': 'paid',
    },
    {
      'id': 'inv_003',
      'paymentId': 'pay_003',
      'invoiceNumber': 'INV-2024-0003',
      'doctorName': 'Dr. Mohammed Hassan',
      'patientName': 'Fatima Hassan',
      'amount': 40,
      'currency': 'USD',
      'description': 'Voice call consultation - Family therapy',
      'date': '2024-04-17T16:45:00Z',
      'dueDate': '2024-04-24T16:45:00Z',
      'status': 'paid',
    },
  ];

  static List<Map<String, dynamic>> getMockPayments() => mockPayments;

  static List<Map<String, dynamic>> getMockPaymentsByStatus(String status) {
    return mockPayments.where((p) => p['status'] == status).toList();
  }

  static List<Map<String, dynamic>> getMockPaymentsByPatient(String patientId) {
    return mockPayments.where((p) => p['patientId'] == patientId).toList();
  }

  static List<Map<String, dynamic>> getMockPaymentsByDoctor(String doctorId) {
    return mockPayments.where((p) => p['doctorId'] == doctorId).toList();
  }

  static List<Map<String, dynamic>> getMockPaymentMethods() => mockPaymentMethods;

  static List<Map<String, dynamic>> getMockPaymentMethodsByUser(String userId) {
    return mockPaymentMethods.where((m) => m['userId'] == userId).toList();
  }

  static List<Map<String, dynamic>> getMockInvoices() => mockInvoices;

  static List<Map<String, dynamic>> getMockInvoicesByPayment(String paymentId) {
    return mockInvoices.where((inv) => inv['paymentId'] == paymentId).toList();
  }

  static Map<String, dynamic>? getMockPaymentById(String id) {
    try {
      return mockPayments.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static double getTotalPaymentAmount(List<Map<String, dynamic>> payments) {
    return payments.fold(0.0, (sum, p) => sum + (p['amount'] as num).toDouble());
  }
}

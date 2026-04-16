class MockChatData {
  // Mock chat conversations
  static const List<Map<String, dynamic>> mockConversations = [
    {
      'id': 'conv_001',
      'doctorId': 'doc_001',
      'patientId': 'user_001',
      'doctorName': 'Dr. Ahmed Malik',
      'lastMessage': 'How are you feeling today?',
      'updatedAt': '2024-04-19T15:30:00Z',
      'unreadCount': 2,
    },
    {
      'id': 'conv_002',
      'doctorId': 'doc_002',
      'patientId': 'user_001',
      'doctorName': 'Dr. Fatima Zahra',
      'lastMessage': 'Please remember to take your medication',
      'updatedAt': '2024-04-18T10:15:00Z',
      'unreadCount': 0,
    },
    {
      'id': 'conv_003',
      'doctorId': 'doc_003',
      'patientId': 'user_002',
      'doctorName': 'Dr. Mohammed Hassan',
      'lastMessage': 'Your test results look good',
      'updatedAt': '2024-04-19T11:45:00Z',
      'unreadCount': 1,
    },
    {
      'id': 'conv_004',
      'doctorId': 'doc_004',
      'patientId': 'user_003',
      'doctorName': 'Dr. Leila Mansour',
      'lastMessage': 'See you next week',
      'updatedAt': '2024-04-17T14:20:00Z',
      'unreadCount': 0,
    },
    {
      'id': 'conv_005',
      'doctorId': 'doc_005',
      'patientId': 'user_002',
      'doctorName': 'Dr. Sarah Ali',
      'lastMessage': 'Let me know if symptoms persist',
      'updatedAt': '2024-04-19T09:00:00Z',
      'unreadCount': 3,
    },
  ];

  // Mock chat messages
  static const List<Map<String, dynamic>> mockMessages = [
    {
      'id': 'msg_001',
      'conversationId': 'conv_001',
      'senderId': 'doc_001',
      'receiverId': 'user_001',
      'senderName': 'Dr. Ahmed Malik',
      'message': 'Hello! How have you been feeling lately?',
      'sentAt': '2024-04-19T10:00:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_002',
      'conversationId': 'conv_001',
      'senderId': 'user_001',
      'receiverId': 'doc_001',
      'senderName': 'Ahmed Ali',
      'message': 'I have been having trouble sleeping and feeling anxious',
      'sentAt': '2024-04-19T10:15:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_003',
      'conversationId': 'conv_001',
      'senderId': 'doc_001',
      'receiverId': 'user_001',
      'senderName': 'Dr. Ahmed Malik',
      'message':
          'I recommend trying some relaxation techniques. Would you like me to suggest some?',
      'sentAt': '2024-04-19T10:30:00Z',
      'isRead': false,
      'messageType': 'text',
    },
    {
      'id': 'msg_004',
      'conversationId': 'conv_001',
      'senderId': 'user_001',
      'receiverId': 'doc_001',
      'senderName': 'Ahmed Ali',
      'message': 'Yes please! That would be very helpful.',
      'sentAt': '2024-04-19T10:45:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_005',
      'conversationId': 'conv_001',
      'senderId': 'doc_001',
      'receiverId': 'user_001',
      'senderName': 'Dr. Ahmed Malik',
      'message': 'How are you feeling today?',
      'sentAt': '2024-04-19T15:30:00Z',
      'isRead': false,
      'messageType': 'text',
    },
    {
      'id': 'msg_006',
      'conversationId': 'conv_002',
      'senderId': 'doc_002',
      'receiverId': 'user_001',
      'senderName': 'Dr. Fatima Zahra',
      'message': 'Remember to follow up with the exercises I recommended',
      'sentAt': '2024-04-18T09:00:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_007',
      'conversationId': 'conv_002',
      'senderId': 'user_001',
      'receiverId': 'doc_002',
      'senderName': 'Ahmed Ali',
      'message': 'I will, thank you!',
      'sentAt': '2024-04-18T09:30:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_008',
      'conversationId': 'conv_002',
      'senderId': 'doc_002',
      'receiverId': 'user_001',
      'senderName': 'Dr. Fatima Zahra',
      'message': 'Please remember to take your medication',
      'sentAt': '2024-04-18T10:15:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_009',
      'conversationId': 'conv_003',
      'senderId': 'user_002',
      'receiverId': 'doc_003',
      'senderName': 'Fatima Hassan',
      'message': 'Doctor, how are my results looking?',
      'sentAt': '2024-04-19T11:00:00Z',
      'isRead': true,
      'messageType': 'text',
    },
    {
      'id': 'msg_010',
      'conversationId': 'conv_003',
      'senderId': 'doc_003',
      'receiverId': 'user_002',
      'senderName': 'Dr. Mohammed Hassan',
      'message': 'Your test results look good',
      'sentAt': '2024-04-19T11:45:00Z',
      'isRead': false,
      'messageType': 'text',
    },
  ];

  static List<Map<String, dynamic>> getMockConversations() => mockConversations;

  static List<Map<String, dynamic>> getMockMessages() => mockMessages;

  static List<Map<String, dynamic>> getMockMessagesByConversation(
    String conversationId,
  ) {
    return mockMessages
        .where((msg) => msg['conversationId'] == conversationId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockConversationsByPatient(
    String patientId,
  ) {
    return mockConversations
        .where((conv) => conv['patientId'] == patientId)
        .toList();
  }

  static List<Map<String, dynamic>> getMockConversationsByDoctor(
    String doctorId,
  ) {
    return mockConversations
        .where((conv) => conv['doctorId'] == doctorId)
        .toList();
  }

  static Map<String, dynamic>? getMockConversationById(String id) {
    try {
      return mockConversations.firstWhere((conv) => conv['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockMessageById(String id) {
    try {
      return mockMessages.firstWhere((msg) => msg['id'] == id);
    } catch (e) {
      return null;
    }
  }
}

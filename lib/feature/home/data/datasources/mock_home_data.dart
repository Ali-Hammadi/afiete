class MockHomeData {
  // Mock home screen dashboard data
  static const Map<String, dynamic> mockDashboard = {
    'userId': 'user_001',
    'userName': 'Ahmed Ali',
    'lastLoginAt': '2024-04-19T15:30:00Z',
    'memberSince': '2023-06-15',
  };

  // Mock statistics for home screen
  static const Map<String, dynamic> mockStats = {
    'totalSessions': 15,
    'completedSessions': 12,
    'upcomingSessions': 3,
    'totalSessionsTime': 810, // in minutes
    'doctorVisits': 5,
    'appointmentsThisMonth': 4,
    'averageSessionRating': 4.7,
  };

  // Mock featured doctors for home screen
  static const List<Map<String, dynamic>> mockFeaturedDoctors = [
    {
      'id': 'doc_001',
      'name': 'Dr. Ahmed Malik',
      'specialization': 'psychiatrist',
      'rating': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'isAvailable': true,
      'isFeatured': true,
    },
    {
      'id': 'doc_002',
      'name': 'Dr. Fatima Zahra',
      'specialization': 'clinicalPsychologist',
      'rating': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'isAvailable': true,
      'isFeatured': true,
    },
    {
      'id': 'doc_005',
      'name': 'Dr. Sarah Ali',
      'specialization': 'counselor',
      'rating': 4.5,
      'imageUrl': 'https://via.placeholder.com/150?text=Sarah+Ali',
      'isAvailable': true,
      'isFeatured': true,
    },
  ];

  // Mock upcoming appointments for home screen
  static const List<Map<String, dynamic>> mockUpcomingAppointments = [
    {
      'id': 'apt_001',
      'doctorName': 'Dr. Ahmed Malik',
      'doctorSpecialization': 'psychiatrist',
      'scheduledAt': '2024-04-20T10:00:00Z',
      'sessionType': 'video_call',
      'status': 'confirmed',
    },
    {
      'id': 'apt_005',
      'doctorName': 'Dr. Ahmed Malik',
      'doctorSpecialization': 'psychiatrist',
      'scheduledAt': '2024-04-24T11:00:00Z',
      'sessionType': 'video_call',
      'status': 'confirmed',
    },
    {
      'id': 'apt_002',
      'doctorName': 'Dr. Fatima Zahra',
      'doctorSpecialization': 'clinicalPsychologist',
      'scheduledAt': '2024-04-21T14:00:00Z',
      'sessionType': 'text_chat',
      'status': 'pending',
    },
  ];

  // Mock recommendations for home screen
  static const List<Map<String, dynamic>> mockRecommendations = [
    {
      'id': 'rec_001',
      'title': 'Meditation for Anxiety Relief',
      'description': 'Try a 10-minute daily meditation to reduce anxiety symptoms.',
      'category': 'self_care',
      'icon': 'meditation',
      'color': 'blue',
    },
    {
      'id': 'rec_002',
      'title': 'Sleep Hygiene Tips',
      'description': 'Improve your sleep quality with proven techniques.',
      'category': 'health',
      'icon': 'sleep',
      'color': 'purple',
    },
    {
      'id': 'rec_003',
      'title': 'Exercise & Mood',
      'description': '30 minutes of physical activity can boost your mood significantly.',
      'category': 'exercise',
      'icon': 'fitness',
      'color': 'green',
    },
  ];

  // Mock wellness tips for home screen
  static const List<Map<String, dynamic>> mockWellnessTips = [
    {
      'id': 'tip_001',
      'title': 'Daily Affirmations',
      'description': 'Start each day with positive affirmations to boost mental health.',
      'tip': 'I am capable and strong.',
    },
    {
      'id': 'tip_002',
      'title': 'Breathing Exercises',
      'description': 'Practice the 4-7-8 breathing technique for stress relief.',
      'tip': 'Inhale for 4, hold for 7, exhale for 8.',
    },
    {
      'id': 'tip_003',
      'title': 'Journaling Benefits',
      'description': 'Write down your thoughts daily to process emotions.',
      'tip': 'Spend 10 minutes journaling before bed.',
    },
  ];

  // Mock quick actions for home screen
  static const List<Map<String, dynamic>> mockQuickActions = [
    {
      'id': 'action_001',
      'label': 'Book Doctor',
      'icon': 'calendar',
      'route': '/booking',
      'color': 'primary',
    },
    {
      'id': 'action_002',
      'label': 'Messages',
      'icon': 'message',
      'route': '/chat',
      'badgeCount': 2,
      'color': 'info',
    },
    {
      'id': 'action_003',
      'label': 'My Doctors',
      'icon': 'doctor',
      'route': '/doctors',
      'color': 'success',
    },
    {
      'id': 'action_004',
      'label': 'Health Records',
      'icon': 'file',
      'route': '/settings',
      'color': 'warning',
    },
  ];

  static Map<String, dynamic> getMockDashboard() => mockDashboard;

  static Map<String, dynamic> getMockStats() => mockStats;

  static List<Map<String, dynamic>> getMockFeaturedDoctors() => mockFeaturedDoctors;

  static List<Map<String, dynamic>> getMockUpcomingAppointments() => mockUpcomingAppointments;

  static List<Map<String, dynamic>> getMockRecommendations() => mockRecommendations;

  static List<Map<String, dynamic>> getMockWellnessTips() => mockWellnessTips;

  static List<Map<String, dynamic>> getMockQuickActions() => mockQuickActions;
}

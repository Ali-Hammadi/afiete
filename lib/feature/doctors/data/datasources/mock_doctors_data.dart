class MockDoctorsData {
  // Mock doctors data
  static const List<Map<String, dynamic>> mockDoctors = [
    {
      'id': 'doc_001',
      'name': 'Dr. Ahmed Malik',
      'specialization': 'psychiatrist',
      'experience': '12 years',
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'description':
          'Specialized in treating depression, anxiety disorders, and PTSD with evidence-based approaches.',
      'isOnline': true,
      'createdAt': '2023-01-15T00:00:00Z',
      'availableTimes': [
        '2024-04-20T09:00:00Z',
        '2024-04-20T10:00:00Z',
        '2024-04-20T14:00:00Z',
        '2024-04-21T11:00:00Z',
      ],
      'availableDurations': [30, 60],
      'availableSessionTypes': ['video_call', 'voice_call'],
      'consultationFee': {'text_chat': 30, 'voice_call': 40, 'video_call': 50},
    },
    {
      'id': 'doc_002',
      'name': 'Dr. Fatima Zahra',
      'specialization': 'clinicalPsychologist',
      'experience': '10 years',
      'rating': '4.9',
      'ratingValue': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'description':
          'Expert in cognitive behavioral therapy and anxiety management. Compassionate and patient-centered approach.',
      'isOnline': true,
      'createdAt': '2023-02-20T00:00:00Z',
      'availableTimes': [
        '2024-04-20T10:00:00Z',
        '2024-04-20T15:00:00Z',
        '2024-04-21T09:00:00Z',
        '2024-04-21T13:00:00Z',
      ],
      'availableDurations': [45, 60],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 35, 'voice_call': 45, 'video_call': 60},
    },
    {
      'id': 'doc_003',
      'name': 'Dr. Mohammed Hassan',
      'specialization': 'psychotherapist',
      'experience': '15 years',
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Mohammed+Hassan',
      'description':
          'Specializes in marriage and family therapy, relationship counseling. Expert in conflict resolution.',
      'isOnline': false,
      'createdAt': '2023-03-10T00:00:00Z',
      'availableTimes': [
        '2024-04-20T11:00:00Z',
        '2024-04-21T14:00:00Z',
        '2024-04-22T10:00:00Z',
      ],
      'availableDurations': [60],
      'availableSessionTypes': ['video_call', 'voice_call', 'text_chat'],
      'consultationFee': {'text_chat': 25, 'voice_call': 35, 'video_call': 45},
    },
    {
      'id': 'doc_004',
      'name': 'Dr. Leila Mansour',
      'specialization': 'cbtTherapist',
      'experience': '9 years',
      'rating': '4.6',
      'ratingValue': 4.6,
      'imageUrl': 'https://via.placeholder.com/150?text=Leila+Mansour',
      'description':
          'CBT specialist for anxiety, panic attacks, and OCD. Structured and goal-oriented therapy approach.',
      'isOnline': true,
      'createdAt': '2023-04-05T00:00:00Z',
      'availableTimes': [
        '2024-04-20T13:00:00Z',
        '2024-04-21T10:00:00Z',
        '2024-04-22T15:00:00Z',
      ],
      'availableDurations': [50, 60],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 32, 'voice_call': 42, 'video_call': 55},
    },
    {
      'id': 'doc_005',
      'name': 'Dr. Sarah Ali',
      'specialization': 'counselor',
      'experience': '7 years',
      'rating': '4.5',
      'ratingValue': 4.5,
      'imageUrl': 'https://via.placeholder.com/150?text=Sarah+Ali',
      'description':
          'Professional counselor for stress management, life coaching, and personal growth.',
      'isOnline': true,
      'createdAt': '2023-05-12T00:00:00Z',
      'availableTimes': [
        '2024-04-20T08:00:00Z',
        '2024-04-20T16:00:00Z',
        '2024-04-21T09:00:00Z',
      ],
      'availableDurations': [30, 45],
      'availableSessionTypes': ['text_chat', 'voice_call'],
      'consultationFee': {'text_chat': 20, 'voice_call': 30, 'video_call': 40},
    },
    {
      'id': 'doc_006',
      'name': 'Dr. Omar Taha',
      'specialization': 'traumaTherapist',
      'experience': '13 years',
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Omar+Taha',
      'description':
          'Trauma specialist with expertise in EMDR and trauma processing. Certified and experienced.',
      'isOnline': false,
      'createdAt': '2023-06-08T00:00:00Z',
      'availableTimes': [
        '2024-04-20T14:00:00Z',
        '2024-04-22T11:00:00Z',
        '2024-04-23T10:00:00Z',
      ],
      'availableDurations': [60],
      'availableSessionTypes': ['video_call'],
      'consultationFee': {'text_chat': 40, 'voice_call': 50, 'video_call': 70},
    },
    {
      'id': 'doc_007',
      'name': 'Dr. Noor Khalil',
      'specialization': 'marriageFamilyTherapist',
      'experience': '11 years',
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Noor+Khalil',
      'description':
          'Marriage and family therapist helping couples and families improve relationships and communication.',
      'isOnline': true,
      'createdAt': '2023-07-20T00:00:00Z',
      'availableTimes': [
        '2024-04-20T10:00:00Z',
        '2024-04-21T15:00:00Z',
        '2024-04-22T09:00:00Z',
      ],
      'availableDurations': [60, 90],
      'availableSessionTypes': ['video_call', 'voice_call'],
      'consultationFee': {'text_chat': 35, 'voice_call': 50, 'video_call': 65},
    },
    {
      'id': 'doc_008',
      'name': 'Dr. Karim Hassan',
      'specialization': 'psychiatrist',
      'experience': '14 years',
      'rating': '4.9',
      'ratingValue': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Karim+Hassan',
      'description':
          'Board-certified psychiatrist specializing in medication management and complex mental health cases.',
      'isOnline': true,
      'createdAt': '2023-08-15T00:00:00Z',
      'availableTimes': [
        '2024-04-20T09:00:00Z',
        '2024-04-21T11:00:00Z',
        '2024-04-22T14:00:00Z',
      ],
      'availableDurations': [30, 60],
      'availableSessionTypes': ['video_call', 'voice_call'],
      'consultationFee': {'text_chat': 45, 'voice_call': 55, 'video_call': 70},
    },
    {
      'id': 'doc_009',
      'name': 'Dr. Hana Mohammad',
      'specialization': 'childPsychologist',
      'experience': '8 years',
      'rating': '4.6',
      'ratingValue': 4.6,
      'imageUrl': 'https://via.placeholder.com/150?text=Hana+Mohammad',
      'description':
          'Child psychologist specializing in developmental issues, behavioral problems, and educational support.',
      'isOnline': true,
      'createdAt': '2023-09-10T00:00:00Z',
      'availableTimes': [
        '2024-04-20T15:00:00Z',
        '2024-04-21T10:00:00Z',
        '2024-04-22T13:00:00Z',
      ],
      'availableDurations': [45],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 28, 'voice_call': 38, 'video_call': 48},
    },
    {
      'id': 'doc_010',
      'name': 'Dr. Layla Rahman',
      'specialization': 'psychoanalyst',
      'experience': '16 years',
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Layla+Rahman',
      'description':
          'Experienced psychoanalyst offering deep insight-oriented therapy for long-term psychological growth.',
      'isOnline': false,
      'createdAt': '2023-10-05T00:00:00Z',
      'availableTimes': [
        '2024-04-20T12:00:00Z',
        '2024-04-22T10:00:00Z',
        '2024-04-23T14:00:00Z',
      ],
      'availableDurations': [60, 90],
      'availableSessionTypes': ['video_call'],
      'consultationFee': {'text_chat': 50, 'voice_call': 60, 'video_call': 80},
    },
    {
      'id': 'doc_011',
      'name': 'Dr. Yara Nabil',
      'specialization': 'clinicalPsychologist',
      'experience': '9 years',
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Yara+Nabil',
      'description':
          'Focuses on burnout recovery and emotional regulation plans.',
      'isOnline': true,
      'createdAt': '2023-11-01T00:00:00Z',
      'availableTimes': [
        '2024-04-21T12:00:00Z',
        '2024-04-22T16:00:00Z',
        '2024-04-23T09:00:00Z',
      ],
      'availableDurations': [45, 60],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 33, 'voice_call': 43, 'video_call': 56},
    },
    {
      'id': 'doc_012',
      'name': 'Dr. Tamer Adel',
      'specialization': 'cbtTherapist',
      'experience': '11 years',
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Tamer+Adel',
      'description':
          'Structured CBT programs for panic, avoidance, and intrusive thoughts.',
      'isOnline': true,
      'createdAt': '2023-12-03T00:00:00Z',
      'availableTimes': [
        '2024-04-21T08:00:00Z',
        '2024-04-22T12:00:00Z',
        '2024-04-23T15:00:00Z',
      ],
      'availableDurations': [30, 60],
      'availableSessionTypes': ['video_call', 'voice_call', 'text_chat'],
      'consultationFee': {'text_chat': 36, 'voice_call': 46, 'video_call': 58},
    },
  ];

  static List<Map<String, dynamic>> getMockDoctors() => mockDoctors;

  static List<Map<String, dynamic>> getMockDoctorsBySpecialty(
    String specialty,
  ) {
    return mockDoctors
        .where((doc) => doc['specialization'] == specialty)
        .toList();
  }

  static List<Map<String, dynamic>> getOnlineDoctors() {
    return mockDoctors.where((doc) => doc['isOnline'] == true).toList();
  }

  static List<Map<String, dynamic>> getTopRatedDoctors(int limit) {
    final sorted = List<Map<String, dynamic>>.from(mockDoctors);
    sorted.sort(
      (a, b) => (b['ratingValue'] as num).compareTo(a['ratingValue'] as num),
    );
    return sorted.take(limit).toList();
  }

  static Map<String, dynamic>? getMockDoctorById(String id) {
    try {
      return mockDoctors.firstWhere((doc) => doc['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static List<Map<String, dynamic>> searchDoctors(String query) {
    final lowerQuery = query.toLowerCase();
    return mockDoctors
        .where(
          (doc) =>
              doc['name'].toString().toLowerCase().contains(lowerQuery) ||
              doc['specialization'].toString().toLowerCase().contains(
                lowerQuery,
              ),
        )
        .toList();
  }
}

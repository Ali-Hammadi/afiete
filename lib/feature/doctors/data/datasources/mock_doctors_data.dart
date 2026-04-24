import 'package:afiete/core/constants/settings_strings.dart';

class MockDoctorsData {
  // Mock doctors data
  static List<Map<String, dynamic>> get mockDoctors => [
    {
      'id': 'doc_001',
      'name': 'Dr. Ahmed Malik',
      'specialization': 'psychiatrist',
      'experience': SettingsStrings.experienceYearsLabel('12 years'),
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'description':
          'Specialized in treating depression, anxiety disorders, and PTSD with evidence-based approaches.',
      'isOnline': true,
      'createdAt': '2023-01-15T00:00:00Z',
      'availableTimes': [
        '2026-04-25T09:00:00Z',
        '2026-04-25T10:00:00Z',
        '2026-04-25T14:00:00Z',
        '2026-04-26T11:00:00Z',
      ],
      'availableDurations': [30, 60],
      'availableSessionTypes': ['video_call', 'voice_call'],
      'consultationFee': {'text_chat': 30, 'voice_call': 40, 'video_call': 50},
    },
    {
      'id': 'doc_002',
      'name': 'Dr. Fatima Zahra',
      'specialization': 'clinicalPsychologist',
      'experience': SettingsStrings.experienceYearsLabel('10 years'),
      'rating': '4.9',
      'ratingValue': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'description':
          'Expert in cognitive behavioral therapy and anxiety management. Compassionate and patient-centered approach.',
      'isOnline': true,
      'createdAt': '2023-02-20T00:00:00Z',
      'availableTimes': [
        '2026-04-25T10:00:00Z',
        '2026-04-25T15:00:00Z',
        '2026-04-26T09:00:00Z',
        '2026-04-26T13:00:00Z',
      ],
      'availableDurations': [45, 60],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 35, 'voice_call': 45, 'video_call': 60},
    },
    {
      'id': 'doc_003',
      'name': 'Dr. Mohammed Hassan',
      'specialization': 'psychotherapist',
      'experience': SettingsStrings.experienceYearsLabel('15 years'),
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Mohammed+Hassan',
      'description':
          'Specializes in marriage and family therapy, relationship counseling. Expert in conflict resolution.',
      'isOnline': false,
      'createdAt': '2023-03-10T00:00:00Z',
      'availableTimes': [
        '2026-04-25T11:00:00Z',
        '2026-04-26T14:00:00Z',
        '2026-04-27T10:00:00Z',
      ],
      'availableDurations': [60],
      'availableSessionTypes': ['video_call', 'voice_call', 'text_chat'],
      'consultationFee': {'text_chat': 25, 'voice_call': 35, 'video_call': 45},
    },
    {
      'id': 'doc_004',
      'name': 'Dr. Leila Mansour',
      'specialization': 'cbtTherapist',
      'experience': SettingsStrings.experienceYearsLabel('9 years'),
      'rating': '4.6',
      'ratingValue': 4.6,
      'imageUrl': 'https://via.placeholder.com/150?text=Leila+Mansour',
      'description':
          'CBT specialist for anxiety, panic attacks, and OCD. Structured and goal-oriented therapy approach.',
      'isOnline': true,
      'createdAt': '2023-04-05T00:00:00Z',
      'availableTimes': [
        '2026-04-25T13:00:00Z',
        '2026-04-26T10:00:00Z',
        '2026-04-27T15:00:00Z',
      ],
      'availableDurations': [50, 60],
      'availableSessionTypes': ['video_call', 'text_chat'],
      'consultationFee': {'text_chat': 32, 'voice_call': 42, 'video_call': 55},
    },
    {
      'id': 'doc_005',
      'name': 'Dr. Sarah Ali',
      'specialization': 'counselor',
      'experience': SettingsStrings.experienceYearsLabel('7 years'),
      'rating': '4.5',
      'ratingValue': 4.5,
      'imageUrl': 'https://via.placeholder.com/150?text=Sarah+Ali',
      'description':
          'Professional counselor for stress management, life coaching, and personal growth.',
      'isOnline': true,
      'createdAt': '2023-05-12T00:00:00Z',
      'availableTimes': [
        '2026-04-25T08:00:00Z',
        '2026-04-25T16:00:00Z',
        '2026-04-26T09:00:00Z',
      ],
      'availableDurations': [30, 45],
      'availableSessionTypes': ['text_chat', 'voice_call'],
      'consultationFee': {'text_chat': 20, 'voice_call': 30, 'video_call': 40},
    },
    {
      'id': 'doc_006',
      'name': 'Dr. Omar Taha',
      'specialization': 'traumaTherapist',
      'experience': SettingsStrings.experienceYearsLabel('13 years'),
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
      'experience': SettingsStrings.experienceYearsLabel('11 years'),
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
      'experience': SettingsStrings.experienceYearsLabel('14 years'),
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
      'experience': SettingsStrings.experienceYearsLabel('8 years'),
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
      'experience': SettingsStrings.experienceYearsLabel('16 years'),
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

class MockSettingsData {
  // Mock medical profiles
  static const List<Map<String, dynamic>> mockMedicalProfiles = [
    {
      'id': 'profile_001',
      'userId': 'user_001',
      'bloodType': 'O+',
      'allergies': ['Penicillin', 'Aspirin'],
      'existingConditions': ['Anxiety Disorder', 'Insomnia'],
      'medications': ['Sertraline 50mg', 'Melatonin 5mg'],
      'prescriptions': [
        {
          'id': 'presc_001',
          'medicine': 'Sertraline',
          'dosage': '50mg',
          'frequency': 'Once daily',
          'startDate': '2024-01-15',
          'endDate': '2024-04-15',
          'prescribedBy': 'Dr. Ahmed Malik',
          'reason': 'Anxiety management',
          'refillsRemaining': 2,
          'nextRefillDate': '2024-05-01',
        },
        {
          'id': 'presc_002',
          'medicine': 'Melatonin',
          'dosage': '5mg',
          'frequency': 'Once at bedtime',
          'startDate': '2024-02-01',
          'endDate': '2024-05-01',
          'prescribedBy': 'Dr. Fatima Zahra',
          'reason': 'Sleep improvement',
          'refillsRemaining': 1,
          'nextRefillDate': '2024-05-15',
        },
      ],
      'notes': [
        {
          'id': 'note_001',
          'title': 'Sleep Issues',
          'content':
              'Experiencing difficulty falling asleep. Melatonin helping but still waking up at 3-4 AM.',
          'doctorId': 'doc_002',
          'createdAt': '2024-04-10T14:30:00Z',
          'updatedAt': '2024-04-15T10:00:00Z',
        },
        {
          'id': 'note_002',
          'title': 'Anxiety Management Progress',
          'content':
              'Patient reports reduced anxiety levels after 2 weeks of Sertraline. Continue current dosage.',
          'doctorId': 'doc_001',
          'createdAt': '2024-04-05T11:20:00Z',
          'updatedAt': '2024-04-15T09:30:00Z',
        },
      ],
      'emergencyContact': {
        'name': 'Sara Ali',
        'relationship': 'Sister',
        'phoneNumber': '+966509876543',
      },
      'updatedAt': '2024-04-15T14:30:00Z',
    },
    {
      'id': 'profile_002',
      'userId': 'user_002',
      'bloodType': 'A-',
      'allergies': ['Sulfites', 'Shellfish'],
      'existingConditions': ['Depression', 'Migraine'],
      'medications': ['Fluoxetine 20mg', 'Sumatriptan 50mg'],
      'prescriptions': [
        {
          'id': 'presc_003',
          'medicine': 'Fluoxetine',
          'dosage': '20mg',
          'frequency': 'Once daily',
          'startDate': '2024-03-01',
          'endDate': '2024-06-01',
          'prescribedBy': 'Dr. Ahmed Malik',
          'reason': 'Depression treatment',
          'refillsRemaining': 3,
          'nextRefillDate': '2024-05-20',
        },
        {
          'id': 'presc_004',
          'medicine': 'Sumatriptan',
          'dosage': '50mg',
          'frequency': 'As needed for migraines',
          'startDate': '2024-02-15',
          'endDate': '2024-08-15',
          'prescribedBy': 'Dr. Mohammed Hassan',
          'reason': 'Migraine relief',
          'refillsRemaining': 5,
          'nextRefillDate': '2024-06-01',
        },
      ],
      'notes': [
        {
          'id': 'note_003',
          'title': 'Migraine Frequency',
          'content':
              'Migraines occurring 2-3 times per week. May need dosage adjustment.',
          'doctorId': 'doc_003',
          'createdAt': '2024-04-12T13:00:00Z',
          'updatedAt': '2024-04-15T11:00:00Z',
        },
      ],
      'emergencyContact': {
        'name': 'Hassan Ahmed',
        'relationship': 'Brother',
        'phoneNumber': '+966505555555',
      },
      'updatedAt': '2024-04-15T13:00:00Z',
    },
    {
      'id': 'profile_003',
      'userId': 'user_003',
      'bloodType': 'B+',
      'allergies': ['Latex', 'Nuts'],
      'existingConditions': ['ADHD', 'Anxiety'],
      'medications': ['Methylphenidate 30mg', 'Buspirone 15mg'],
      'prescriptions': [
        {
          'id': 'presc_005',
          'medicine': 'Methylphenidate',
          'dosage': '30mg',
          'frequency': 'Twice daily',
          'startDate': '2024-01-20',
          'endDate': '2024-07-20',
          'prescribedBy': 'Dr. Karim Hassan',
          'reason': 'ADHD management',
          'refillsRemaining': 4,
          'nextRefillDate': '2024-05-10',
        },
        {
          'id': 'presc_006',
          'medicine': 'Buspirone',
          'dosage': '15mg',
          'frequency': 'Twice daily',
          'startDate': '2024-03-10',
          'endDate': '2024-09-10',
          'prescribedBy': 'Dr. Leila Mansour',
          'reason': 'Anxiety control',
          'refillsRemaining': 2,
          'nextRefillDate': '2024-05-25',
        },
      ],
      'notes': [
        {
          'id': 'note_004',
          'title': 'ADHD Medication Adjustment',
          'content':
              'Methylphenidate dosage increased from 20mg to 30mg. Patient showing good response.',
          'doctorId': 'doc_008',
          'createdAt': '2024-04-08T10:15:00Z',
          'updatedAt': '2024-04-15T10:15:00Z',
        },
        {
          'id': 'note_005',
          'title': 'Anxiety Improvement',
          'content':
              'Buspirone helping with anxiety symptoms. Patient reports better focus and sleep.',
          'doctorId': 'doc_004',
          'createdAt': '2024-04-10T14:45:00Z',
          'updatedAt': '2024-04-15T14:45:00Z',
        },
      ],
      'emergencyContact': {
        'name': 'Fatima Mohammed',
        'relationship': 'Mother',
        'phoneNumber': '+966501111111',
      },
      'updatedAt': '2024-04-15T15:00:00Z',
    },
  ];

  static List<Map<String, dynamic>> getMockMedicalProfiles() =>
      mockMedicalProfiles;

  static Map<String, dynamic>? getMockMedicalProfileByUserId(String userId) {
    try {
      return mockMedicalProfiles.firstWhere(
        (profile) => profile['userId'] == userId,
      );
    } catch (e) {
      return null;
    }
  }

  static List<Object> getMockAllergiesByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile != null ? List<String>.from(profile['allergies'] ?? []) : [];
  }

  static List<Map<String, dynamic>> getMockPrescriptionsByUserId(
    String userId,
  ) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile != null
        ? List<Map<String, dynamic>>.from(profile['prescriptions'] ?? [])
        : [];
  }

  static List<Map<String, dynamic>> getMockNotesByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile != null
        ? List<Map<String, dynamic>>.from(profile['notes'] ?? [])
        : [];
  }

  static List<String> getMockConditionsByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile != null
        ? List<String>.from(profile['existingConditions'] ?? [])
        : [];
  }

  static List<String> getMockMedicationsByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile != null
        ? List<String>.from(profile['medications'] ?? [])
        : [];
  }

  static String? getMockBloodTypeByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile?['bloodType'];
  }

  static Map<String, dynamic>? getMockEmergencyContactByUserId(String userId) {
    final profile = getMockMedicalProfileByUserId(userId);
    return profile?['emergencyContact'] != null
        ? Map<String, dynamic>.from(profile?['emergencyContact'])
        : null;
  }
}

class MockAssignmentsData {
  // Mock psychological assessment questions (PHQ-9 style depression screening)
  static const List<Map<String, dynamic>> mockAssignmentQuestions = [
    {
      'id': 'q_001',
      'questionText': 'Little interest or pleasure in doing things',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'mood',
    },
    {
      'id': 'q_002',
      'questionText': 'Feeling down, depressed, or hopeless',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'mood',
    },
    {
      'id': 'q_003',
      'questionText': 'Trouble falling or staying asleep, or sleeping too much',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'sleep',
    },
    {
      'id': 'q_004',
      'questionText': 'Feeling tired or having little energy',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'energy',
    },
    {
      'id': 'q_005',
      'questionText': 'Poor appetite or overeating',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'appetite',
    },
    {
      'id': 'q_006',
      'questionText': 'Feeling bad about yourself or that you are a failure',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'self_worth',
    },
    {
      'id': 'q_007',
      'questionText': 'Trouble concentrating on things',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'concentration',
    },
    {
      'id': 'q_008',
      'questionText': 'Moving or speaking so slowly that others have noticed',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'motor',
    },
    {
      'id': 'q_009',
      'questionText': 'Thoughts that you would be better off dead',
      'options': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day',
        'Extremely',
      ],
      'validation': 'required',
      'category': 'suicidality',
    },
  ];

  // Mock assessment results with recommendations
  static const List<Map<String, dynamic>> mockAssignmentResults = [
    {
      'resultId': 'result_001',
      'score': 5,
      'severity': 'minimal',
      'summary':
          'Your assessment indicates minimal symptoms of depression. Continue with healthy lifestyle habits.',
      'recommendedDoctorIds': ['doc_005'],
      'recommendedSpecialties': ['counselor'],
    },
    {
      'resultId': 'result_002',
      'score': 12,
      'severity': 'mild',
      'summary':
          'Your assessment indicates mild depressive symptoms. Consider speaking with a mental health professional.',
      'recommendedDoctorIds': ['doc_001', 'doc_003'],
      'recommendedSpecialties': ['clinicalPsychologist', 'psychotherapist'],
    },
    {
      'resultId': 'result_003',
      'score': 19,
      'severity': 'moderate',
      'summary':
          'Your assessment indicates moderate depressive symptoms. Professional support is recommended.',
      'recommendedDoctorIds': ['doc_001', 'doc_002', 'doc_004'],
      'recommendedSpecialties': ['psychiatrist', 'clinicalPsychologist'],
    },
    {
      'resultId': 'result_004',
      'score': 27,
      'severity': 'moderately_severe',
      'summary':
          'Your assessment indicates moderately severe depressive symptoms. Professional psychological or psychiatric care is strongly recommended.',
      'recommendedDoctorIds': ['doc_001', 'doc_002'],
      'recommendedSpecialties': ['psychiatrist', 'cbtTherapist'],
    },
    {
      'resultId': 'result_005',
      'score': 30,
      'severity': 'severe',
      'summary':
          'Your assessment indicates severe depressive symptoms. Immediate professional help is recommended. Please reach out to a mental health professional.',
      'recommendedDoctorIds': ['doc_001', 'doc_002'],
      'recommendedSpecialties': ['psychiatrist', 'traumaTherapist'],
    },
  ];

  // Mock user responses to assignment
  static const List<Map<String, dynamic>> mockUserResponses = [
    {
      'userId': 'user_001',
      'assignmentId': 'assignment_001',
      'responses': {
        'q_001': 'Not at all',
        'q_002': 'Several days',
        'q_003': 'More than half the days',
        'q_004': 'Not at all',
        'q_005': 'Several days',
        'q_006': 'Not at all',
        'q_007': 'Several days',
        'q_008': 'Not at all',
        'q_009': 'Not at all',
      },
      'completedAt': '2024-04-10T14:30:00Z',
      'score': 12,
      'severity': 'mild',
    },
    {
      'userId': 'user_002',
      'assignmentId': 'assignment_001',
      'responses': {
        'q_001': 'Nearly every day',
        'q_002': 'Nearly every day',
        'q_003': 'More than half the days',
        'q_004': 'Nearly every day',
        'q_005': 'More than half the days',
        'q_006': 'Nearly every day',
        'q_007': 'Nearly every day',
        'q_008': 'Several days',
        'q_009': 'Several days',
      },
      'completedAt': '2024-04-10T15:45:00Z',
      'score': 27,
      'severity': 'moderately_severe',
    },
  ];

  static List<Map<String, dynamic>> getMockQuestions() =>
      mockAssignmentQuestions;

  static List<Map<String, dynamic>> getMockResults() => mockAssignmentResults;

  static List<Map<String, dynamic>> getMockUserResponses() => mockUserResponses;

  static Map<String, dynamic>? getMockQuestionById(String id) {
    try {
      return mockAssignmentQuestions.firstWhere((q) => q['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getMockResultById(String id) {
    try {
      return mockAssignmentResults.firstWhere((r) => r['resultId'] == id);
    } catch (e) {
      return null;
    }
  }
}

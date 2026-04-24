import 'package:afiete/core/constants/settings_strings.dart';

class MockAssignmentsData {
  static String _localized(String en, String ar) =>
      SettingsStrings.isArabic ? ar : en;

  // Mock psychological assessment questions (PHQ-9 style depression screening)
  static List<Map<String, dynamic>> get mockAssignmentQuestions => [
    {
      'id': 'q_001',
      'questionText': _localized(
        'Little interest or pleasure in doing things',
        'قلة الاهتمام أو المتعة في القيام بالأشياء',
      ),
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
      'questionText': _localized(
        'Feeling down, depressed, or hopeless',
        'الشعور بالحزن أو الاكتئاب أو اليأس',
      ),
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
      'questionText': _localized(
        'Trouble falling or staying asleep, or sleeping too much',
        'صعوبة في النوم أو الاستمرار فيه، أو النوم أكثر من اللازم',
      ),
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
      'questionText': _localized(
        'Feeling tired or having little energy',
        'الشعور بالتعب أو قلة الطاقة',
      ),
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
      'questionText': _localized(
        'Poor appetite or overeating',
        'ضعف الشهية أو الإفراط في الأكل',
      ),
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
      'questionText': _localized(
        'Feeling bad about yourself or that you are a failure',
        'الشعور بالسوء تجاه نفسك أو أنك فاشل',
      ),
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
      'questionText': _localized(
        'Trouble concentrating on things',
        'صعوبة في التركيز على الأمور',
      ),
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
      'questionText': _localized(
        'Moving or speaking so slowly that others have noticed',
        'التحرك أو الكلام ببطء لدرجة يلاحظها الآخرون',
      ),
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
      'questionText': _localized(
        'Thoughts that you would be better off dead',
        'أفكار بأنك ستكون أفضل لو كنت ميتًا',
      ),
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
  static List<Map<String, dynamic>> get mockAssignmentResults => [
    {
      'resultId': 'result_001',
      'score': 5,
      'severity': 'minimal',
      'summary': _localized(
        'Your assessment indicates minimal symptoms of depression. Continue with healthy lifestyle habits.',
        'تشير نتيجتك إلى أعراض بسيطة جدًا. واصل العادات الصحية اليومية.',
      ),
      'recommendedDoctorIds': ['doc_005'],
      'recommendedSpecialties': ['counselor'],
    },
    {
      'resultId': 'result_002',
      'score': 12,
      'severity': 'mild',
      'summary': _localized(
        'Your assessment indicates mild depressive symptoms. Consider speaking with a mental health professional.',
        'تشير نتيجتك إلى أعراض خفيفة. فكر في التحدث مع مختص نفسي.',
      ),
      'recommendedDoctorIds': ['doc_001', 'doc_003'],
      'recommendedSpecialties': ['clinicalPsychologist', 'psychotherapist'],
    },
    {
      'resultId': 'result_003',
      'score': 19,
      'severity': 'moderate',
      'summary': _localized(
        'Your assessment indicates moderate depressive symptoms. Professional support is recommended.',
        'تشير نتيجتك إلى أعراض متوسطة. يُنصح بدعم مهني متخصص.',
      ),
      'recommendedDoctorIds': ['doc_001', 'doc_002', 'doc_004'],
      'recommendedSpecialties': ['psychiatrist', 'clinicalPsychologist'],
    },
    {
      'resultId': 'result_004',
      'score': 27,
      'severity': 'moderately_severe',
      'summary': _localized(
        'Your assessment indicates moderately severe depressive symptoms. Professional psychological or psychiatric care is strongly recommended.',
        'تشير نتيجتك إلى أعراض متوسطة إلى شديدة. يُنصح بقوة بالرعاية النفسية أو النفسية-الطبية المتخصصة.',
      ),
      'recommendedDoctorIds': ['doc_001', 'doc_002'],
      'recommendedSpecialties': ['psychiatrist', 'cbtTherapist'],
    },
    {
      'resultId': 'result_005',
      'score': 30,
      'severity': 'severe',
      'summary': _localized(
        'Your assessment indicates severe depressive symptoms. Immediate professional help is recommended. Please reach out to a mental health professional.',
        'تشير نتيجتك إلى أعراض شديدة. يُنصح بطلب المساعدة المهنية فورًا. يرجى التواصل مع مختص نفسي.',
      ),
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

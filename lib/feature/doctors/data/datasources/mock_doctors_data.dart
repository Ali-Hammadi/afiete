import 'package:afiete/core/constants/settings_strings.dart';

class MockDoctorsData {
  static String _localized(String en, String ar) =>
      SettingsStrings.isArabic ? ar : en;

  static final Map<String, List<Map<String, dynamic>>> _extraDoctorReviews = {};

  // Mock doctors data
  static List<Map<String, dynamic>> get mockDoctors => [
    {
      'id': 'doc_001',
      'name': _localized('Dr. Ahmed Malik', 'د. أحمد مالك'),
      'specialization': 'psychiatrist',
      'experience': SettingsStrings.experienceYearsLabel('12 years'),
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Ahmed+Malik',
      'description': _localized(
        'Specialized in treating depression, anxiety disorders, and PTSD with evidence-based approaches.',
        'متخصص في علاج الاكتئاب واضطرابات القلق واضطراب ما بعد الصدمة بأساليب قائمة على الأدلة.',
      ),
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
      'name': _localized('Dr. Fatima Zahra', 'د. فاطمة الزهراء'),
      'specialization': 'clinicalPsychologist',
      'experience': SettingsStrings.experienceYearsLabel('10 years'),
      'rating': '4.9',
      'ratingValue': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Fatima+Zahra',
      'description': _localized(
        'Expert in cognitive behavioral therapy and anxiety management. Compassionate and patient-centered approach.',
        'خبيرة في العلاج المعرفي السلوكي وإدارة القلق، وتتبنى نهجًا رحيمًا يركز على المريض.',
      ),
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
      'name': _localized('Dr. Mohammed Hassan', 'د. محمد حسن'),
      'specialization': 'psychotherapist',
      'experience': SettingsStrings.experienceYearsLabel('15 years'),
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Mohammed+Hassan',
      'description': _localized(
        'Specializes in marriage and family therapy, relationship counseling. Expert in conflict resolution.',
        'متخصص في العلاج الأسري والزوجي والإرشاد العلاقي، وخبير في حل النزاعات.',
      ),
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
      'name': _localized('Dr. Leila Mansour', 'د. ليلى منصور'),
      'specialization': 'cbtTherapist',
      'experience': SettingsStrings.experienceYearsLabel('9 years'),
      'rating': '4.6',
      'ratingValue': 4.6,
      'imageUrl': 'https://via.placeholder.com/150?text=Leila+Mansour',
      'description': _localized(
        'CBT specialist for anxiety, panic attacks, and OCD. Structured and goal-oriented therapy approach.',
        'متخصصة في العلاج المعرفي السلوكي للقلق ونوبات الهلع والوسواس القهري، مع نهج علاجي منظم وموجه للأهداف.',
      ),
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
      'name': _localized('Dr. Sarah Ali', 'د. سارة علي'),
      'specialization': 'counselor',
      'experience': SettingsStrings.experienceYearsLabel('7 years'),
      'rating': '4.5',
      'ratingValue': 4.5,
      'imageUrl': 'https://via.placeholder.com/150?text=Sarah+Ali',
      'description': _localized(
        'Professional counselor for stress management, life coaching, and personal growth.',
        'مرشدة مهنية لإدارة التوتر والتوجيه الحياتي والنمو الشخصي.',
      ),
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
      'name': _localized('Dr. Omar Taha', 'د. عمر طه'),
      'specialization': 'traumaTherapist',
      'experience': SettingsStrings.experienceYearsLabel('13 years'),
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Omar+Taha',
      'description': _localized(
        'Trauma specialist with expertise in EMDR and trauma processing. Certified and experienced.',
        'متخصص في الصدمات النفسية وخبير في EMDR ومعالجة الصدمات، مع اعتماد وخبرة مهنية.',
      ),
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
      'name': _localized('Dr. Noor Khalil', 'د. نور خليل'),
      'specialization': 'marriageFamilyTherapist',
      'experience': SettingsStrings.experienceYearsLabel('11 years'),
      'rating': '4.7',
      'ratingValue': 4.7,
      'imageUrl': 'https://via.placeholder.com/150?text=Noor+Khalil',
      'description': _localized(
        'Marriage and family therapist helping couples and families improve relationships and communication.',
        'معالجة زوجية وأسرية تساعد الأزواج والعائلات على تحسين العلاقات والتواصل.',
      ),
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
      'name': _localized('Dr. Karim Hassan', 'د. كريم حسن'),
      'specialization': 'psychiatrist',
      'experience': SettingsStrings.experienceYearsLabel('14 years'),
      'rating': '4.9',
      'ratingValue': 4.9,
      'imageUrl': 'https://via.placeholder.com/150?text=Karim+Hassan',
      'description': _localized(
        'Board-certified psychiatrist specializing in medication management and complex mental health cases.',
        'طبيب نفسي معتمد متخصص في إدارة الأدوية وحالات الصحة النفسية المعقدة.',
      ),
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
      'name': _localized('Dr. Hana Mohammad', 'د. هناء محمد'),
      'specialization': 'childPsychologist',
      'experience': SettingsStrings.experienceYearsLabel('8 years'),
      'rating': '4.6',
      'ratingValue': 4.6,
      'imageUrl': 'https://via.placeholder.com/150?text=Hana+Mohammad',
      'description': _localized(
        'Child psychologist specializing in developmental issues, behavioral problems, and educational support.',
        'أخصائية نفسية للأطفال متخصصة في قضايا النمو والمشكلات السلوكية والدعم التعليمي.',
      ),
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
      'name': _localized('Dr. Layla Rahman', 'د. ليلى رحمن'),
      'specialization': 'psychoanalyst',
      'experience': SettingsStrings.experienceYearsLabel('16 years'),
      'rating': '4.8',
      'ratingValue': 4.8,
      'imageUrl': 'https://via.placeholder.com/150?text=Layla+Rahman',
      'description': _localized(
        'Experienced psychoanalyst offering deep insight-oriented therapy for long-term psychological growth.',
        'محللة نفسية خبيرة تقدم علاجًا عميقًا قائمًا على الفهم للنمو النفسي طويل الأمد.',
      ),
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

  static List<Map<String, dynamic>> getMockDoctorReviews(String doctorId) {
    final reviewsByDoctor = <String, List<Map<String, dynamic>>>{
      'doc_001': [
        _review(
          reviewerName: _localized('Fadi', 'فادي'),
          reviewTime: _localized('Yesterday', 'أمس'),
          rating: '4.8',
          review: _localized(
            'Dr. Ahmed Malik explained everything clearly and gave me confidence.',
            'شرح د. أحمد مالك كل شيء بوضوح ومنحني ثقة كبيرة.',
          ),
        ),
        _review(
          reviewerName: _localized('Samer', 'سامر'),
          reviewTime: _localized('Last month', 'الشهر الماضي'),
          rating: '4.9',
          review: _localized(
            'Professional, calm, and attentive to every detail.',
            'مهني وهادئ ومتفهم لكل التفاصيل.',
          ),
        ),
        _review(
          reviewerName: _localized('Maya', 'مايا'),
          reviewTime: _localized('Last week', 'الأسبوع الماضي'),
          rating: '4.8',
          review: _localized(
            'His treatment plan felt realistic and supportive.',
            'كانت خطة العلاج معه واقعية وداعمة.',
          ),
        ),
      ],
      'doc_002': [
        _review(
          reviewerName: _localized('Maya', 'مايا'),
          reviewTime: _localized('Yesterday', 'أمس'),
          rating: '4.9',
          review: _localized(
            'Her CBT sessions were practical and helpful.',
            'كانت جلسات العلاج المعرفي السلوكي معها عملية ومفيدة.',
          ),
        ),
        _review(
          reviewerName: _localized('Rami', 'رامي'),
          reviewTime: _localized('Last month', 'الشهر الماضي'),
          rating: '4.8',
          review: _localized(
            'She listened carefully and guided me step by step.',
            'استمعت إليّ بعناية ووجهتني خطوة بخطوة.',
          ),
        ),
        _review(
          reviewerName: _localized('Nour', 'نور'),
          reviewTime: _localized('Two weeks ago', 'قبل أسبوعين'),
          rating: '4.9',
          review: _localized(
            'Very empathetic and professional.',
            'متعاطفة جدًا ومهنية.',
          ),
        ),
      ],
    };

    final defaultReviews = [
      _review(
        reviewerName: _localized('Patient', 'مراجع'),
        reviewTime: _localized('Recently', 'مؤخرًا'),
        rating: '4.8',
        review: _localized(
          'This doctor provided thoughtful and helpful care.',
          'قدّم هذا الطبيب رعاية مفيدة ومدروسة.',
        ),
      ),
      _review(
        reviewerName: _localized('Patient', 'مراجع'),
        reviewTime: _localized('Recently', 'مؤخرًا'),
        rating: '4.8',
        review: _localized(
          'The consultation was clear and reassuring.',
          'كانت الاستشارة واضحة ومطمئنة.',
        ),
      ),
      _review(
        reviewerName: _localized('Patient', 'مراجع'),
        reviewTime: _localized('Recently', 'مؤخرًا'),
        rating: '4.8',
        review: _localized(
          'I would recommend this doctor.',
          'أنصح بهذا الطبيب.',
        ),
      ),
    ];

    return [
      ...(_extraDoctorReviews[doctorId] ?? const []),
      ...(reviewsByDoctor[doctorId] ?? defaultReviews),
    ];
  }

  static void addMockDoctorReview({
    required String doctorId,
    required int rating,
    required String review,
  }) {
    final reviewEntry = _review(
      reviewerName: _localized('Patient', 'مراجع'),
      reviewTime: _localized('Just now', 'الآن'),
      rating: rating.toStringAsFixed(1),
      review: review,
    );

    final current = List<Map<String, dynamic>>.from(
      _extraDoctorReviews[doctorId] ?? const [],
    );
    current.insert(0, reviewEntry);
    _extraDoctorReviews[doctorId] = current;
  }

  static Map<String, dynamic> _review({
    required String reviewerName,
    required String reviewTime,
    required String rating,
    required String review,
  }) {
    return {
      'reviewerName': reviewerName,
      'reviewTime': reviewTime,
      'rating': rating,
      'review': review,
    };
  }

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

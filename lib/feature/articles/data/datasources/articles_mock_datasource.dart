import 'package:afiete/feature/articles/data/datasources/articles_remote_datasource.dart';
import 'package:afiete/feature/articles/data/models/article_model.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

class ArticlesMockDataSourceImpl implements ArticlesRemoteDataSource {
  final DoctorEntity _doctorAhmed = DoctorEntity(
    id: 'doc_001',
    name: 'Dr. Ahmed Malik',
    specialization: 'psychiatrist',
    experience: '12 years',
    rating: '4.8',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Ahmed',
    description: 'Specialized in depression and anxiety management.',
    isOnline: true,
    ratingValue: 4.8,
    createdAt: DateTime(2023, 1, 15),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorFatima = DoctorEntity(
    id: 'doc_002',
    name: 'Dr. Fatima Zahra',
    specialization: 'clinicalPsychologist',
    experience: '10 years',
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Fatima',
    description: 'Focused on insomnia and stress-related cases.',
    isOnline: true,
    ratingValue: 4.9,
    createdAt: DateTime(2023, 2, 20),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorMohammad = DoctorEntity(
    id: 'doc_003',
    name: 'Dr. Mohammed Hassan',
    specialization: 'psychotherapist',
    experience: '15 years',
    rating: '4.7',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Mohammad',
    description: 'Marriage and family therapy specialist.',
    isOnline: false,
    ratingValue: 4.7,
    createdAt: DateTime(2023, 3, 10),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorSarah = DoctorEntity(
    id: 'doc_004',
    name: 'Dr. Leila Mansour',
    specialization: 'cbtTherapist',
    experience: '9 years',
    rating: '4.6',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Sarah',
    description: 'CBT specialist for anxiety and OCD.',
    isOnline: true,
    ratingValue: 4.6,
    createdAt: DateTime(2023, 4, 5),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorSaraAli = DoctorEntity(
    id: 'doc_005',
    name: 'Dr. Sarah Ali',
    specialization: 'counselor',
    experience: '7 years',
    rating: '4.5',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Sarah+Ali',
    description: 'Professional counselor for stress and personal growth.',
    isOnline: true,
    ratingValue: 4.5,
    createdAt: DateTime(2023, 5, 12),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorOmar = DoctorEntity(
    id: 'doc_006',
    name: 'Dr. Omar Taha',
    specialization: 'traumaTherapist',
    experience: '13 years',
    rating: '4.8',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Omar',
    description: 'Trauma specialist with EMDR approach.',
    isOnline: false,
    ratingValue: 4.8,
    createdAt: DateTime(2023, 6, 8),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorNoor = DoctorEntity(
    id: 'doc_007',
    name: 'Dr. Noor Khalil',
    specialization: 'marriageFamilyTherapist',
    experience: '11 years',
    rating: '4.7',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Noor',
    description: 'Family and couples communication specialist.',
    isOnline: true,
    ratingValue: 4.7,
    createdAt: DateTime(2023, 7, 20),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorKarim = DoctorEntity(
    id: 'doc_008',
    name: 'Dr. Karim Hassan',
    specialization: 'psychiatrist',
    experience: '14 years',
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Karim',
    description: 'Complex mental health and medication management.',
    isOnline: true,
    ratingValue: 4.9,
    createdAt: DateTime(2023, 8, 15),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  late final List<ArticleModel> _mockArticles = _buildMockArticles();

  List<ArticleModel> get _linkedArticles => _mockArticles
      .where(
        (article) =>
            article.doctor.id.trim().isNotEmpty &&
            article.doctor.name.trim().isNotEmpty,
      )
      .toList(growable: false);

  List<ArticleModel> _buildMockArticles() => [
    ArticleModel(
      id: 'art_001',
      title: 'Understanding Anxiety and Stress',
      content:
          'Anxiety is a natural emotion, but persistent anxiety can affect daily life. This article explains common triggers and practical management strategies. You will also learn the difference between expected stress and clinically significant anxiety.\n\nHelpful tools include controlled breathing, structured routines, and early support from a mental health professional when symptoms become frequent.',
      summary: 'Causes of anxiety and practical ways to manage it.',
      doctor: _doctorAhmed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      likesCount: 45,
      dislikesCount: 3,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'anxiety',
        'stress',
        'panic disorder',
        'mild',
        'moderate',
        'clinical psychologist',
      ],
    ),
    ArticleModel(
      id: 'art_002',
      title: 'Depression: Symptoms and Treatment Options',
      content:
          'Depression is more than sadness. It can include low mood, low energy, sleep disturbance, and loss of interest for weeks. Recognizing early signs improves outcomes.\n\nEvidence-based treatment includes psychotherapy, medication when indicated, and ongoing follow-up with a specialist.',
      summary: 'How to recognize depression and access effective treatment.',
      doctor: _doctorAhmed,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      likesCount: 67,
      dislikesCount: 2,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'depression',
        'major depression',
        'moderate',
        'moderately severe',
        'severe',
        'psychiatrist',
      ],
    ),
    ArticleModel(
      id: 'art_003',
      title: 'Better Sleep: Evidence-Based Habits',
      content:
          'Quality sleep supports emotional regulation and recovery. This article outlines habits that improve sleep depth and consistency.\n\nUse a fixed bedtime, reduce screen exposure before sleep, and avoid caffeine late in the day. Brief relaxation exercises can also improve sleep quality.',
      summary: 'Daily habits that measurably improve sleep quality.',
      doctor: _doctorFatima,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likesCount: 89,
      dislikesCount: 1,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'insomnia',
        'sleep disorder',
        'stress',
        'low',
        'mild',
        'counselor',
      ],
    ),
    ArticleModel(
      id: 'art_004',
      title: 'Child Mental Health: Early Signs and Support',
      content:
          'Children need emotional safety to grow well. Parents should monitor behavior, mood, and school changes without judgment.\n\nA supportive home environment, active listening, and early specialist referral can make a major difference in outcomes.',
      summary: 'How to identify and support child mental health needs.',
      doctor: _doctorMohammad,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      likesCount: 56,
      dislikesCount: 0,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'child anxiety',
        'child behavior',
        'family stress',
        'child psychologist',
      ],
    ),
    ArticleModel(
      id: 'art_005',
      title: 'Mindfulness and Guided Breathing',
      content:
          'Mindfulness improves emotional awareness and cognitive clarity. Practicing short guided sessions daily can reduce stress reactivity.\n\nStart with five minutes of breathing focus and body scanning. Consistency is more important than duration.',
      summary: 'Simple mindfulness techniques to reduce stress and rumination.',
      doctor: _doctorAhmed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likesCount: 72,
      dislikesCount: 2,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'stress',
        'anxiety',
        'mindfulness',
        'mild',
        'counselor',
        'psychotherapist',
      ],
    ),
    ArticleModel(
      id: 'art_006',
      title: 'Healthy Relationships and Self-Worth',
      content:
          'Stable relationships are built on boundaries, communication, and mutual respect. This article explores practical skills for healthier interactions.\n\nSelf-worth and emotional boundaries reduce burnout and improve relationship outcomes over time.',
      summary: 'Practical relationship skills and self-worth strategies.',
      doctor: _doctorSarah,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      likesCount: 78,
      dislikesCount: 1,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: [
        'relationships',
        'self esteem',
        'psychotherapist',
        'counselor',
        'low',
        'mild',
      ],
    ),
    ArticleModel(
      id: 'art_007',
      title: 'Grounding Techniques for Panic Moments',
      content:
          'Grounding skills are useful when panic symptoms peak. Sensory focus and paced breathing can reduce overwhelm.\n\nPractice 5-4-3-2-1 sensory grounding and slow exhale breathing for 3-5 minutes.',
      summary: 'Fast grounding methods for panic and overwhelm.',
      doctor: _doctorSaraAli,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      likesCount: 61,
      dislikesCount: 1,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['panic', 'anxiety', 'stress', 'counselor'],
    ),
    ArticleModel(
      id: 'art_008',
      title: 'Trauma Recovery: Building Daily Safety',
      content:
          'Recovery starts with safety routines, body regulation, and trusted support. Avoiding total isolation speeds recovery.\n\nSmall daily structure helps reduce flashback frequency and emotional exhaustion.',
      summary: 'Practical routines that support trauma recovery.',
      doctor: _doctorOmar,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      likesCount: 74,
      dislikesCount: 2,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['trauma', 'ptsd', 'stress', 'traumaTherapist'],
    ),
    ArticleModel(
      id: 'art_009',
      title: 'Couple Communication Without Escalation',
      content:
          'Healthy communication depends on pacing, listening, and non-accusatory language. Use short pauses to prevent escalation.\n\nReplace blame language with needs language and reflective listening.',
      summary: 'How couples can discuss conflict with less escalation.',
      doctor: _doctorNoor,
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      likesCount: 66,
      dislikesCount: 1,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['relationships', 'family stress', 'counselor'],
    ),
    ArticleModel(
      id: 'art_010',
      title: 'When Medication Follow-up Matters Most',
      content:
          'Medication plans require regular follow-up to optimize outcomes and reduce side effects.\n\nTrack sleep, mood, and daily function to help your psychiatrist adjust treatment safely.',
      summary: 'Why follow-up visits are key in psychiatric medication plans.',
      doctor: _doctorKarim,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 83,
      dislikesCount: 3,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['psychiatrist', 'depression', 'anxiety', 'severe'],
    ),
    ArticleModel(
      id: 'art_011',
      title: 'Managing Overthinking at Night',
      content:
          'Night overthinking is often linked to cognitive overload and unprocessed stress.\n\nUse thought journaling and a short shutdown routine before bed to calm mental loops.',
      summary: 'Tools to reduce nighttime overthinking and mental loops.',
      doctor: _doctorFatima,
      createdAt: DateTime.now().subtract(const Duration(days: 11)),
      likesCount: 71,
      dislikesCount: 2,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['stress', 'insomnia', 'anxiety', 'mild'],
    ),
    ArticleModel(
      id: 'art_012',
      title: 'Structured CBT Notes for Daily Triggers',
      content:
          'CBT thought logs help identify trigger-thought-emotion patterns and guide reframing.\n\nA daily 5-minute note can improve emotional regulation within weeks.',
      summary: 'Use CBT thought logs to manage daily emotional triggers.',
      doctor: _doctorSarah,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      likesCount: 69,
      dislikesCount: 1,
      isLikedByUser: false,
      isDislikedByUser: false,
      relatedConditions: ['cbtTherapist', 'anxiety', 'depression', 'moderate'],
    ),
  ];

  @override
  Future<List<ArticleModel>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final source = _linkedArticles;

    final normalizedDiagnosis = (userDiagnosis ?? '').trim().toLowerCase();
    if (normalizedDiagnosis.isNotEmpty) {
      final ranked = List<ArticleModel>.from(source)
        ..sort((a, b) {
          final aScore = _matchScore(a.relatedConditions, normalizedDiagnosis);
          final bScore = _matchScore(b.relatedConditions, normalizedDiagnosis);
          if (aScore != bScore) {
            return bScore.compareTo(aScore);
          }
          return b.likesCount.compareTo(a.likesCount);
        });

      final hasRelevant = ranked.any(
        (article) =>
            _matchScore(article.relatedConditions, normalizedDiagnosis) > 0,
      );
      if (hasRelevant) {
        return ranked.take(limit).toList();
      }
    }

    final sorted = List<ArticleModel>.from(source);
    sorted.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    return sorted.take(limit).toList();
  }

  int _matchScore(List<String> conditions, String diagnosis) {
    final diagnosisTokens = diagnosis
        .split(RegExp(r'[^a-z0-9]+'))
        .where((token) => token.isNotEmpty)
        .toSet();

    int score = 0;
    for (final condition in conditions) {
      final normalizedCondition = condition.toLowerCase();
      if (normalizedCondition == diagnosis) {
        score += 5;
        continue;
      }
      if (normalizedCondition.contains(diagnosis) ||
          diagnosis.contains(normalizedCondition)) {
        score += 3;
      }

      final conditionTokens = normalizedCondition
          .split(RegExp(r'[^a-z0-9]+'))
          .where((token) => token.isNotEmpty)
          .toSet();
      final overlap = diagnosisTokens.intersection(conditionTokens).length;
      score += overlap;
    }

    return score;
  }

  @override
  Future<List<ArticleModel>> getArticlesByDoctor(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _linkedArticles
        .where((article) => article.doctor.id == doctorId)
        .toList();
  }

  @override
  Future<List<ArticleModel>> getAllArticles({
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final source = _linkedArticles;

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= source.length) {
      return [];
    }

    return source.sublist(
      startIndex,
      endIndex > source.length ? source.length : endIndex,
    );
  }

  @override
  Future<ArticleModel> getArticleById(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final article = _linkedArticles.firstWhere(
      (article) => article.id == articleId,
    );
    return article;
  }

  @override
  Future<void> likeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> dislikeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> unlikeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> undislikeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

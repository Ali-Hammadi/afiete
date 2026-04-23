import 'package:afiete/feature/articles/data/models/article_model.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  });
  Future<List<ArticleModel>> getArticlesByDoctor(String doctorId);
  Future<List<ArticleModel>> getAllArticles({int page = 1, int pageSize = 10});
  Future<ArticleModel> getArticleById(String articleId);
  Future<void> likeArticle(String articleId);
  Future<void> dislikeArticle(String articleId);
}

class ArticlesMockDataSourceImpl implements ArticlesRemoteDataSource {
  final DoctorEntity _doctorAhmed = DoctorEntity(
    id: 'doc_001',
    name: 'Dr. Ahmed Mohsen',
    specialization: 'Psychiatrist',
    experience: '8+ years',
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Ahmed',
    description: 'Specialized in depression and anxiety management.',
    isOnline: true,
    ratingValue: 4.9,
    createdAt: DateTime(2022, 1, 1),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorFatima = DoctorEntity(
    id: 'doc_002',
    name: 'Dr. Fatima Ali',
    specialization: 'Clinical Psychologist',
    experience: '6+ years',
    rating: '4.8',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Fatima',
    description: 'Focused on insomnia and stress-related cases.',
    isOnline: true,
    ratingValue: 4.8,
    createdAt: DateTime(2023, 1, 1),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorMohammad = DoctorEntity(
    id: 'doc_003',
    name: 'Dr. Mohammad Khaled',
    specialization: 'Child Psychologist',
    experience: '7+ years',
    rating: '4.7',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Mohammad',
    description: 'Child and adolescent mental health specialist.',
    isOnline: false,
    ratingValue: 4.7,
    createdAt: DateTime(2021, 1, 1),
    availableTimes: const [],
    consultationFee: const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  );

  final DoctorEntity _doctorSarah = DoctorEntity(
    id: 'doc_004',
    name: 'Dr. Sarah Hassan',
    specialization: 'Psychotherapist',
    experience: '9+ years',
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Sarah',
    description: 'Relationship and self-esteem therapist.',
    isOnline: true,
    ratingValue: 4.9,
    createdAt: DateTime(2020, 1, 1),
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
}

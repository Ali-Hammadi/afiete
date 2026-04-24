import 'dart:math';

import 'package:afiete/feature/articles/data/models/article_model.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/core/constants/settings_strings.dart';

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
  static String _localized(String en, String ar) =>
      SettingsStrings.isArabic ? ar : en;

  static final Map<String, bool> _likedState = {};
  static final Map<String, bool> _dislikedState = {};
  static final Map<String, int> _likesCountState = {};
  static final Map<String, int> _dislikesCountState = {};

  DoctorEntity get _doctorAhmed => DoctorEntity(
    id: 'doc_001',
    name: _localized('Dr. Ahmed Mohsen', 'د. أحمد محسن'),
    specialization: 'Psychiatrist',
    experience: SettingsStrings.experienceYearsLabel('8+ years'),
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Ahmed',
    description: _localized(
      'Specialized in depression and anxiety management.',
      'متخصص في إدارة الاكتئاب والقلق.',
    ),
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

  DoctorEntity get _doctorFatima => DoctorEntity(
    id: 'doc_002',
    name: _localized('Dr. Fatima Ali', 'د. فاطمة علي'),
    specialization: 'Clinical Psychologist',
    experience: SettingsStrings.experienceYearsLabel('6+ years'),
    rating: '4.8',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Fatima',
    description: _localized(
      'Focused on insomnia and stress-related cases.',
      'تركز على حالات الأرق والمشكلات المرتبطة بالتوتر.',
    ),
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

  DoctorEntity get _doctorMohammad => DoctorEntity(
    id: 'doc_003',
    name: _localized('Dr. Mohammad Khaled', 'د. محمد خالد'),
    specialization: 'Child Psychologist',
    experience: SettingsStrings.experienceYearsLabel('7+ years'),
    rating: '4.7',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Mohammad',
    description: _localized(
      'Child and adolescent mental health specialist.',
      'متخصص في الصحة النفسية للأطفال والمراهقين.',
    ),
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

  DoctorEntity get _doctorSarah => DoctorEntity(
    id: 'doc_004',
    name: _localized('Dr. Sarah Hassan', 'د. سارة حسن'),
    specialization: 'Psychotherapist',
    experience: SettingsStrings.experienceYearsLabel('9+ years'),
    rating: '4.9',
    imageUrl: 'https://via.placeholder.com/150?text=Dr+Sarah',
    description: _localized(
      'Relationship and self-esteem therapist.',
      'معالجة نفسية متخصصة في العلاقات وتقدير الذات.',
    ),
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

  List<ArticleModel> get _articlesStore =>
      _applyInteractionState(_buildMockArticles());

  List<ArticleModel> _applyInteractionState(List<ArticleModel> articles) {
    return articles
        .map((article) {
          final liked = _likedState[article.id] ?? article.isLikedByUser;
          final disliked =
              _dislikedState[article.id] ?? article.isDislikedByUser;
          final likesCount = _likesCountState[article.id] ?? article.likesCount;
          final dislikesCount =
              _dislikesCountState[article.id] ?? article.dislikesCount;
          return article.copyWith(
            isLikedByUser: liked,
            isDislikedByUser: disliked,
            likesCount: likesCount,
            dislikesCount: dislikesCount,
          );
        })
        .toList(growable: false);
  }

  List<ArticleModel> get _mockArticles => _articlesStore;

  List<ArticleModel> get _linkedArticles => _mockArticles
      .where(
        (article) =>
            article.doctor.id.trim().isNotEmpty &&
            article.doctor.name.trim().isNotEmpty,
      )
      .toList(growable: false);

  List<ArticleModel> _sortedByLikes(List<ArticleModel> articles) {
    final sorted = List<ArticleModel>.from(articles);
    sorted.sort((a, b) {
      final likesComparison = b.likesCount.compareTo(a.likesCount);
      if (likesComparison != 0) {
        return likesComparison;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return sorted;
  }

  int _articleIndex(String articleId) =>
      _articlesStore.indexWhere((article) => article.id == articleId);

  List<ArticleModel> _buildMockArticles() => [
    ArticleModel(
      id: 'art_001',
      title: _localized(
        'Understanding Anxiety and Stress',
        'فهم القلق والتوتر',
      ),
      content: _localized(
        'Anxiety is a natural emotion, but persistent anxiety can affect daily life. This article explains common triggers and practical management strategies. You will also learn the difference between expected stress and clinically significant anxiety.\n\nHelpful tools include controlled breathing, structured routines, and early support from a mental health professional when symptoms become frequent.',
        'القلق شعور طبيعي، لكن استمرار القلق قد يؤثر في الحياة اليومية. تشرح هذه المقالة المحفزات الشائعة وأساليب التعامل العملية. كما ستتعرف على الفرق بين التوتر المتوقع والقلق السريري المؤثر.\n\nمن الأدوات المفيدة: التنفس المنظم، والروتين الواضح، وطلب الدعم المبكر من مختص نفسي عند تكرار الأعراض.',
      ),
      summary: _localized(
        'Causes of anxiety and practical ways to manage it.',
        'أسباب القلق وطرق عملية للتعامل معه.',
      ),
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
      title: _localized(
        'Depression: Symptoms and Treatment Options',
        'الاكتئاب: الأعراض وخيارات العلاج',
      ),
      content: _localized(
        'Depression is more than sadness. It can include low mood, low energy, sleep disturbance, and loss of interest for weeks. Recognizing early signs improves outcomes.\n\nEvidence-based treatment includes psychotherapy, medication when indicated, and ongoing follow-up with a specialist.',
        'الاكتئاب أكثر من مجرد حزن. قد يشمل انخفاض المزاج والطاقة واضطراب النوم وفقدان الاهتمام لأسابيع. التعرف المبكر على العلامات يحسن النتائج.\n\nالعلاج القائم على الأدلة يشمل العلاج النفسي، والأدوية عند الحاجة، والمتابعة المستمرة مع مختص.',
      ),
      summary: _localized(
        'How to recognize depression and access effective treatment.',
        'كيف تتعرف على الاكتئاب وتصل إلى علاج فعال.',
      ),
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
      title: _localized(
        'Better Sleep: Evidence-Based Habits',
        'نوم أفضل: عادات مبنية على الأدلة',
      ),
      content: _localized(
        'Quality sleep supports emotional regulation and recovery. This article outlines habits that improve sleep depth and consistency.\n\nUse a fixed bedtime, reduce screen exposure before sleep, and avoid caffeine late in the day. Brief relaxation exercises can also improve sleep quality.',
        'النوم الجيد يدعم تنظيم المشاعر والتعافي. توضح هذه المقالة عادات تحسن عمق النوم وانتظامه.\n\nحاول تثبيت وقت النوم، وتقليل التعرض للشاشات قبل النوم، وتجنب الكافيين في وقت متأخر. كما يمكن لتمارين الاسترخاء القصيرة تحسين جودة النوم.',
      ),
      summary: _localized(
        'Daily habits that measurably improve sleep quality.',
        'عادات يومية تحسن جودة النوم بشكل ملحوظ.',
      ),
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
      title: _localized(
        'Child Mental Health: Early Signs and Support',
        'صحة الطفل النفسية: العلامات المبكرة والدعم',
      ),
      content: _localized(
        'Children need emotional safety to grow well. Parents should monitor behavior, mood, and school changes without judgment.\n\nA supportive home environment, active listening, and early specialist referral can make a major difference in outcomes.',
        'يحتاج الأطفال إلى الأمان العاطفي لينموا بشكل سليم. على الوالدين متابعة السلوك والمزاج والتغيرات المدرسية دون أحكام مسبقة.\n\nالبيئة المنزلية الداعمة، والاستماع الفعّال، والإحالة المبكرة للمختص يمكن أن تحدث فرقًا كبيرًا.',
      ),
      summary: _localized(
        'How to identify and support child mental health needs.',
        'كيف تتعرف على احتياجات الطفل النفسية وتدعمه.',
      ),
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
      title: _localized(
        'Mindfulness and Guided Breathing',
        'اليقظة الذهنية والتنفس الموجه',
      ),
      content: _localized(
        'Mindfulness improves emotional awareness and cognitive clarity. Practicing short guided sessions daily can reduce stress reactivity.\n\nStart with five minutes of breathing focus and body scanning. Consistency is more important than duration.',
        'تساعد اليقظة الذهنية على زيادة الوعي بالمشاعر والصفاء الذهني. يمكن لجلسات قصيرة يومية أن تقلل من استجابة التوتر.\n\nابدأ بخمس دقائق من التركيز على التنفس وفحص الجسم. الاستمرارية أهم من طول المدة.',
      ),
      summary: _localized(
        'Simple mindfulness techniques to reduce stress and rumination.',
        'تقنيات بسيطة لليقظة الذهنية لتقليل التوتر والاجترار.',
      ),
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
      title: _localized(
        'Healthy Relationships and Self-Worth',
        'العلاقات الصحية وتقدير الذات',
      ),
      content: _localized(
        'Stable relationships are built on boundaries, communication, and mutual respect. This article explores practical skills for healthier interactions.\n\nSelf-worth and emotional boundaries reduce burnout and improve relationship outcomes over time.',
        'تبنى العلاقات المستقرة على الحدود الواضحة والتواصل والاحترام المتبادل. تستعرض هذه المقالة مهارات عملية لعلاقات أكثر صحة.\n\nتقدير الذات والحدود العاطفية يقللان الإرهاق ويحسنان نتائج العلاقات بمرور الوقت.',
      ),
      summary: _localized(
        'Practical relationship skills and self-worth strategies.',
        'مهارات عملية للعلاقات واستراتيجيات لتقدير الذات.',
      ),
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

    final source = _sortedByLikes(_linkedArticles);

    final normalizedDiagnosis = (userDiagnosis ?? '').trim().toLowerCase();
    if (normalizedDiagnosis.isNotEmpty) {
      final ranked = List<ArticleModel>.from(source)
        ..sort((a, b) {
          final aScore = _matchScore(a.relatedConditions, normalizedDiagnosis);
          final bScore = _matchScore(b.relatedConditions, normalizedDiagnosis);
          if (aScore != bScore) {
            return bScore.compareTo(aScore);
          }
          final likesComparison = b.likesCount.compareTo(a.likesCount);
          if (likesComparison != 0) {
            return likesComparison;
          }
          return b.createdAt.compareTo(a.createdAt);
        });

      final hasRelevant = ranked.any(
        (article) =>
            _matchScore(article.relatedConditions, normalizedDiagnosis) > 0,
      );
      if (hasRelevant) {
        return ranked.take(limit).toList();
      }
    }

    return source.take(limit).toList();
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

    return _sortedByLikes(
      _linkedArticles,
    ).where((article) => article.doctor.id == doctorId).toList();
  }

  @override
  Future<List<ArticleModel>> getAllArticles({
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final source = _sortedByLikes(_linkedArticles);

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

    final article = _articlesStore.firstWhere(
      (article) => article.id == articleId,
    );
    return article;
  }

  @override
  Future<void> likeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _articleIndex(articleId);
    if (index == -1) {
      return;
    }

    final article = _articlesStore[index];
    final isCurrentlyLiked = article.isLikedByUser;
    _likedState[articleId] = !isCurrentlyLiked;
    if (!isCurrentlyLiked) {
      _dislikedState[articleId] = false;
      _likesCountState[articleId] = article.likesCount + 1;
      _dislikesCountState[articleId] = article.isDislikedByUser
          ? max(0, article.dislikesCount - 1)
          : article.dislikesCount;
    } else {
      _likesCountState[articleId] = max(0, article.likesCount - 1);
    }
  }

  @override
  Future<void> dislikeArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _articleIndex(articleId);
    if (index == -1) {
      return;
    }

    final article = _articlesStore[index];
    final isCurrentlyDisliked = article.isDislikedByUser;
    _dislikedState[articleId] = !isCurrentlyDisliked;
    if (!isCurrentlyDisliked) {
      _likedState[articleId] = false;
      _dislikesCountState[articleId] = article.dislikesCount + 1;
      _likesCountState[articleId] = article.isLikedByUser
          ? max(0, article.likesCount - 1)
          : article.likesCount;
    } else {
      _dislikesCountState[articleId] = max(0, article.dislikesCount - 1);
    }
  }
}

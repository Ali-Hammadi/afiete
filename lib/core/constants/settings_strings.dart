abstract class SettingsStrings {
  static String _languageCode = 'en';

  static void setLanguageCode(String code) {
    _languageCode = code.toLowerCase() == 'ar' ? 'ar' : 'en';
  }

  static String _t(String en, String ar) => _languageCode == 'ar' ? ar : en;
  static bool get isArabic => _languageCode == 'ar';

  static String get settingsTitle => _t('Settings', 'الإعدادات');
  static String get medicalProfileTitle => _t('Medical Profile', 'الملف الطبي');
  static String get medicalProfileSubtitle =>
      _t('Prescriptions | Medicine | Notes', 'الوصفات | الأدوية | الملاحظات');
  static String get languageTitle => _t('Language', 'اللغة');
  static String get currentLanguageTitle =>
      _t('Current language', 'اللغة الحالية');
  static String get supportTitle => _t('Support', 'الدعم');
  static String get supportSubtitle => _t('24/7 Support', 'دعم 24/7');
  static String get supportComingSoon =>
      _t('Support center is coming soon.', 'مركز الدعم قريبا.');
  static String get themeTitle => _t('Theme', 'المظهر');
  static String get termsPrivacyTitle =>
      _t('Terms & Privacy', 'الشروط والخصوصية');
  static String get contactUsTitle => _t('Contact us', 'تواصل معنا');
  static String get reportsTitle => _t('Reports', 'التقارير');
  static String get homeNavLabel => _t('Home', 'الرئيسية');
  static String get doctorsNavLabel => _t('Doctors', 'الأطباء');
  static String get appointmentsNavLabel => _t('Appointments', 'المواعيد');
  static String get profileNavLabel => _t('Profile', 'الملف الشخصي');
  static String get homeTitle => _t('Home', 'الرئيسية');
  static String get appointmentsTitle => _t('Appointments', 'المواعيد');
  static String get noDoctorsAvailable =>
      _t('No doctors available.', 'لا يوجد أطباء متاحون.');
  static String get searchExpertsHint =>
      _t('Search experts or specialist', 'ابحث عن خبير أو متخصص');
  static String get noDoctorsMatchSearch =>
      _t('No doctors match your search.', 'لا يوجد أطباء يطابقون بحثك.');
  static String get noDoctorsFound =>
      _t('No doctors found.', 'لم يتم العثور على أطباء.');
  static String get mySessionsTitle => _t('My Sessions', 'جلساتي');
  static String get upcoming => _t('Upcoming', 'القادمة');
  static String get past => _t('Past', 'السابقة');
  static String get noUpcomingSessions =>
      _t('No upcoming sessions', 'لا توجد جلسات قادمة');
  static String get noPastSessions =>
      _t('No past sessions', 'لا توجد جلسات سابقة');
  static String get bookingFeatureComingSoon =>
      _t('Booking feature coming soon', 'ميزة الحجز قريبا');
  static String get rescheduleFeatureComingSoon =>
      _t('Reschedule feature coming soon', 'ميزة إعادة الجدولة قريبا');
  static String get sessionRescheduledSuccessfully =>
      _t('Session rescheduled successfully', 'تمت إعادة جدولة الجلسة بنجاح');
  static String get sessionCancelled =>
      _t('Session cancelled', 'تم إلغاء الجلسة');
  static String get cancelSessionTitle => _t('Cancel Session', 'إلغاء الجلسة');
  static String get cancelSessionQuestion => _t(
    'Are you sure you want to cancel this session?',
    'هل أنت متأكد أنك تريد إلغاء هذه الجلسة؟',
  );
  static String get no => _t('No', 'لا');
  static String get yesCancel => _t('Yes, Cancel', 'نعم، إلغاء');
  static String get addReview => _t('Add Review', 'إضافة تقييم');
  static String get bookAgain => _t('Book Again', 'احجز مرة أخرى');
  static String get reschedule => _t('Reschedule', 'إعادة الجدولة');
  static String get joinSession => _t('Join Session', 'انضم إلى الجلسة');
  static String get cancelAction => _t('Cancel', 'إلغاء');
  static String get writeComment => _t('Write comment', 'اكتب تعليقًا');
  static String get writeCommentHint =>
      _t('write your comment here', 'اكتب تعليقك هنا');
  static String get submit => _t('Submit', 'إرسال');
  static String get sessionLabel => _t('Session', 'الجلسة');
  static String get specialistLabel => _t('Specialist', 'المتخصص');
  static String get dateLabel => _t('Date', 'التاريخ');
  static String get totalAmountLabel => _t('Total Amount', 'المبلغ الإجمالي');
  static String get paymentTitle => _t('Payment', 'الدفع');
  static String get paymentMethodTitle => _t('Payment Method', 'طريقة الدفع');
  static String get creditDebitCard =>
      _t('Credit / Debit Card', 'بطاقة ائتمان / خصم');
  static String get applePay => _t('Apple Pay', 'أبل باي');
  static String get cardInformationTitle =>
      _t('Card Information', 'معلومات البطاقة');
  static String get expiryDateLabel => _t('Expiry Date', 'تاريخ الانتهاء');
  static String get cvvLabel => _t('CVV', 'CVV');
  static String get cardholderNameLabel =>
      _t('Cardholder Name', 'اسم حامل البطاقة');
  static String get nameOnCardHint => _t('Name on card', 'الاسم على البطاقة');
  static String payAmount(String amount) =>
      _t('Pay $amount \$', 'ادفع $amount \$');
  static String paymentSuccessfulWith(String reference) =>
      _t('Payment successful: $reference', 'تم الدفع بنجاح: $reference');
  static String get reportDoctorTitle =>
      _t('Report Doctor', 'الإبلاغ عن الطبيب');
  static String get reportSessionTitle =>
      _t('Report Session', 'الإبلاغ عن الجلسة');
  static String get reportIssueTitle => _t('Report Issue', 'الإبلاغ عن مشكلة');
  static String get reportDoctorDescription => _t(
    'Help us maintain a safe environment by reporting any inappropriate behavior from your doctor.',
    'ساعدنا في الحفاظ على بيئة آمنة بالإبلاغ عن أي سلوك غير مناسب من الطبيب.',
  );
  static String get reportSessionDescription => _t(
    'Report any issues you experienced during your session.',
    'أبلغ عن أي مشاكل واجهتها أثناء الجلسة.',
  );
  static String get reportIssueDescription => _t(
    'Let us know about any technical issues or problems with the app.',
    'أخبرنا عن أي مشاكل تقنية أو أعطال في التطبيق.',
  );
  static String get pleaseSelectReasonAndProvideDetails => _t(
    'Please select a reason and provide details',
    'يرجى اختيار سبب وتقديم التفاصيل',
  );
  static String get reportSubmittedSuccessfully =>
      _t('Report submitted successfully', 'تم إرسال البلاغ بنجاح');
  static String get reportIssueConfidentialMessage => _t(
    'Your report is confidential and helps us maintain a safe environment.',
    'بلاغك سري ويساعدنا في الحفاظ على بيئة آمنة.',
  );
  static String get reportConfidentialTitle =>
      _t('Your Report is Confidential', 'بلاغك سري');
  static String get selectReason => _t('Select Reason', 'اختر السبب');
  static String get additionalDetails =>
      _t('Additional Details', 'تفاصيل إضافية');
  static String get reportDescriptionHint => _t(
    'Please provide more information about your report. Be as specific as possible.',
    'يرجى تقديم المزيد من المعلومات حول البلاغ. كن محددًا قدر الإمكان.',
  );
  static String get submitReport => _t('Submit Report', 'إرسال البلاغ');
  static String get submitting => _t('Submitting...', 'جارٍ الإرسال...');
  static String get reportWillBeReviewed => _t(
    'Your report will be reviewed by our team. We will take appropriate action.',
    'سيتم مراجعة بلاغك من قبل فريقنا. سنتخذ الإجراء المناسب.',
  );
  static String get reportHistoryTitle => _t('Report History', 'سجل التقارير');
  static String get noReportsYet => _t('No Reports Yet', 'لا توجد تقارير بعد');
  static String get yourSubmittedReportsWillAppearHere => _t(
    'Your submitted reports will appear here',
    'ستظهر التقارير التي أرسلتها هنا',
  );
  static String get errorLoadingReports =>
      _t('Error Loading Reports', 'خطأ في تحميل التقارير');
  static String get noReportsFound => _t('No reports found', 'لا توجد تقارير');
  static String get allFilter => _t('All', 'الكل');
  static String get doctorFilter => _t('Doctor', 'الطبيب');
  static String get appFilter => _t('App', 'التطبيق');
  static String get reportDetailsTitle => _t('Report Details', 'تفاصيل البلاغ');
  static String get descriptionLabel => _t('Description', 'الوصف');
  static String get submittedLabel => _t('Submitted', 'تم الإرسال');
  static String get resolvedLabel => _t('Resolved', 'تم الحل');
  static String get pendingStatus => _t('Pending', 'قيد المراجعة');
  static String get underReviewStatus => _t('Under Review', 'قيد المراجعة');
  static String get resolvedStatus => _t('Resolved', 'تم الحل');
  static String get doctorReportType => _t('Doctor Report', 'بلاغ طبيب');
  static String get sessionReportType => _t('Session Report', 'بلاغ جلسة');
  static String get appReportType => _t('App Report', 'بلاغ التطبيق');
  static String get reasonLabel => _t('Reason:', 'السبب:');
  static String get unprofessionalBehavior =>
      _t('Unprofessional behavior', 'سلوك غير مهني');
  static String get harassment => _t('Harassment', 'تحرش');
  static String get inappropriateContent =>
      _t('Inappropriate content', 'محتوى غير مناسب');
  static String get missingAppointments =>
      _t('Missing appointments', 'تفويت المواعيد');
  static String get appBugOrIssue =>
      _t('App bug or issue', 'خلل أو مشكلة في التطبيق');
  static String get appCrashesOrFreezes =>
      _t('App crashes or freezes', 'يتعطل التطبيق أو يتجمد');
  static String get paymentOrTransactionIssue =>
      _t('Payment or transaction issue', 'مشكلة في الدفع أو المعاملة');
  static String get otherIssue => _t('Other issue', 'مشكلة أخرى');
  static String get missingUserInformation =>
      _t('Missing user information.', 'معلومات المستخدم مفقودة.');
  static String get doctorDefaultName => _t('Dr. John Doe', 'د. جون دو');
  static String get doctorSpecialist => _t('Specialist', 'متخصص');
  static String get doctorAboutTitle => _t('About Doctor', 'عن الطبيب');
  static String get doctorPriceContactTitle =>
      _t('Price Contact Doctor details', 'تفاصيل الأسعار والتواصل مع الطبيب');
  static String get chatTitle => _t('Chat', 'الدردشة');
  static String get textChatTitle => _t('Text Chat', 'دردشة نصية');
  static String get videoCallTitle => _t('Video Call', 'مكالمة فيديو');
  static String get voiceCallTitle => _t('Voice Call', 'مكالمة صوتية');
  static String get viewDetails => _t('View details', 'عرض التفاصيل');
  static String get consultationLabel => _t('Consultation', 'التقييمات');
  static String get onlineLabel => _t('Online', 'متصل');
  static String get availableLabel => _t('Available', 'متاح');
  static String get offlineLabel => _t('Offline', 'غير متصل');
  static String get bookSessionNow =>
      _t('Book a session now', 'احجز جلسة الآن');
  static String get reportDoctorButton =>
      _t('Report Doctor', 'الإبلاغ عن الطبيب');
  static String get cardiology => _t('Cardiology', 'أمراض القلب');
  static String get cbt => _t('CBT', 'العلاج المعرفي السلوكي');
  static String get depression => _t('Depression', 'الاكتئاب');
  static String get doctorProfileUnavailable => _t(
    'Doctor profile details are not available right now.',
    'تفاصيل ملف الطبيب غير متاحة حاليًا.',
  );
  static String get reviewsLabel => _t('Reviews', 'التقييمات');
  static String get experienceLabel => _t('Experience', 'الخبرة');
  static String get patientsLabel => _t('Patients', 'المرضى');
  static String get pleaseSignInToReportDoctor => _t(
    'Please sign in to report a doctor.',
    'يرجى تسجيل الدخول للإبلاغ عن الطبيب.',
  );
  static String get doctorDataNotLoadedYet =>
      _t('Doctor data not loaded yet.', 'لم يتم تحميل بيانات الطبيب بعد.');
  static String get pleaseSignInToReportADoctor => _t(
    'Please sign in to report a doctor.',
    'يرجى تسجيل الدخول للإبلاغ عن طبيب.',
  );
  static String get topDoctorsTitle => _t('Top Doctors', 'أفضل الأطباء');
  static String get howAreYouFeelingToday =>
      _t('How are you feeling today?', 'كيف تشعر اليوم؟');
  static String get takeAssignmentTitle =>
      _t('Not sure where to start?', 'لست متأكدًا من أين تبدأ؟');
  static String get takeAssignmentDescription => _t(
    'Take a short mental health assignment so we can understand your state and suggest the best doctors for you',
    'أكمل تقييمًا قصيرًا للصحة النفسية حتى نفهم حالتك ونقترح أفضل الأطباء لك',
  );
  static String get takeAssignmentButton =>
      _t('Take an assignment', 'ابدأ التقييم');
  static String get todayLabel => _t('Today', 'اليوم');
  static String get viewProfile => _t('View Profile', 'عرض الملف الشخصي');
  static String get typeMessageHint => _t('Type a message...', 'اكتب رسالة...');
  static String get bestArticlesForYou =>
      _t('Best articles for you', 'أفضل المقالات لك');
  static String get articleAnxietyAndStressTitle =>
      _t('Understanding Anxiety and Stress', 'فهم القلق والتوتر');
  static String get articleDepressionTitle => _t(
    'Depression: Symptoms and Treatment Options',
    'الاكتئاب: الأعراض وخيارات العلاج',
  );
  static String get articleBetterSleepTitle => _t(
    'Better Sleep: Evidence-Based Habits',
    'نوم أفضل: عادات مبنية على الأدلة',
  );
  static String get articleChildMentalHealthTitle => _t(
    'Child Mental Health: Early Signs and Support',
    'صحة الطفل النفسية: العلامات المبكرة والدعم',
  );
  static String get articleMindfulnessTitle =>
      _t('Mindfulness and Guided Breathing', 'اليقظة الذهنية والتنفس الموجه');
  static String get articleHealthyRelationshipsTitle => _t(
    'Healthy Relationships and Self-Worth',
    'العلاقات الصحية وتقدير الذات',
  );
  static String get articlesLabel => _t('Articles', 'المقالات');
  static String get readMore => _t('Read more', 'اقرأ المزيد');
  static String get readLess => _t('Read less', 'اقرأ أقل');
  static String likesLabel(int count) => _t('$count Likes', '$count إعجاب');
  static String dislikesLabel(int count) =>
      _t('$count Dislikes', '$count عدم إعجاب');
  static String get yearsLabel => _t('Years', 'سنوات');
  static String experienceYearsLabel(String experience) => _t(
    experience,
    experience.replaceAll('years', 'سنوات').replaceAll('year', 'سنة'),
  );
  static String get medicalSpecialtiesLabel =>
      _t('Medical Specialties', 'التخصصات الطبية');
  static String get noArticlesAvailableForThisDoctorYet => _t(
    'No articles available for this doctor yet.',
    'لا توجد مقالات متاحة لهذا الطبيب بعد.',
  );
  static String specialtyLabel(String specialty) {
    final normalized = specialty.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '',
    );
    switch (normalized) {
      case 'psychiatrist':
        return _t('Psychiatrist', 'طبيب نفسي');
      case 'clinicalpsychologist':
      case 'clinclepsychologist':
      case 'clinclepsycologist':
        return _t('Clinical Psychologist', 'أخصائي نفسي إكلينيكي');
      case 'psychotherapist':
        return _t('Psychotherapist', 'معالج نفسي');
      case 'cbttherapist':
        return _t('CBT Therapist', 'معالج معرفي سلوكي');
      case 'psychoanalyst':
        return _t('Psychoanalyst', 'محلل نفسي');
      case 'traumatherapist':
        return _t('Trauma Therapist', 'معالج صدمات');
      case 'trumatherapist':
        return _t('Trauma Therapist', 'معالج صدمات');
      case 'marriageandfamilytherapist':
        return _t('Marriage and Family Therapist', 'معالج أسري وزواجي');
      case 'marriage':
        return _t('Marriage and Family Therapist', 'معالج أسري وزواجي');
      case 'counselor':
        return _t('Counselor', 'مرشد نفسي');
      case 'psychiatricsocialworker':
      case 'psychiarticsocialworker':
      case 'psychiarticsocial':
        return _t('Psychiatric Social Worker', 'أخصائي اجتماعي نفسي');
      case 'childpsychologist':
      case 'child':
        return _t('Child Psychologist', 'أخصائي نفسي للأطفال');
      case 'speechlanguagepathologist':
      case 'speechlanguage':
        return _t('Speech-Language Pathologist', 'أخصائي علاج النطق');
      case 'all':
        return _t('All', 'الكل');
      default:
        return specialty;
    }
  }

  static String get articlesByDoctorTitle =>
      _t('Articles by doctor', 'مقالات الطبيب');
  static String get allArticlesTitle => _t('All Articles', 'كل المقالات');
  static String get noArticlesAvailable =>
      _t('No articles available', 'لا توجد مقالات متاحة');
  static String get seeAll => _t('See All', 'عرض الكل');
  static String get assessmentResultTitle =>
      _t('Assessment Result', 'نتيجة التقييم');
  static String get suggestedSpecialistTitle =>
      _t('Suggested specialist', 'المتخصص المقترح');
  static String get noSuggestedSpecialistsFoundYet => _t(
    'No suggested specialists found yet.',
    'لم يتم العثور على متخصصين مقترحين بعد.',
  );
  static String get homeLabel => _t('Home', 'الرئيسية');
  static String get specialistsLabel => _t('Specialists', 'المتخصصون');
  static String get retakeAssessment =>
      _t('Retake Assessment', 'إعادة التقييم');
  static String get bookYourSessionTitle =>
      _t('Book Your Session', 'احجز جلستك');
  static String get chooseDayTitle => _t('Choose day', 'اختر اليوم');
  static String get chooseTimeTitle => _t('Choose time', 'اختر الوقت');
  static String get chooseSessionDurationTitle =>
      _t('Choose session duration', 'اختر مدة الجلسة');
  static String get chooseSessionTypeTitle =>
      _t('Choose session type', 'اختر نوع الجلسة');
  static String get minuteAbbreviation => _t('min', 'د');
  static String get continueToPayment =>
      _t('Continue to payment', 'المتابعة إلى الدفع');
  static String get continueTextShort => _t('Continue', 'متابعة');
  static String get bookingDraftCreatedSuccessfully =>
      _t('Booking draft created successfully.', 'تم إنشاء مسودة الحجز بنجاح.');
  static String get availableFromDatabase =>
      _t('Available from database', 'متاح من قاعدة البيانات');
  static String get sessionAvailableLabel => _t('Available', 'متاح');
  static String bookingFeePerSession(double amount) => _t(
    '\$${amount.toStringAsFixed(2)} per session',
    '\$${amount.toStringAsFixed(2)} لكل جلسة',
  );
  static String get noAvailableTimesForThisDate => _t(
    'No available times for this date.',
    'لا توجد أوقات متاحة لهذا التاريخ.',
  );
  static String get noAvailableScheduleLoadedYet => _t(
    'This doctor has no available schedule loaded from the database yet.',
    'لم يتم تحميل أي جدول متاح لهذا الطبيب من قاعدة البيانات بعد.',
  );
  static String get definedByProviderAvailability =>
      _t('Defined by provider availability', 'يتم تحديده حسب توفر المزود');
  static String minutesLabel(int minutes) =>
      _t('$minutes ${minuteAbbreviation}', '$minutes ${minuteAbbreviation}');
  static String get noInternetConnectionPleaseReconnectAndTryAgain => _t(
    'No internet connection. Please reconnect and try again.',
    'لا يوجد اتصال بالإنترنت. يرجى إعادة الاتصال والمحاولة مرة أخرى.',
  );
  static String get retry => _t('Retry', 'إعادة المحاولة');
  static String get noUpcomingAppointments =>
      _t('No upcoming appointments.', 'لا توجد مواعيد قادمة.');
  static String get noPastAppointments =>
      _t('No past appointments.', 'لا توجد مواعيد سابقة.');
  static String get specialistLabelInAppointment => _t('Specialist', 'المتخصص');
  static String durationMinutesLabel(int minutes) => _t(
    'Duration: $minutes ${minuteAbbreviation}',
    'المدة: $minutes ${minuteAbbreviation}',
  );
  static String get selectLanguageTitle => _t('Select language', 'اختر اللغة');
  static String get cancel => _t('Cancel', 'إلغاء');
  static String get select => _t('Select', 'اختيار');
  static String get english => _t('English', 'الإنجليزية');
  static String get arabic => _t('Arabic', 'العربية');

  static String get medicalTabPrescriptions => _t('Prescriptions', 'الوصفات');
  static String get medicalTabMedicine => _t('Medicine', 'الأدوية');
  static String get medicalTabNotes => _t('Notes', 'الملاحظات');
  static String get noPrescriptions =>
      _t('No prescriptions yet.', 'لا توجد وصفات بعد.');
  static String get noPrescriptionImage =>
      _t('No prescription image available.', 'لا توجد صورة وصفة متاحة.');
  static String get noMedicines =>
      _t('No medicine records yet.', 'لا توجد سجلات أدوية بعد.');
  static String get noNotes => _t('No notes yet.', 'لا توجد ملاحظات بعد.');
  static String get therapyProgressTitle =>
      _t('Therapy Progress', 'تقدم العلاج');
  static String get lifestyleRecommendationTitle =>
      _t('Lifestyle Recommendation', 'توصية نمط الحياة');
  static String get followUpPlanTitle => _t('Follow-up Plan', 'خطة المتابعة');
  static String get sleepHygieneTitle => _t('Sleep Hygiene', 'نظافة النوم');
  static String get oral => _t('ORAL', 'فموي');
  static String get prescriptionNumberLabel =>
      _t('Prescription No:', 'رقم الوصفة:');
  static String get prescriptionNameLabel =>
      _t('Prescription Name:', 'اسم الوصفة:');
  static String get dosageLabel => _t('Dosage:', 'الجرعة:');
  static String get scheduleLabel => _t('Schedule:', 'الجدول:');
  static String get refillLabel => _t('Refill:', 'إعادة التعبئة:');
  static String get nextRefillLabel =>
      _t('Next refill:', 'إعادة التعبئة القادمة:');
  static String get doctorLabel => _t('Doctor:', 'الطبيب:');
  static String get capturedAtLabel => _t('Captured:', 'تاريخ الالتقاط:');
  static String get viewDocument => _t('View Image', 'عرض الصورة');
  static String get downloadDocument => _t('Download Image', 'تنزيل الصورة');
  static String get shareWithPharmacist => _t('Share Image', 'مشاركة الصورة');
  static String get prescriptionDocument => _t('Prescription', 'وصفة');
  static String get sessionReportDocument => _t('Session Report', 'تقرير جلسة');
  static String get sharedWithPharmacistSuccess => _t(
    'Prescription image shared successfully.',
    'تمت مشاركة صورة الوصفة بنجاح.',
  );
  static String get imageDownloadedSuccess => _t(
    'Prescription image downloaded successfully.',
    'تم تنزيل صورة الوصفة بنجاح.',
  );
  static String get imageOperationFailed => _t(
    'Could not complete image operation. Please try again.',
    'تعذر إكمال عملية الصورة. يرجى المحاولة مرة أخرى.',
  );
  static String get noImageToShare => _t(
    'No image attached to this prescription yet.',
    'لا توجد صورة مرفقة بهذه الوصفة بعد.',
  );
  static String get totalLabel => _t('Total:', 'الإجمالي:');
  static String get activeMedicinesLabel =>
      _t('Active medicines:', 'الأدوية النشطة:');
  static String get totalNotesLabel => _t('Total notes:', 'إجمالي الملاحظات:');
  static String get editNote => _t('Edit', 'تعديل');
  static String get shareNote => _t('Share', 'مشاركة');
  static String assignmentProgressLabel(
    int questionIndex,
    int totalQuestions,
  ) => _t(
    'Question $questionIndex of $totalQuestions',
    'السؤال $questionIndex من $totalQuestions',
  );
  static String get editMedicalNoteTitle =>
      _t('Edit Medical Note', 'تعديل الملاحظة الطبية');
  static String get noteTitleLabel => _t('Note title', 'عنوان الملاحظة');
  static String get noteContentLabel => _t('Note details', 'تفاصيل الملاحظة');
  static String get saveChanges => _t('Save Changes', 'حفظ التغييرات');
  static String get shareWithDoctorTitle =>
      _t('Share with Doctor', 'المشاركة مع الطبيب');
  static String get chooseDoctorLabel => _t('Choose doctor', 'اختر الطبيب');
  static String get chooseDoctorHint => _t('Select a doctor', 'اختر طبيبا');
  static String get shareNow => _t('Share Now', 'شارك الآن');
  static String get noteUpdatedSuccess =>
      _t('Note updated successfully.', 'تم تحديث الملاحظة بنجاح.');
  static String get selectDoctorError =>
      _t('Please select a doctor.', 'يرجى اختيار طبيب.');

  static String get profileTitle => _t('Profile', 'الملف الشخصي');
  static String get editProfileTitle =>
      _t('Edit Profile', 'تعديل الملف الشخصي');
  static String get fullNameTitle => _t('Full Name', 'الاسم الكامل');
  static String get emailTitleProfile =>
      _t('Email Address', 'البريد الإلكتروني');
  static String get phoneTitleProfile => _t('Phone Number', 'رقم الهاتف');
  static String get birthDateTitle => _t('Birth Date', 'تاريخ الميلاد');
  static String get genderTitle => _t('Gender', 'الجنس');
  static String get passwordTitle => _t('Password', 'كلمة المرور');
  static String get saveProfileChanges => _t('Save Changes', 'حفظ التغييرات');
  static String get changeEmailTitle =>
      _t('Change Email', 'تغيير البريد الإلكتروني');
  static String get addNumberTitle => _t('Add Number', 'إضافة رقم');
  static String get deleteAccountTitle => _t('Delete Account', 'حذف الحساب');
  static String get profileUpdatedSuccess =>
      _t('Profile updated successfully.', 'تم تحديث الملف الشخصي بنجاح.');
  static String get emailVerificationRequired => _t(
    'Verify the new email before saving it.',
    'تحقق من البريد الجديد قبل الحفظ.',
  );
  static String get updateProfileHint => _t(
    'Edit the profile fields below. Email changes will be verified by OTP.',
    'قم بتعديل بيانات الملف أدناه. سيتم التحقق من تغيير البريد عبر رمز OTP.',
  );
  static String get verificationCodeSent =>
      _t('Verification code sent.', 'تم إرسال رمز التحقق.');
  static String get emailUpdatedSuccess =>
      _t('Email updated successfully.', 'تم تحديث البريد الإلكتروني بنجاح.');
  static String get verifyNewEmailTitle =>
      _t('Verify New Email', 'تحقق من البريد الإلكتروني الجديد');
  static String get resendCode => _t('Resend code', 'إعادة إرسال الرمز');
  static String get verify => _t('Verify', 'تحقق');

  static String get changePasswordTitle =>
      _t('Change Password', 'تغيير كلمة المرور');
  static String get oldPasswordLabel =>
      _t('Old Password', 'كلمة المرور القديمة');
  static String get oldPasswordHint =>
      _t('Enter your current password', 'أدخل كلمة المرور الحالية');
  static String get newPasswordLabel =>
      _t('New Password', 'كلمة المرور الجديدة');
  static String get newPasswordHint =>
      _t('Enter your new password', 'أدخل كلمة المرور الجديدة');
  static String get confirmPasswordLabel =>
      _t('Confirm Password', 'تأكيد كلمة المرور');
  static String get confirmPasswordHint =>
      _t('Confirm your new password', 'أكد كلمة المرور الجديدة');
  static String get passwordChanged =>
      _t('Password changed successfully.', 'تم تغيير كلمة المرور بنجاح.');
  static String get passwordMismatch =>
      _t('Passwords do not match.', 'كلمتا المرور غير متطابقتين.');
  static String get invalidOldPassword =>
      _t('Current password is incorrect.', 'كلمة المرور الحالية غير صحيحة.');
  static String get verifyOldEmailTitle =>
      _t('Verify Current Email', 'تحقق من البريد الحالي');
  static String get verifyOldEmailDesc => _t(
    'We will send a verification code to your current email address.',
    'سنرسل رمز تحقق إلى عنوان بريدك الإلكتروني الحالي.',
  );
  static String get newEmailVerificationDesc => _t(
    'A verification code will be sent to your new email address.',
    'سيتم إرسال رمز تحقق إلى عنوان بريدك الإلكتروني الجديد.',
  );
  static String get deleteAccountWarning => _t(
    'Are you sure you want to delete your account? This action cannot be undone.',
    'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
  );
  static String get deleteAccountConfirm => _t(
    'Type "DELETE" to confirm account deletion.',
    'اكتب "DELETE" لتأكيد حذف الحساب.',
  );
  static String get deleteConfirmationText => 'DELETE';
  static String get accountDeletedSuccess =>
      _t('Your account has been deleted successfully.', 'تم حذف حسابك بنجاح.');
  static String get forgotPasswordTitle =>
      _t('Reset Password', 'إعادة تعيين كلمة المرور');
  static String get forgotPasswordDesc => _t(
    'Enter your email address and we will send you a code to reset your password.',
    'أدخل بريدك الإلكتروني وسنرسل لك رمزا لإعادة تعيين كلمة المرور.',
  );
  static String get sendCode => _t('Send Code', 'إرسال الرمز');
  static String get resetPassword =>
      _t('Reset Password', 'إعادة تعيين كلمة المرور');

  static String get privacyTermsTitle =>
      _t('Privacy & Terms', 'الخصوصية والشروط');
  static String get privacyPolicyTitle =>
      _t('Privacy Policy', 'سياسة الخصوصية');
  static String get termsOfServiceTitle =>
      _t('Terms of Service', 'شروط الخدمة');
  static String get cookiePolicyTitle =>
      _t('Cookie Policy', 'سياسة ملفات الارتباط');
  static String get privacyPolicyBody => _t(
    'We are committed to protecting your privacy and ensuring you have a positive experience on our platform. This privacy policy explains how we collect, use, and protect your personal information.\n\nData Collection:\n• We collect information you provide directly, such as your name, email, and medical history.\n• We automatically collect certain information about your device and usage patterns.\n\nData Usage:\n• Your information is used to provide and improve our services.\n• We use your data to communicate with you about appointments and updates.\n• We may use aggregated data for research and analytics.\n\nData Protection:\n• We implement industry-standard security measures to protect your data.\n• Your data is encrypted both in transit and at rest.\n• We comply with all relevant data protection regulations.\n\nThird-Party Sharing:\n• We do not sell your personal information to third parties.\n• We only share your information with healthcare providers as needed for your care.\n• Third parties are bound by confidentiality agreements.',
    'نحن ملتزمون بحماية خصوصيتك وضمان حصولك على تجربة إيجابية على منصتنا. توضح سياسة الخصوصية هذه كيفية جمع معلوماتك الشخصية واستخدامها وحمايتها.\n\nجمع البيانات:\n• نجمع المعلومات التي تقدمها مباشرة، مثل اسمك وبريدك الإلكتروني وتاريخك الطبي.\n• نجمع تلقائيًا بعض المعلومات حول جهازك وأنماط الاستخدام.\n\nاستخدام البيانات:\n• تُستخدم معلوماتك لتقديم خدماتنا وتحسينها.\n• نستخدم بياناتك للتواصل معك بشأن المواعيد والتحديثات.\n• قد نستخدم البيانات المجمعة للبحث والتحليلات.\n\nحماية البيانات:\n• نطبق إجراءات أمان معيارية لحماية بياناتك.\n• يتم تشفير بياناتك أثناء النقل وعند التخزين.\n• نلتزم بجميع لوائح حماية البيانات ذات الصلة.\n\nالمشاركة مع أطراف ثالثة:\n• نحن لا نبيع معلوماتك الشخصية لأطراف ثالثة.\n• نشارك معلوماتك فقط مع مقدمي الرعاية الصحية عند الحاجة إلى ذلك من أجل رعايتك.\n• تلتزم الأطراف الثالثة باتفاقيات السرية.',
  );
  static String get termsBody => _t(
    'By using our platform, you agree to these terms and conditions. Please read them carefully.\n\nAcceptable Use:\n• You must be at least 18 years old or have parental consent.\n• You agree not to use the platform for illegal activities.\n• You must provide accurate and truthful information.\n\nUser Responsibilities:\n• You are responsible for maintaining your account security.\n• You must not share your login credentials with others.\n• You agree to use the platform only for legitimate healthcare purposes.\n\nPlatform Limitations:\n• Our platform is not a substitute for emergency medical care.\n• In case of emergency, please contact local emergency services.\n• We are not liable for interruptions or unavailability of service.\n\nIntellectual Property:\n• All content on our platform is protected by copyright.\n• You may not reproduce, distribute, or transmit any content without permission.\n\nDisclaimer:\n• We provide medical information for educational purposes only.\n• Consult with healthcare professionals before making medical decisions.\n• We are not liable for any health outcomes resulting from the use of our platform.',
    'باستخدامك لمنصتنا، فإنك توافق على هذه الشروط والأحكام. يرجى قراءتها بعناية.\n\nالاستخدام المقبول:\n• يجب أن يكون عمرك 18 عامًا على الأقل أو لديك موافقة ولي الأمر.\n• توافق على عدم استخدام المنصة في أنشطة غير قانونية.\n• يجب أن تقدم معلومات دقيقة وصحيحة.\n\nمسؤوليات المستخدم:\n• أنت مسؤول عن الحفاظ على أمان حسابك.\n• يجب ألا تشارك بيانات تسجيل الدخول مع الآخرين.\n• توافق على استخدام المنصة فقط لأغراض الرعاية الصحية المشروعة.\n\nقيود المنصة:\n• منصتنا ليست بديلاً عن الرعاية الطبية الطارئة.\n• في حالة الطوارئ، يرجى الاتصال بخدمات الطوارئ المحلية.\n• نحن غير مسؤولين عن الانقطاعات أو عدم توفر الخدمة.\n\nالملكية الفكرية:\n• جميع المحتويات على منصتنا محمية بحقوق النشر.\n• لا يجوز لك إعادة إنتاج أي محتوى أو توزيعه أو نقله دون إذن.\n\nإخلاء المسؤولية:\n• نقدم معلومات طبية لأغراض تعليمية فقط.\n• استشر المختصين قبل اتخاذ أي قرارات طبية.\n• نحن غير مسؤولين عن أي نتائج صحية ناتجة عن استخدام منصتنا.',
  );
  static String get cookieBody => _t(
    'We use cookies to enhance your experience on our platform.\n\nTypes of Cookies:\n• Essential cookies are necessary for the platform to function.\n• Analytical cookies help us understand how you use our platform.\n• Preference cookies remember your settings and preferences.\n\nCookie Management:\n• You can control cookies through your browser settings.\n• Disabling cookies may affect platform functionality.',
    'نستخدم ملفات تعريف الارتباط لتحسين تجربتك على منصتنا.\n\nأنواع ملفات الارتباط:\n• ملفات الارتباط الأساسية ضرورية لعمل المنصة.\n• تساعدنا ملفات الارتباط التحليلية على فهم كيفية استخدامك للمنصة.\n• تتذكر ملفات الارتباط التفضيلية إعداداتك وتفضيلاتك.\n\nإدارة ملفات الارتباط:\n• يمكنك التحكم في ملفات الارتباط من خلال إعدادات المتصفح.\n• قد يؤدي تعطيل ملفات الارتباط إلى التأثير على وظائف المنصة.',
  );
  static String get privacyLastUpdated =>
      _t('Last updated: April 2026', 'آخر تحديث: أبريل 2026');
  static String get privacyContactHint => _t(
    'For questions about our privacy practices or terms, please contact us.',
    'للأسئلة حول ممارسات الخصوصية أو الشروط، يرجى التواصل معنا.',
  );

  static String get contactScreenTitle => _t('Contact Us', 'اتصل بنا');
  static String get getInTouchTitle => _t('Get in Touch', 'ابق على تواصل');
  static String get getInTouchSubtitle => _t(
    'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
    'يسعدنا سماعك. أرسل لنا رسالة وسنرد عليك بأسرع وقت.',
  );
  static String get sendMessageSectionTitle =>
      _t('Send us a Message', 'أرسل لنا رسالة');
  static String get sendMessageButton => _t('Send Message', 'إرسال الرسالة');
  static String get emailTitle => _t('Email', 'البريد الإلكتروني');
  static String get phoneTitle => _t('Phone', 'الهاتف');
  static String get officeTitle => _t('Office', 'المكتب');
  static String get hoursTitle => _t('Hours', 'ساعات العمل');
  static String get fullNameLabel => _t('Full Name', 'الاسم الكامل');
  static String get fullNameHint =>
      _t('Enter your full name', 'أدخل اسمك الكامل');
  static String get emailAddressLabel =>
      _t('Email Address', 'عنوان البريد الإلكتروني');
  static String get emailAddressHint =>
      _t('your.email@example.com', 'example@email.com');
  static String get messageLabel => _t('Message', 'الرسالة');
  static String get messageHint =>
      _t('Tell us how we can help...', 'أخبرنا كيف يمكننا مساعدتك...');
  static String get fillAllFieldsError =>
      _t('Please fill in all fields', 'يرجى تعبئة جميع الحقول');
  static String get invalidEmailError =>
      _t('Please enter a valid email address', 'يرجى إدخال بريد إلكتروني صالح');
  static String get messageSentSuccess =>
      _t('Message sent successfully!', 'تم إرسال الرسالة بنجاح!');

  static String get male => _t('Male', 'ذكر');
  static String get female => _t('Female', 'أنثى');
  static String get other => _t('Other', 'آخر');
  static String yearsOld(int years) => _t('$years Years old', '$years سنة');
  static String get saveProfileChangesConfirm =>
      _t('Save these profile changes?', 'حفظ تغييرات الملف الشخصي؟');

  static String get enterNewEmailAddress =>
      _t('Enter your new email address', 'أدخل بريدك الإلكتروني الجديد');
  static String currentEmailLabel(String email) =>
      _t('Current email: $email', 'البريد الحالي: $email');
  static String get newEmailHint => _t('new@example.com', 'new@example.com');
  static String get emailRequired =>
      _t('Email is required', 'البريد الإلكتروني مطلوب');
  static String get continueText => _t('Continue', 'متابعة');

  static String get assessmentTitle => _t('Assessment', 'التقييم');
  static String get assessmentPrompt => _t(
    'Select the option that best represents your current state of mind.',
    'اختر الخيار الذي يصف حالتك الحالية بشكل أفضل.',
  );
  static String get backButton => _t('Back', 'رجوع');
  static String get continueButton => _t('Continue', 'متابعة');
  static String get submitButton => _t('Submit', 'إرسال');
  static String get retryButton => _t('Retry', 'إعادة المحاولة');
  static String get chooseAnswerBeforeContinuing => _t(
    'Please choose an answer before continuing.',
    'يرجى اختيار إجابة قبل المتابعة.',
  );
  static String get answerAllQuestionsBeforeSubmitting => _t(
    'Please answer all questions before submitting.',
    'يرجى الإجابة عن جميع الأسئلة قبل الإرسال.',
  );
  static String get assignmentRecommendedSpecialistSummary => _t(
    'Based on your answers, we recommend speaking with a specialist that matches your current mental health state.',
    'بناءً على إجاباتك، نوصي بالتحدث مع متخصص يناسب حالتك النفسية الحالية.',
  );

  static String assignmentQuestionLabel(String text) {
    final normalized = text.trim().toLowerCase();
    switch (normalized) {
      case 'little interest or pleasure in doing things':
        return _t(
          'Little interest or pleasure in doing things',
          'قلة الاهتمام أو المتعة في القيام بالأشياء',
        );
      case 'feeling down, depressed, or hopeless':
        return _t(
          'Feeling down, depressed, or hopeless',
          'الشعور بالحزن أو الاكتئاب أو اليأس',
        );
      case 'trouble falling or staying asleep, or sleeping too much':
        return _t(
          'Trouble falling or staying asleep, or sleeping too much',
          'صعوبة في النوم أو الاستمرار فيه، أو النوم أكثر من اللازم',
        );
      case 'feeling tired or having little energy':
        return _t(
          'Feeling tired or having little energy',
          'الشعور بالتعب أو قلة الطاقة',
        );
      case 'poor appetite or overeating':
        return _t(
          'Poor appetite or overeating',
          'ضعف الشهية أو الإفراط في الأكل',
        );
      case 'feeling bad about yourself or that you are a failure':
        return _t(
          'Feeling bad about yourself or that you are a failure',
          'الشعور بالسوء تجاه نفسك أو أنك فاشل',
        );
      case 'trouble concentrating on things':
        return _t(
          'Trouble concentrating on things',
          'صعوبة في التركيز على الأمور',
        );
      case 'moving or speaking so slowly that others have noticed':
        return _t(
          'Moving or speaking so slowly that others have noticed',
          'التحرك أو الكلام ببطء لدرجة يلاحظها الآخرون',
        );
      case 'thoughts that you would be better off dead':
        return _t(
          'Thoughts that you would be better off dead',
          'أفكار بأنك ستكون أفضل لو كنت ميتًا',
        );
      default:
        return text;
    }
  }

  static String assignmentOptionLabel(String option) {
    final normalized = option.trim().toLowerCase();
    switch (normalized) {
      case 'never':
        return _t('Never / أبدًا', 'أبدًا / Never');
      case 'not at all':
        return _t('Not at all / على الإطلاق', 'على الإطلاق / Not at all');
      case 'sometimes':
      case 'several days':
        return _t('Several days / عدة أيام', 'عدة أيام / Several days');
      case 'often':
      case 'more than half the days':
        return _t(
          'More than half the days / أكثر من نصف الأيام',
          'أكثر من نصف الأيام / More than half the days',
        );
      case 'always':
      case 'nearly every day':
        return _t(
          'Nearly every day / تقريبًا كل يوم',
          'تقريبًا كل يوم / Nearly every day',
        );
      case 'extremely':
        return _t('Extremely / بشكل كبير', 'بشكل كبير / Extremely');
      default:
        return option;
    }
  }

  static String assignmentSeverityLabel(String severity) {
    final normalized = severity.trim().toLowerCase();
    switch (normalized) {
      case 'minimal':
        return _t('Minimal', 'بسيط جدًا');
      case 'mild':
        return _t('Mild', 'خفيف');
      case 'moderate':
        return _t('Moderate', 'متوسط');
      case 'moderately_severe':
      case 'moderately severe':
        return _t('Moderately severe', 'متوسط إلى شديد');
      case 'severe':
        return _t('Severe', 'شديد');
      default:
        return severity;
    }
  }

  static String assignmentSummaryLabel(String severity, String backendSummary) {
    if (!isArabic) {
      if (backendSummary.trim().isNotEmpty) {
        return backendSummary;
      }

      final normalized = severity.trim().toLowerCase();
      switch (normalized) {
        case 'minimal':
          return 'Your assessment indicates minimal symptoms. Continue with healthy lifestyle habits.';
        case 'mild':
          return 'Your assessment indicates mild symptoms. Consider speaking with a mental health professional.';
        case 'moderate':
          return 'Your assessment indicates moderate symptoms. Professional support is recommended.';
        case 'moderately_severe':
        case 'moderately severe':
          return 'Your assessment indicates moderately severe symptoms. Professional psychological or psychiatric care is strongly recommended.';
        case 'severe':
          return 'Your assessment indicates severe symptoms. Immediate professional help is recommended. Please reach out to a mental health professional.';
        default:
          return 'Based on your answers, we recommend speaking with a specialist that matches your current mental health state.';
      }
    }

    final normalized = severity.trim().toLowerCase();
    switch (normalized) {
      case 'minimal':
        return _t(
          'Your assessment indicates minimal symptoms. Continue with healthy lifestyle habits.',
          'تشير نتيجتك إلى أعراض بسيطة جدًا. واصل العادات الصحية الجيدة.',
        );
      case 'mild':
        return _t(
          'Your assessment indicates mild symptoms. Consider speaking with a mental health professional.',
          'تشير نتيجتك إلى أعراض خفيفة. فكر في التحدث مع متخصص في الصحة النفسية.',
        );
      case 'moderate':
        return _t(
          'Your assessment indicates moderate symptoms. Professional support is recommended.',
          'تشير نتيجتك إلى أعراض متوسطة. يُنصح بالحصول على دعم مهني.',
        );
      case 'moderately_severe':
      case 'moderately severe':
        return _t(
          'Your assessment indicates moderately severe symptoms. Professional psychological or psychiatric care is strongly recommended.',
          'تشير نتيجتك إلى أعراض متوسطة إلى شديدة. يُنصح بشدة بالرعاية النفسية أو النفسية الطبية المتخصصة.',
        );
      case 'severe':
        return _t(
          'Your assessment indicates severe symptoms. Immediate professional help is recommended. Please reach out to a mental health professional.',
          'تشير نتيجتك إلى أعراض شديدة. يُنصح بالحصول على مساعدة مهنية فورًا. يرجى التواصل مع متخصص في الصحة النفسية.',
        );
      default:
        return _t(
          'Based on your answers, we recommend speaking with a specialist that matches your current mental health state.',
          'بناءً على إجاباتك، نوصي بالتحدث مع متخصص يناسب حالتك النفسية الحالية.',
        );
    }
  }

  static String get verifyYourNewEmail =>
      _t('Verify your new email', 'تحقق من بريدك الإلكتروني الجديد');
  static String verificationCodeSentTo(String email) => _t(
    'We sent a verification code to:\n$email',
    'أرسلنا رمز التحقق إلى:\n$email',
  );
  static String get otpSentToNewEmail => _t(
    'OTP sent to your new email address.',
    'تم إرسال رمز التحقق إلى بريدك الإلكتروني الجديد.',
  );
  static String get otpResentToEmail => _t(
    'OTP resent to your email.',
    'تمت إعادة إرسال رمز التحقق إلى بريدك الإلكتروني.',
  );
  static String get invalidFourDigitCode => _t(
    'Please enter a valid 4-digit code.',
    'يرجى إدخال رمز صحيح مكون من 4 أرقام.',
  );
  static String get incorrectOtpTryAgain => _t(
    'Incorrect OTP. Please try again.',
    'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.',
  );

  static String get forgotEmailHint => _t('your@email.com', 'your@email.com');
  static String get sendResetLink =>
      _t('Send Reset Link', 'إرسال رابط إعادة التعيين');
  static String get resetInstructionsHint => _t(
    'Check your email for password reset instructions.',
    'تحقق من بريدك الإلكتروني للحصول على تعليمات إعادة تعيين كلمة المرور.',
  );
  static String get passwordResetLinkSent => _t(
    'Password reset link sent to your email.',
    'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
  );

  static String get deleteWhatWillBeDeleted =>
      _t('What will be deleted:', 'ما الذي سيتم حذفه:');
  static String get deleteItemProfileInfo =>
      _t('Your profile information', 'معلومات ملفك الشخصي');
  static String get deleteItemPrescriptions =>
      _t('Medical prescriptions and reports', 'الوصفات والتقارير الطبية');
  static String get deleteItemSessionHistory =>
      _t('Session notes and history', 'ملاحظات الجلسات والسجل');
  static String get deleteItemAllData =>
      _t('All personal data', 'كل البيانات الشخصية');
  static String get confirmPassword =>
      _t('Confirm your password', 'أكد كلمة المرور');
  static String get enterYourPasswordHint =>
      _t('Enter your password', 'أدخل كلمة المرور');
  static String get pleaseEnterPassword =>
      _t('Please enter your password', 'يرجى إدخال كلمة المرور');
  static String get deleteIrreversibleConfirm => _t(
    'This action cannot be undone. Are you absolutely sure?',
    'لا يمكن التراجع عن هذا الإجراء. هل أنت متأكد تماما؟',
  );
  static String get couldNotRetrieveUserEmail =>
      _t('Could not retrieve user email', 'تعذر الحصول على بريد المستخدم');

  static String get verifyAccountTitle =>
      _t('Verify your account', 'تحقق من حسابك');
  static String get verifyAccountDescription => _t(
    'We have sent 4-digit code to your Email\nEnter the code below to verify your account.',
    'لقد أرسلنا رمزًا مكونًا من 4 أرقام إلى بريدك الإلكتروني\nأدخل الرمز أدناه للتحقق من حسابك.',
  );
  static String otpVerifiedWith(String pin) =>
      _t('OTP Verified: $pin', 'تم التحقق من الرمز: $pin');
  static String get codeResentToEmail => _t(
    'Code resent to your email',
    'تمت إعادة إرسال الرمز إلى بريدك الإلكتروني',
  );
  static String get didntReceiveCodeResend =>
      _t('Didn\'t receive the code? Resend', 'لم تتلق الرمز؟ أعد الإرسال');

  static String get birthdateLabel => _t('Birthdate', 'تاريخ الميلاد');
  static String get next => _t('Next', 'التالي');
  static String get enterBirthdateAndGender => _t(
    'Please enter your birthdate and gender.',
    'يرجى إدخال تاريخ الميلاد والجنس.',
  );

  static String get createYourAccount =>
      _t('Create your account', 'أنشئ حسابك');
  static String get nicknameLabel => _t('Nickname', 'الاسم المستعار');
  static String get nameRequired => _t('Name is required', 'الاسم مطلوب');
  static String get nameMinTwoChars => _t(
    'Name must be at least 2 characters',
    'الاسم يجب أن يكون على الأقل حرفين',
  );
  static String get passwordRequired =>
      _t('Password is required', 'كلمة المرور مطلوبة');
  static String get passwordMinSixChars => _t(
    'Password must be at least 6 characters',
    'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
  );
  static String get login => _t('Login', 'تسجيل الدخول');
  static String get enterYourAccount => _t('Enter your account', 'أدخل حسابك');
  static String get emailLabel => _t('Email', 'البريد الإلكتروني');
  static String welcomeUser(String userName) =>
      _t('Welcome $userName', 'مرحبًا $userName');
  static String get startYourJourney => _t('Start your journey', 'ابدأ رحلتك');
  static String get findSpecialistTitle =>
      _t('Find specialist', 'ابحث عن متخصص');

  static String get letsGetToKnowYou =>
      _t("Let's get to know you", 'دعنا نتعرف عليك');
  static String get personalizeExperienceHint => _t(
    'The following information will help us to personalize your experience',
    'ستساعدنا المعلومات التالية على تخصيص تجربتك',
  );

  static String get passwordChangePreparing => _t(
    'Password change feature is being prepared. Please check back soon.',
    'ميزة تغيير كلمة المرور قيد التجهيز. يرجى المحاولة لاحقا.',
  );

  static String errorWith(String message) =>
      _t('Error: $message', 'خطأ: $message');
}

class MockSplashData {
  // Mock onboarding screens data
  static const List<Map<String, dynamic>> mockOnboardingScreens = [
    {
      'id': 'onboard_001',
      'title': 'Welcome to Afiete',
      'description': 'Your personal mental health companion and therapy platform',
      'imageUrl': 'https://via.placeholder.com/400x300?text=Welcome',
      'backgroundColor': '#0493E2',
    },
    {
      'id': 'onboard_002',
      'title': 'Connect with Expert Doctors',
      'description': 'Access qualified mental health professionals from the comfort of your home',
      'imageUrl': 'https://via.placeholder.com/400x300?text=Doctors',
      'backgroundColor': '#0051FF',
    },
    {
      'id': 'onboard_003',
      'title': 'Self-Assessment Tools',
      'description': 'Track your mental health with scientifically-backed assessment tools',
      'imageUrl': 'https://via.placeholder.com/400x300?text=Assessment',
      'backgroundColor': '#00D4FF',
    },
    {
      'id': 'onboard_004',
      'title': 'Secure & Private',
      'description': 'Your privacy and data security are our top priorities',
      'imageUrl': 'https://via.placeholder.com/400x300?text=Secure',
      'backgroundColor': '#6200EA',
    },
  ];

  // Mock app information
  static const Map<String, dynamic> mockAppInfo = {
    'appName': 'Afiete',
    'appVersion': '1.0.0',
    'buildNumber': '1',
    'minSupportedVersion': '1.0.0',
    'latestVersion': '1.0.0',
    'updateAvailable': false,
    'privacyPolicyUrl': 'https://example.com/privacy',
    'termsOfServiceUrl': 'https://example.com/terms',
  };

  // Mock splash configuration
  static const Map<String, dynamic> mockSplashConfig = {
    'splashDurationSeconds': 3,
    'showOnboarding': true,
    'showAnimation': true,
    'animationDuration': 2,
    'logoUrl': 'https://via.placeholder.com/200?text=Afiete+Logo',
    'splashBackgroundColor': '#F5F6F8',
  };

  // Mock welcome tips for new users
  static const List<Map<String, dynamic>> mockWelcomeTips = [
    {
      'id': 'tip_001',
      'title': 'Create Your Profile',
      'description': 'Set up your profile with medical history for personalized recommendations',
      'icon': 'profile',
      'order': 1,
    },
    {
      'id': 'tip_002',
      'title': 'Take Assessment',
      'description': 'Complete our mental health assessment to identify your needs',
      'icon': 'assessment',
      'order': 2,
    },
    {
      'id': 'tip_003',
      'title': 'Browse Doctors',
      'description': 'Explore and connect with qualified mental health professionals',
      'icon': 'doctors',
      'order': 3,
    },
    {
      'id': 'tip_004',
      'title': 'Start Sessions',
      'description': 'Book your first consultation and begin your mental health journey',
      'icon': 'calendar',
      'order': 4,
    },
  ];

  // Mock authentication state
  static const Map<String, dynamic> mockAuthState = {
    'isAuthenticated': false,
    'isFirstLaunch': true,
    'hasSeenOnboarding': false,
    'preferredLanguage': 'en',
    'isDarkMode': false,
  };

  // Mock feature flags
  static const Map<String, bool> mockFeatureFlags = {
    'enableOnboarding': true,
    'enableGoogleSignIn': true,
    'enableVideoCall': true,
    'enableVoiceCall': true,
    'enableTextChat': true,
    'enableAssessments': true,
    'enablePayments': true,
    'enableMedicineReminders': false, // Coming soon
    'enableAIRecommendations': false, // Coming soon
  };

  static List<Map<String, dynamic>> getMockOnboardingScreens() => mockOnboardingScreens;

  static Map<String, dynamic> getMockAppInfo() => mockAppInfo;

  static Map<String, dynamic> getMockSplashConfig() => mockSplashConfig;

  static List<Map<String, dynamic>> getMockWelcomeTips() => mockWelcomeTips;

  static Map<String, dynamic> getMockAuthState() => mockAuthState;

  static Map<String, bool> getMockFeatureFlags() => mockFeatureFlags;

  static bool isFeatureEnabled(String featureName) {
    return mockFeatureFlags[featureName] ?? false;
  }

  static int getOnboardingScreenCount() => mockOnboardingScreens.length;

  static int getSplashDurationMilliseconds() =>
      (mockSplashConfig['splashDurationSeconds'] as int) * 1000;
}

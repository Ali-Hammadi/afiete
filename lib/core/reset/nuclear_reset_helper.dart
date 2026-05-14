import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppDependenciesSetup = Future<void> Function();
typedef SecureStorageClear = Future<void> Function();

/// Centralized app reset coordinator.
///
/// Call [configure] once in app bootstrap, then call [performNuclearReset]
/// from any layer (interceptor, cubit, etc.) without BuildContext.
abstract class NuclearResetHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GetIt? _getIt;
  static AppDependenciesSetup? _setupDependencies;
  static SecureStorageClear? _clearSecureStorage;
  static bool _isResetting = false;

  static void configure({
    required GetIt getIt,
    required AppDependenciesSetup setupDependencies,
    SecureStorageClear? clearSecureStorage,
  }) {
    _getIt = getIt;
    _setupDependencies = setupDependencies;
    _clearSecureStorage = clearSecureStorage;
  }

  static Future<void> performNuclearReset() async {
    if (_isResetting) {
      return;
    }
    _isResetting = true;

    try {
      // 1) Clear persistent local data.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _clearSecureStorage?.call();

      // 2) Clear decoded and live image caches.
      final imageCache = PaintingBinding.instance.imageCache;
      imageCache.clear();
      imageCache.clearLiveImages();

      // 3) Reset DI graph and recreate fresh singletons.
      final getIt = _getIt;
      final setupDependencies = _setupDependencies;
      if (getIt != null && setupDependencies != null) {
        await getIt.reset();
        await setupDependencies();
      }
    } finally {
      _isResetting = false;
    }
  }

  /// Helper for background layers (like Dio interceptor):
  /// perform full reset then navigate to splash without BuildContext.
  static Future<void> performResetAndGoToSplash(String splashRoute) async {
    await performNuclearReset();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      splashRoute,
      (route) => false,
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afiete/core/routes/app_route.dart';

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
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Already resetting, returning early',
      );
      return;
    }
    _isResetting = true;
    debugPrint('[NuclearResetHelper] performNuclearReset: START');

    try {
      // 1) Clear persistent local data.
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Clearing SharedPreferences...',
      );
      final prefs = await SharedPreferences.getInstance();
      final prefsSize = prefs.getKeys().length;
      await prefs.clear();
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Cleared $prefsSize preferences',
      );

      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Clearing secure storage...',
      );
      await _clearSecureStorage?.call();
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Secure storage cleared',
      );

      // 2) Clear decoded and live image caches.
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Clearing image caches...',
      );
      final imageCache = PaintingBinding.instance.imageCache;
      final cacheSize = imageCache.currentSize;
      imageCache.clear();
      imageCache.clearLiveImages();
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Cleared image cache (was $cacheSize bytes)',
      );

      // 3) Reset DI graph and recreate fresh singletons.
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Resetting DI container...',
      );
      final getIt = _getIt;
      final setupDependencies = _setupDependencies;
      if (getIt != null && setupDependencies != null) {
        debugPrint(
          '[NuclearResetHelper] performNuclearReset: GetIt reset in progress...',
        );
        await getIt.reset();
        debugPrint(
          '[NuclearResetHelper] performNuclearReset: GetIt reset completed',
        );

        debugPrint(
          '[NuclearResetHelper] performNuclearReset: Re-initializing dependencies...',
        );
        await setupDependencies();
        debugPrint(
          '[NuclearResetHelper] performNuclearReset: Dependencies re-initialized',
        );
      } else {
        debugPrint(
          '[NuclearResetHelper] performNuclearReset: WARNING - getIt or setupDependencies is null',
        );
      }

      debugPrint('[NuclearResetHelper] performNuclearReset: COMPLETE');
    } catch (e, st) {
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: ERROR - $e\nStackTrace: $st',
      );
      rethrow;
    } finally {
      _isResetting = false;
      debugPrint(
        '[NuclearResetHelper] performNuclearReset: Finally block executed',
      );
    }
  }

  /// Helper for background layers (like Dio interceptor):
  /// perform full reset then navigate to splash without BuildContext.
  static Future<void> performResetAndGoToSplash(String splashRoute) async {
    debugPrint(
      '[NuclearResetHelper] performResetAndGoToSplash: START (splashRoute=$splashRoute)',
    );
    try {
      debugPrint(
        '[NuclearResetHelper] performResetAndGoToSplash: Calling performNuclearReset...',
      );
      await performNuclearReset();
      debugPrint(
        '[NuclearResetHelper] performResetAndGoToSplash: performNuclearReset completed',
      );

      debugPrint(
        '[NuclearResetHelper] performResetAndGoToSplash: Navigating to splash route...',
      );
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        splashRoute,
        (route) => false,
      );
      debugPrint(
        '[NuclearResetHelper] performResetAndGoToSplash: Navigation initiated',
      );
    } catch (e) {
      debugPrint('[NuclearResetHelper] performResetAndGoToSplash: ERROR - $e');
      rethrow;
    }
  }

  /// High-level wipe that attempts a full application wipe (storage,
  /// secure storage, image cache, DI) and then triggers a UI restart via
  /// the provided `restartApp` callback. This is the preferred entrypoint
  /// for actions initiated from the UI (logout, delete account) where we
  /// recreate the root widget using a `UniqueKey` approach.
  static Future<void> wipeEverything() async {
    if (_isResetting) return;
    _isResetting = true;
    try {
      debugPrint('[NuclearResetHelper] wipeEverything: START');

      // 1) Clear persistent local data.
      debugPrint('[NuclearResetHelper] Clearing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint('[NuclearResetHelper] SharedPreferences cleared');

      debugPrint('[NuclearResetHelper] Clearing secure storage...');
      await _clearSecureStorage?.call();
      debugPrint('[NuclearResetHelper] Secure storage cleared');

      // 2) Clear decoded and live image caches.
      debugPrint('[NuclearResetHelper] Clearing image caches...');
      final imageCache = PaintingBinding.instance.imageCache;
      imageCache.clear();
      imageCache.clearLiveImages();
      debugPrint('[NuclearResetHelper] Image caches cleared');

      // 3) Reset DI graph and recreate fresh singletons.
      debugPrint('[NuclearResetHelper] Resetting DI container...');
      final getIt = _getIt;
      final setupDependencies = _setupDependencies;
      if (getIt != null && setupDependencies != null) {
        await getIt.reset();
        await setupDependencies();
        debugPrint(
          '[NuclearResetHelper] DI container reset and re-initialized',
        );
      } else {
        debugPrint(
          '[NuclearResetHelper] WARNING: getIt or setupDependencies is null',
        );
      }

      // 4) Navigate to splash screen.
      // Note: We don't use the restartApp callback here due to BuildContext
      // being unsafe after async gaps. Instead, rely on navigator fallback.
      debugPrint('[NuclearResetHelper] Attempting navigation to splash screen');
      debugPrint(
        '[NuclearResetHelper] navigatorKey.currentState = ${navigatorKey.currentState}',
      );

      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          MyRoutes.splashScreen,
          (route) => false,
        );
        debugPrint('[NuclearResetHelper] Navigation to splash initiated');
      } else {
        debugPrint(
          '[NuclearResetHelper] ERROR: navigatorKey.currentState is null, cannot navigate',
        );
      }

      debugPrint('[NuclearResetHelper] wipeEverything: COMPLETE');
    } finally {
      _isResetting = false;
    }
  }
}

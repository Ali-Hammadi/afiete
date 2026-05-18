import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afiete/core/routes/app_route.dart';

typedef AppDependenciesSetup = Future<void> Function();
typedef SecureStorageClear = Future<void> Function();
typedef RestartApp = void Function(BuildContext context);

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
  static RestartApp? _restartApp;
  static bool _isResetting = false;

  static void configure({
    required GetIt getIt,
    required AppDependenciesSetup setupDependencies,
    SecureStorageClear? clearSecureStorage,
    RestartApp? restartApp,
  }) {
    _getIt = getIt;
    _setupDependencies = setupDependencies;
    _clearSecureStorage = clearSecureStorage;
    _restartApp = restartApp;
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

  /// High-level wipe that attempts a full application wipe (storage,
  /// secure storage, image cache, DI) and then triggers a UI restart via
  /// the provided `restartApp` callback. This is the preferred entrypoint
  /// for actions initiated from the UI (logout, delete account) where we
  /// recreate the root widget using a `UniqueKey` approach.
  /// triggers a UI restart via the provided `restartApp` callback. This is
  /// the preferred entrypoint for actions initiated from the UI (logout,
  /// delete account) where we can recreate the root widget using a
  /// `UniqueKey` approach.
  static Future<void> wipeEverything() async {
    if (_isResetting) return;
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

      // 4) Trigger UI restart using the configured restart callback.
      // Do not use any BuildContext captured before awaits; instead obtain
      // a fresh context from the stored navigatorKey and invoke the
      // restart callback in the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigatorKey.currentContext;
        if (ctx != null && _restartApp != null) {
          try {
            _restartApp!(ctx);
            return;
          } catch (_) {
            // fallthrough to navigator fallback
          }
        }

        // Fallback navigation to splash if restart callback isn't usable.
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          MyRoutes.splashScreen,
          (route) => false,
        );
      });
    } finally {
      _isResetting = false;
    }
  }
}

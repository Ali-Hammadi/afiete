import 'package:afiete/feature/auth/presentation/views/auth_info_screen.dart';
import 'package:afiete/feature/auth/presentation/views/verify_account_screen.dart';
import 'package:afiete/feature/doctors/presentation/screens/doctor_info.dart';
import 'package:afiete/feature/home/presentation/screens/global_home_screen.dart';
import 'package:afiete/feature/settings/presentation/screens/medical_profile_screen.dart';
import 'package:afiete/feature/settings/presentation/screens/profile_info_screen.dart';
import 'package:afiete/feature/settings/presentation/screens/report_issue_screen.dart';
import 'package:afiete/feature/settings/presentation/screens/settings_screen.dart';
import 'package:afiete/feature/sessions/presentation/screens/my_sessions_screen.dart';
import 'package:afiete/feature/splash/presentation/views/splash_screen.dart';
import 'package:afiete/feature/auth/presentation/views/signup_screen.dart';
import 'package:afiete/feature/auth/presentation/views/login_screen.dart';
import 'package:afiete/feature/splash/presentation/views/welcome_screens.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MyRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case MyRoutes.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case MyRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case MyRoutes.welcomeScreens:
        return MaterialPageRoute(builder: (_) => const WelcomeScreens());
      case MyRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => const GlobalHomeScreen());
      case MyRoutes.verifyAccountScreen:
        return MaterialPageRoute(builder: (_) => const VerifyAccountScreen());
      case MyRoutes.authInfoScreens:
        return MaterialPageRoute(builder: (_) => const AuthInfoScreen());
      case MyRoutes.doctorInfoScreen:
        return MaterialPageRoute(builder: (_) => const DoctorInfo());
      case MyRoutes.mySessionsScreen:
        return MaterialPageRoute(builder: (_) => const MySessionsScreen());
      case MyRoutes.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case MyRoutes.medicalProfileScreen:
        return MaterialPageRoute(builder: (_) => const MedicalProfileScreen());
      case MyRoutes.profileInfoScreen:
        return MaterialPageRoute(builder: (_) => const ProfileInfoScreen());
      case MyRoutes.reportIssueScreen:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: const Text(
                'Route not found',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
    }
  }
}

class MyRoutes {
  // Splash Screen
  static const String splashScreen = "/splashScreen";
  // Authentication Screens
  static const String signup = "/signup";
  static const String login = "/login";
  static const String welcomeScreens = "/welcomeScreens";
  static const String verifyAccountScreen = "/verifyAccountScreen";
  static const String authInfoScreens = "/authInfoScreens";
  // Home Screens
  // Sessions Screens
  static const String mySessionsScreen = "/mySessionsScreen";
  static const String homeScreen = "/homeScreens";
  static const String doctorInfoScreen = "/doctorInfoScreen";
  static const String settingsScreen = "/settingsScreen";
  static const String medicalProfileScreen = "/medicalProfileScreen";
  static const String profileInfoScreen = "/profileInfoScreen";
  static const String reportIssueScreen = "/reportIssueScreen";
}

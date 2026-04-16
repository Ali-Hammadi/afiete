import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/assignments/presentation/screens/assignment_result_screen.dart';
import 'package:afiete/feature/assignments/presentation/screens/assignment_test_screen.dart';
import 'package:afiete/feature/auth/presentation/views/auth_info_screen.dart';
import 'package:afiete/feature/auth/presentation/views/verify_account_screen.dart';
import 'package:afiete/feature/booking_assiments/presentation/screens/appointments_screen.dart';
import 'package:afiete/feature/booking_assiments/presentation/screens/book_session_screen.dart';
import 'package:afiete/feature/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/presentation/screens/doctor_info.dart';
import 'package:afiete/feature/doctors/presentation/screens/doctors_home_screen.dart';
import 'package:afiete/feature/home/presentation/screens/first_home_screen.dart';
import 'package:afiete/feature/home/presentation/screens/global_home_screen.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:afiete/feature/payment/presentation/screens/payment_screen.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/presentation/cubits/report_cubit.dart';
import 'package:afiete/feature/report/presentation/screens/report_history_screen.dart';
import 'package:afiete/feature/report/presentation/screens/report_screen.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

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
      case MyRoutes.firstHomeScreen:
        return MaterialPageRoute(builder: (_) => const FirstHomeScreen());
      case MyRoutes.verifyAccountScreen:
        return MaterialPageRoute(builder: (_) => const VerifyAccountScreen());
      case MyRoutes.authInfoScreens:
        return MaterialPageRoute(builder: (_) => const AuthInfoScreen());
      case MyRoutes.doctorInfoScreen:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              DoctorInfo(doctor: args is DoctorEntity ? args : null),
        );
      case MyRoutes.bookSessionScreen:
        final args = settings.arguments;
        if (args is! DoctorEntity) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text(
                  'Doctor data is required to start booking.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BookSessionScreen(doctor: args),
        );
      case MyRoutes.doctorsHomeScreen:
        return MaterialPageRoute(builder: (_) => const DoctorsHomeScreen());
      case MyRoutes.appointmentsScreen:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
      case MyRoutes.paymentScreen:
        final args = settings.arguments;
        if (args is! PaymentRequestEntity) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text(
                  'Payment details are required.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => PaymentScreen(request: args));
      case MyRoutes.mySessionsScreen:
        return MaterialPageRoute(builder: (_) => const MySessionsScreen());
      case MyRoutes.chatConversationScreen:
        final args = settings.arguments;
        if (args is! ChatConversationArgs) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text(
                  'Chat conversation data is required.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ChatConversationScreen(args: args),
        );
      case MyRoutes.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case MyRoutes.medicalProfileScreen:
        return MaterialPageRoute(builder: (_) => const MedicalProfileScreen());
      case MyRoutes.profileInfoScreen:
        return MaterialPageRoute(builder: (_) => const ProfileInfoScreen());
      case MyRoutes.reportIssueScreen:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());
      case MyRoutes.assignmentTestScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AssignmentsCubit>(
            create: (_) => sl<AssignmentsCubit>()..loadQuestions(),
            child: const AssignmentTestScreen(),
          ),
        );
      case MyRoutes.assignmentResultScreen:
        final args = settings.arguments;
        if (args is! AssignmentsResultLoaded) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: const Text(
                  'Invalid arguments for assignment result screen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => AssignmentResultScreen(state: args),
        );

      case MyRoutes.reportScreen:
        final args = settings.arguments;
        final reportArgs = args is ReportScreenArgs
            ? args
            : args is Map<String, dynamic>
            ? ReportScreenArgs(
                reportType: args['reportType'] as ReportType,
                userId: args['userId'] as String,
                doctorId: args['doctorId'] as String?,
                doctorName: args['doctorName'] as String?,
                sessionId: args['sessionId'] as String?,
              )
            : null;

        if (reportArgs == null) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text(
                  'Report data is required.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ReportCubit>(
            create: (_) => sl<ReportCubit>(),
            child: ReportScreen(
              reportType: reportArgs.reportType,
              userId: reportArgs.userId,
              doctorId: reportArgs.doctorId,
              doctorName: reportArgs.doctorName,
              sessionId: reportArgs.sessionId,
            ),
          ),
        );

      case MyRoutes.reportHistoryScreen:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ReportCubit>(
            create: (_) => sl<ReportCubit>(),
            child: ReportHistoryScreen(userId: userId),
          ),
        );

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

class ReportScreenArgs {
  final ReportType reportType;
  final String userId;
  final String? doctorId;
  final String? doctorName;
  final String? sessionId;

  ReportScreenArgs({
    required this.reportType,
    required this.userId,
    this.doctorId,
    this.doctorName,
    this.sessionId,
  });
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
  static const String chatConversationScreen = "/chatConversationScreen";
  static const String homeScreen = "/homeScreens";
  static const String firstHomeScreen = "/firstHomeScreen";
  static const String doctorInfoScreen = "/doctorInfoScreen";
  static const String bookSessionScreen = "/bookSessionScreen";
  static const String paymentScreen = "/paymentScreen";
  static const String doctorsHomeScreen = "/doctorsHomeScreen";
  static const String appointmentsScreen = "/appointmentsScreen";
  static const String settingsScreen = "/settingsScreen";
  static const String medicalProfileScreen = "/medicalProfileScreen";
  static const String profileInfoScreen = "/profileInfoScreen";
  static const String reportIssueScreen = "/reportIssueScreen";
  static const String assignmentTestScreen = "/assignmentTestScreen";
  static const String assignmentResultScreen = "/assignmentResultScreen";
  // Report Screens
  static const String reportScreen = "/reportScreen";
  static const String reportHistoryScreen = "/reportHistoryScreen";
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_route.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/language_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'feature/articles/presentation/cubits/articles_cubit.dart';
import 'feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'feature/auth/presentation/cubits/auth_cubit.dart';
import 'feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'feature/chat/presentation/cubit/chat_cubit.dart';
import 'feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'feature/payment/presentation/cubit/payment_cubit.dart';
import 'feature/report/presentation/cubits/report_cubit.dart';
import 'feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'feature/settings/presentation/cubits/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  final themeCubit = await ThemeCubit.create();
  final languageCubit = await LanguageCubit.create();
  runApp(MyApp(themeCubit: themeCubit, languageCubit: languageCubit));
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;
  final LanguageCubit languageCubit;

  const MyApp({
    super.key,
    required this.themeCubit,
    required this.languageCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: themeCubit),
        BlocProvider<LanguageCubit>.value(value: languageCubit),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<AssignmentsCubit>(create: (_) => sl<AssignmentsCubit>()),
        BlocProvider<AppointmentsCubit>(create: (_) => sl<AppointmentsCubit>()),
        BlocProvider<DoctorsCubit>(create: (_) => sl<DoctorsCubit>()),
        BlocProvider<ChatCubit>(create: (_) => ChatCubit()),
        BlocProvider<PaymentCubit>(create: (_) => sl<PaymentCubit>()),
        BlocProvider<ReportCubit>(create: (_) => sl<ReportCubit>()),
        BlocProvider<SessionsCubit>(create: (_) => sl<SessionsCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
        BlocProvider<ArticlesCubit>(create: (_) => sl<ArticlesCubit>()),
      ],
      child: BlocListener<LanguageCubit, Locale>(
        listenWhen: (previous, current) =>
            previous.languageCode != current.languageCode,
        listener: (context, locale) {
          context.read<DoctorsCubit>().reloadCurrent();
          context.read<ArticlesCubit>().reloadCurrent();
          context.read<AppointmentsCubit>().loadAppointments();
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Afiete',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  locale: locale,
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  initialRoute: MyRoutes.splashScreen,
                  onGenerateRoute: AppRouter.generateRoute,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

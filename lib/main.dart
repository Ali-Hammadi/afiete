import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_route.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'feature/auth/presentation/cubits/auth_cubit.dart';
import 'feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'feature/payment/presentation/cubit/payment_cubit.dart';
import 'feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'feature/settings/presentation/cubits/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  final themeCubit = await ThemeCubit.create();
  runApp(MyApp(themeCubit: themeCubit));
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;

  const MyApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: themeCubit),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<AssignmentsCubit>(create: (_) => sl<AssignmentsCubit>()),
        BlocProvider<AppointmentsCubit>(create: (_) => sl<AppointmentsCubit>()),
        BlocProvider<DoctorsCubit>(create: (_) => sl<DoctorsCubit>()),
        BlocProvider<PaymentCubit>(create: (_) => sl<PaymentCubit>()),
        BlocProvider<SessionsCubit>(create: (_) => sl<SessionsCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Afiete',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: MyRoutes.homeScreen,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}

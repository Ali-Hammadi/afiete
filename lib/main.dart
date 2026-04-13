import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_route.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<AssignmentsCubit>(create: (_) => sl<AssignmentsCubit>()),
        BlocProvider<AppointmentsCubit>(create: (_) => sl<AppointmentsCubit>()),
        BlocProvider<DoctorsCubit>(create: (_) => sl<DoctorsCubit>()),
        BlocProvider<PaymentCubit>(create: (_) => sl<PaymentCubit>()),
        BlocProvider<SessionsCubit>(create: (_) => sl<SessionsCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Afiete',

        initialRoute: MyRoutes.homeScreen,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

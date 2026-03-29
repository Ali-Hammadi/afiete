import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_route.dart';
import 'feature/auth/presentation/cubits/auth_cubit.dart';

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
      providers: [BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Afiete',

        initialRoute: MyRoutes.homeScreen,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

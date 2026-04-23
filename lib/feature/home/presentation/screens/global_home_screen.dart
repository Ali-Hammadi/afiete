import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'package:afiete/feature/booking_assiments/presentation/screens/appointments_screen.dart';
import 'package:afiete/feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:afiete/feature/doctors/presentation/screens/doctors_home_screen.dart';
import 'package:afiete/feature/home/presentation/screens/first_home_screen.dart';
import 'package:afiete/feature/home/presentation/widgets/custom_app_bar.dart';
import 'package:afiete/feature/settings/presentation/screens/settings_screen.dart';
import 'package:afiete/feature/doctors/presentation/widgets/custom_find_doctors_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalHomeScreen extends StatefulWidget {
  const GlobalHomeScreen({super.key});

  @override
  State<GlobalHomeScreen> createState() => _GlobalHomeScreenState();
}

class _GlobalHomeScreenState extends State<GlobalHomeScreen> {
  int selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lightNavColor = colorScheme.onSurface.withValues(alpha: 0.72);

    return Scaffold(
      appBar: _appBarForIndex(selectedItemIndex),
      body: _bodyForIndex(selectedItemIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        currentIndex: selectedItemIndex,
        elevation: 0,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark ? colorScheme.outline : lightNavColor,
        onTap: (value) {
          setState(() {
            selectedItemIndex = value;
          });
        },
        iconSize: 28,
        backgroundColor: Theme.of(context).cardColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Doctors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBarForIndex(int index) {
    switch (index) {
      case 0:
        return const CustomAppBar();
      case 1:
        return const CustomFindDoctorsAppBar();
      case 2:
        return AppBar(title: const Text('Appointments'), centerTitle: true);
      case 3:
      default:
        return AppBar(title: const Text('Settings'), centerTitle: true);
    }
  }

  Widget _bodyForIndex(int index) {
    switch (index) {
      case 0:
        return const FirstHomeScreen();
      case 1:
        return BlocProvider<DoctorsCubit>(
          create: (_) => sl<DoctorsCubit>()..loadAllDoctors(),
          child: const DoctorsHomeScreen(),
        );
      case 2:
        return BlocProvider<AppointmentsCubit>(
          create: (_) => sl<AppointmentsCubit>()..loadAppointments(),
          child: const AppointmentsScreen(),
        );
      case 3:
      default:
        return const SettingsScreen();
    }
  }
}

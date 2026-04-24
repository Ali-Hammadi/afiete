import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/presentation/cubits/doctors_cubit.dart';

import 'package:afiete/feature/home/presentation/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTopDoctorsWidget extends StatefulWidget {
  const CustomTopDoctorsWidget({super.key});

  @override
  State<CustomTopDoctorsWidget> createState() => _CustomTopDoctorsWidgetState();
}

class _CustomTopDoctorsWidgetState extends State<CustomTopDoctorsWidget> {
  late final DoctorsCubit _doctorsCubit;

  @override
  void initState() {
    super.initState();
    _doctorsCubit = sl<DoctorsCubit>()..loadAllDoctors();
  }

  @override
  void dispose() {
    _doctorsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _doctorsCubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsLoading) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is DoctorsError) {
              return SizedBox(
                height: 180,
                child: Center(child: Text(state.message)),
              );
            }

            if (state is DoctorsLoaded) {
              final topDoctors = state.doctors.take(8).toList();

              if (topDoctors.isEmpty) {
                return SizedBox(
                  height: 180,
                  child: Center(
                    child: Text(SettingsStrings.noDoctorsAvailable),
                  ),
                );
              }

              return SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: topDoctors
                        .map((doctor) => CustomTopDoctorCard(doctor: doctor))
                        .toList(),
                  ),
                ),
              );
            }

            return const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}

class CustomTopDoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const CustomTopDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MyRoutes.doctorInfoScreen,
          arguments: doctor,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppStyles.padding / 2),
        child: Container(
          width: 120,
          padding: EdgeInsets.all(AppStyles.padding / 2),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary),
            color: theme.cardColor,
            borderRadius: BorderRadius.all(
              Radius.circular(AppStyles.borderRadius),
            ),
          ),
          child: Column(
            children: [
              CustomDoctorAvatar(imageUrl: doctor.imageUrl),
              const SizedBox(height: 12),
              Text(
                doctor.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                doctor.specialization,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

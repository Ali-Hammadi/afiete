import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/psychology_specialties.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsHomeScreen extends StatefulWidget {
  const DoctorsHomeScreen({super.key});

  @override
  State<DoctorsHomeScreen> createState() => _DoctorsHomeScreenState();
}

class _DoctorsHomeScreenState extends State<DoctorsHomeScreen> {
  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    context.read<DoctorsCubit>().loadAllDoctors();
  }

  void _selectSpecialty(String? specialty) {
    setState(() {
      selectedSpecialty = specialty;
    });

    if (specialty == null || specialty == PsychologySpecialties.all) {
      context.read<DoctorsCubit>().loadAllDoctors();
    } else {
      context.read<DoctorsCubit>().loadDoctorsBySpecialty(specialty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
                height: 40,
                width: double.infinity * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.unselectedFieldColor,
                  borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search),
                    Text("Search experts or specialist"),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.padding,
                vertical: AppStyles.padding / 2,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [..._buildSpecialtyChips()]),
              ),
            ),
            Expanded(
              child: BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorsError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is DoctorsLoaded) {
                    if (state.doctors.isEmpty) {
                      return const Center(child: Text('No doctors found.'));
                    }

                    return ListView.builder(
                      itemCount: state.doctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: state.doctors[index]);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSpecialtyChips() {
    final specialties = [
      PsychologySpecialties.all,
      PsychologySpecialties.psychiatrist,
      PsychologySpecialties.clinicalPsychologist,
      PsychologySpecialties.psychotherapist,
      PsychologySpecialties.cbtTherapist,
      PsychologySpecialties.psychoanalyst,
      PsychologySpecialties.counselor,
      PsychologySpecialties.traumaTherapist,
      PsychologySpecialties.marriageFamilyTherapist,
      PsychologySpecialties.psychiatricSocialWorker,
      PsychologySpecialties.speechLanguagePathologist,
      PsychologySpecialties.childPsychologist,
    ];

    return specialties
        .map(
          (specialty) => SpecialtyChip(
            label: specialty,
            isSelected: selectedSpecialty == specialty,
            onSelected: () => _selectSpecialty(specialty),
          ),
        )
        .toList();
  }
}

class SpecialtyChip extends StatelessWidget {
  const SpecialtyChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding * 0.5),
      child: GestureDetector(
        onTap: isSelected ? null : onSelected,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.all(
              Radius.circular(AppStyles.borderRadius),
            ),
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryFillColor,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

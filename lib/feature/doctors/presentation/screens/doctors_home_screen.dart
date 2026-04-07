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
  String searchQuery = '';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<DoctorsCubit>().loadAllDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  List<dynamic> _filterDoctors(List<dynamic> doctors) {
    if (searchQuery.isEmpty) {
      return doctors;
    }

    final query = searchQuery.toLowerCase();
    return doctors.where((doctor) {
      final name = doctor.name.toLowerCase();
      final specialization = doctor.specialization.toLowerCase();
      return name.contains(query) || specialization.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search experts or specialist',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.unselectedFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.padding,
                    vertical: AppStyles.padding / 2,
                  ),
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
            Flexible(
              child: BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorsError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is DoctorsLoaded) {
                    final filteredDoctors = _filterDoctors(state.doctors);

                    if (filteredDoctors.isEmpty) {
                      return Center(
                        child: Text(
                          searchQuery.isNotEmpty
                              ? 'No doctors match your search.'
                              : 'No doctors found.',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: filteredDoctors[index]);
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

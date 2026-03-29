import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/psychology_specialties.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class DoctorsHomeScreen extends StatefulWidget {
  const DoctorsHomeScreen({super.key});

  @override
  State<DoctorsHomeScreen> createState() => _DoctorsHomeScreenState();
}

class _DoctorsHomeScreenState extends State<DoctorsHomeScreen> {
  String? selectedSpecialty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search),
                    Text("Search experts or specialist"),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.padding,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SpecialtyChip(
                      label: PsychologySpecialties.all,
                      isSelected:
                          selectedSpecialty == PsychologySpecialties.all,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty = PsychologySpecialties.all;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.psychiatrist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.psychiatrist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.psychiatrist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.clinicalPsychologist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.clinicalPsychologist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.clinicalPsychologist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.psychotherapist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.psychotherapist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.psychotherapist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.cbtTherapist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.cbtTherapist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.cbtTherapist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.psychoanalyst,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.psychoanalyst,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.psychoanalyst;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.counselor,
                      isSelected:
                          selectedSpecialty == PsychologySpecialties.counselor,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty = PsychologySpecialties.counselor;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.traumaTherapist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.traumaTherapist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.traumaTherapist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.marriageFamilyTherapist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.marriageFamilyTherapist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.marriageFamilyTherapist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.psychiatricSocialWorker,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.psychiatricSocialWorker,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.psychiatricSocialWorker;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.speechLanguagePathologist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.speechLanguagePathologist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.speechLanguagePathologist;
                        });
                      },
                    ),
                    SpecialtyChip(
                      label: PsychologySpecialties.childPsychologist,
                      isSelected:
                          selectedSpecialty ==
                          PsychologySpecialties.childPsychologist,
                      onSelected: () {
                        setState(() {
                          selectedSpecialty =
                              PsychologySpecialties.childPsychologist;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryFillColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppStyles.borderRadius),
                  ),
                ),
                height: 200,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageLinks.man1),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Divider(),
                    Text("data"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

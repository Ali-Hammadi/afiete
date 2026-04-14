import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalProfileScreen extends StatelessWidget {
  const MedicalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthLoaded
        ? authState.user.id
        : authState is AuthProfileUpdated
        ? authState.user.id
        : '';

    return Scaffold(
      backgroundColor: AppColors.primarybackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primarybackgroundColor,
        elevation: 0,
        title: const Text('Medical Profile', style: AppStyles.headingMedium),
      ),
      body: BlocProvider<SettingsCubit>(
        create: (_) => sl<SettingsCubit>()..loadMedicalProfile(userId),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SettingsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppStyles.padding),
                  child: Text(state.message, style: AppStyles.bodyMedium),
                ),
              );
            }

            final profile = state is SettingsLoaded
                ? state.medicalProfile
                : const MedicalProfileEntity(prescriptions: [], notes: []);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                children: [
                  _SectionCard(
                    icon: Icons.medication_outlined,
                    title: 'Prescriptions',
                    footerAction: 'View All Prescriptions',
                    child: Column(
                      children: profile.prescriptions
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PrescriptionTile(item: item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    icon: Icons.note_alt_outlined,
                    title: 'Notes',
                    footerAction: 'View All Notes',
                    child: Column(
                      children: [
                        ...profile.notes.map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _NoteTile(note: note),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final String footerAction;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.footerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius - 2),
        border: Border.all(
          color: AppColors.unselectedFieldColor.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 30),
              const SizedBox(width: 10),
              Text(title, style: AppStyles.headingSmall),
            ],
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                footerAction,
                style: AppStyles.headingSmall.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionTile extends StatelessWidget {
  final MedicalPrescriptionEntity item;

  const _PrescriptionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryFillColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.medicine, style: AppStyles.headingSmall),
                const SizedBox(height: 4),
                Text(
                  '${item.dosage} • ${item.schedule}',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.primarytextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Next refill: ${item.nextRefill}',
                  style: AppStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ORAL',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final MedicalNoteEntity note;

  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryFillColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(note.title, style: AppStyles.headingSmall)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Edit',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(note.content, style: AppStyles.bodyMedium),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(note.updatedAt, style: AppStyles.bodySmall),
          ),
        ],
      ),
    );
  }
}

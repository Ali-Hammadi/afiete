import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:afiete/feature/settings/presentation/screens/note_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalProfileScreen extends StatelessWidget {
  const MedicalProfileScreen({super.key});

  static const List<ShareDoctorOption> _shareDoctors = [
    ShareDoctorOption(
      id: 'doc-101',
      name: 'Dr. Sarah Ali',
      specialization: 'Psychiatry',
    ),
    ShareDoctorOption(
      id: 'doc-202',
      name: 'Dr. Omar Hassan',
      specialization: 'Clinical Psychology',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthLoaded
        ? authState.user.id
        : authState is AuthProfileUpdated
        ? authState.user.id
        : '';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: const Text(
            SettingsStrings.medicalProfileTitle,
            style: AppStyles.headingMedium,
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
              child: TabBar(
                tabs: [
                  Tab(text: SettingsStrings.medicalTabPrescriptions),
                  Tab(text: SettingsStrings.medicalTabMedicine),
                  Tab(text: SettingsStrings.medicalTabNotes),
                ],
              ),
            ),
          ),
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

              return TabBarView(
                children: [
                  _PrescriptionsTab(profile: profile),
                  _MedicineTab(profile: profile),
                  _NotesTab(profile: profile, userId: userId),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PrescriptionsTab extends StatelessWidget {
  final MedicalProfileEntity profile;

  const _PrescriptionsTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: _SectionCard(
        icon: Icons.receipt_long_outlined,
        title: SettingsStrings.medicalTabPrescriptions,
        footerAction:
            '${SettingsStrings.totalLabel} ${profile.prescriptions.length}',
        footerEnabled: false,
        child: profile.prescriptions.isEmpty
            ? const _EmptySection(message: SettingsStrings.noPrescriptions)
            : Column(
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
    );
  }
}

class _MedicineTab extends StatelessWidget {
  final MedicalProfileEntity profile;

  const _MedicineTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    final items = profile.prescriptions;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: _SectionCard(
        icon: Icons.medication_liquid_outlined,
        title: SettingsStrings.medicalTabMedicine,
        footerAction: '${SettingsStrings.activeMedicinesLabel} ${items.length}',
        footerEnabled: false,
        child: items.isEmpty
            ? const _EmptySection(message: SettingsStrings.noMedicines)
            : Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MedicineTile(item: item),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _NotesTab extends StatelessWidget {
  final MedicalProfileEntity profile;
  final String userId;

  const _NotesTab({required this.profile, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: _SectionCard(
        icon: Icons.note_alt_outlined,
        title: SettingsStrings.medicalTabNotes,
        footerAction:
            '${SettingsStrings.totalNotesLabel} ${profile.notes.length}',
        footerEnabled: false,
        child: profile.notes.isEmpty
            ? const _EmptySection(message: SettingsStrings.noNotes)
            : Column(
                children: [
                  ...profile.notes.map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _NoteTile(
                        note: note,
                        userId: userId,
                        doctors: MedicalProfileScreen._shareDoctors,
                      ),
                    ),
                  ),
                ],
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
  final bool footerEnabled;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.footerAction,
    this.footerEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius - 2),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.18 : 0.06,
            ),
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
              Icon(icon, color: colorScheme.primary, size: 30),
              const SizedBox(width: 10),
              Text(title, style: AppStyles.headingSmall),
            ],
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: footerEnabled ? () {} : null,
              child: Text(
                footerAction,
                style: AppStyles.headingSmall.copyWith(
                  fontSize: 18,
                  color: colorScheme.primary,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${SettingsStrings.nextRefillLabel} ${item.nextRefill}',
                  style: AppStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              SettingsStrings.oral,
              style: AppStyles.bodySmall.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineTile extends StatelessWidget {
  final MedicalPrescriptionEntity item;

  const _MedicineTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medication, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.medicine, style: AppStyles.headingSmall),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${SettingsStrings.dosageLabel} ${item.dosage}',
            style: AppStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${SettingsStrings.scheduleLabel} ${item.schedule}',
            style: AppStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${SettingsStrings.refillLabel} ${item.nextRefill}',
            style: AppStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text(message, style: AppStyles.bodyMedium)),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final MedicalNoteEntity note;
  final String userId;
  final List<ShareDoctorOption> doctors;

  const _NoteTile({
    required this.note,
    required this.userId,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(note.title, style: AppStyles.headingSmall)),
              _ActionChip(
                label: SettingsStrings.editNote,
                colorScheme: colorScheme,
                onTap: () => _openDetails(context),
              ),
              const SizedBox(width: 8),
              _ActionChip(
                label: SettingsStrings.shareNote,
                colorScheme: colorScheme,
                onTap: () => _openDetails(context),
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

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SettingsCubit>(),
          child: NoteDetailsScreen(
            note: note,
            userId: userId,
            doctors: doctors,
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppStyles.bodySmall.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareDoctorOption {
  final String id;
  final String name;
  final String specialization;

  const ShareDoctorOption({
    required this.id,
    required this.name,
    required this.specialization,
  });
}

class NoteDetailsScreen extends StatefulWidget {
  final MedicalNoteEntity note;
  final String userId;
  final List<ShareDoctorOption> doctors;

  const NoteDetailsScreen({
    super.key,
    required this.note,
    required this.userId,
    required this.doctors,
  });

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  ShareDoctorOption? _selectedDoctor;
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          SettingsStrings.editMedicalNoteTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: SettingsStrings.noteTitleLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: SettingsStrings.noteContentLabel,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(widget.note.updatedAt, style: AppStyles.bodySmall),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _saveChanges,
                child: _isSaving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        SettingsStrings.saveChanges,
                        style: AppStyles.bodyMedium.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              SettingsStrings.shareWithDoctorTitle,
              style: AppStyles.headingSmall,
            ),
            const SizedBox(height: 10),
            RadioGroup<ShareDoctorOption>(
              groupValue: _selectedDoctor,
              onChanged: (value) {
                setState(() {
                  _selectedDoctor = value;
                });
              },
              child: Column(
                children: [
                  ...widget.doctors.map(
                    (doctor) => RadioListTile<ShareDoctorOption>(
                      contentPadding: EdgeInsets.zero,
                      value: doctor,
                      title: Text(doctor.name),
                      subtitle: Text(doctor.specialization),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSharing ? null : _shareNote,
                child: _isSharing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        SettingsStrings.shareNow,
                        style: AppStyles.bodyMedium.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    final message = await context.read<SettingsCubit>().updateMedicalNote(
      userId: widget.userId,
      noteTitle: widget.note.title,
      previousUpdatedAt: widget.note.updatedAt,
      newTitle: _titleController.text.trim(),
      newContent: _contentController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (message == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(SettingsStrings.noteUpdatedSuccess)),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _shareNote() async {
    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(SettingsStrings.selectDoctorError)),
      );
      return;
    }

    setState(() {
      _isSharing = true;
    });

    final message = await context
        .read<SettingsCubit>()
        .shareMedicalNoteWithDoctor(
          userId: widget.userId,
          noteTitle: _titleController.text.trim(),
          noteContent: _contentController.text.trim(),
          doctorId: _selectedDoctor!.id,
        );

    if (!mounted) return;

    setState(() {
      _isSharing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

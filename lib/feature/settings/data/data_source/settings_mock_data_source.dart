import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/feature/settings/data/data_source/settings_remote_data_source.dart';
import 'package:afiete/feature/settings/data/models/medical_profile_model.dart';

class SettingsMockDataSourceImpl implements SettingsRemoteDataSource {
  final List<MedicalPrescriptionModel> _prescriptions = const [
    MedicalPrescriptionModel(
      prescriptionNumber: 'AF-RX-2026-000001',
      medicine: 'Sertraline',
      dosage: '50mg',
      schedule: 'Once daily after breakfast',
      nextRefill: '2026-05-15',
      documentType: 'Prescription',
      doctorName: 'Dr. Sarah Ali',
      capturedAt: '2026-04-12',
      imagePath: ImageLinks.prescription,
    ),
    MedicalPrescriptionModel(
      prescriptionNumber: 'AF-RX-2026-000002',
      medicine: 'Escitalopram',
      dosage: '10mg',
      schedule: 'Once daily in the morning',
      nextRefill: '2026-05-10',
      documentType: 'Session Report',
      doctorName: 'Dr. Omar Hassan',
      capturedAt: '2026-04-14',
      imagePath: ImageLinks.prescription2,
    ),
    MedicalPrescriptionModel(
      prescriptionNumber: 'AF-RX-2026-000003',
      medicine: 'Magnesium Glycinate',
      dosage: '200mg',
      schedule: 'At night before sleep',
      nextRefill: '2026-05-18',
      documentType: 'Prescription',
      doctorName: 'Dr. Sarah Ali',
      capturedAt: '2026-04-16',
      imagePath: ImageLinks.prescription,
    ),
    MedicalPrescriptionModel(
      prescriptionNumber: 'AF-RX-2026-000004',
      medicine: 'Omega-3',
      dosage: '1000mg',
      schedule: 'Twice daily with meals',
      nextRefill: '2026-05-22',
      documentType: 'Session Report',
      doctorName: 'Dr. Omar Hassan',
      capturedAt: '2026-04-18',
      imagePath: ImageLinks.prescription2,
    ),
  ];

  List<MedicalNoteModel> _notes = const [
    MedicalNoteModel(
      title: 'Therapy Progress',
      content: 'Patient reports improved sleep and fewer panic episodes.',
      updatedAt: '2026-04-10',
    ),
    MedicalNoteModel(
      title: 'Lifestyle Recommendation',
      content: '30 minutes walking 5 days/week and reduce caffeine intake.',
      updatedAt: '2026-04-12',
    ),
    MedicalNoteModel(
      title: 'Follow-up Plan',
      content:
          'Continue current medication for 6 weeks then reassess anxiety score.',
      updatedAt: '2026-04-14',
    ),
    MedicalNoteModel(
      title: 'Sleep Hygiene',
      content:
          'Avoid screens 1 hour before bedtime and maintain fixed sleep schedule.',
      updatedAt: '2026-04-15',
    ),
  ];

  @override
  Future<MedicalProfileModel> getMedicalProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    return MedicalProfileModel(prescriptions: _prescriptions, notes: _notes);
  }

  @override
  Future<MedicalProfileModel> updateMedicalNote({
    required String userId,
    required String noteTitle,
    required String previousUpdatedAt,
    required String newTitle,
    required String newContent,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final index = _notes.indexWhere(
      (note) => note.title == noteTitle && note.updatedAt == previousUpdatedAt,
    );

    if (index == -1) {
      throw Exception('Note not found in mock data.');
    }

    _notes = List<MedicalNoteModel>.from(_notes)
      ..[index] = MedicalNoteModel(
        title: newTitle,
        content: newContent,
        updatedAt: '2026-04-16',
      );

    return MedicalProfileModel(prescriptions: _prescriptions, notes: _notes);
  }

  @override
  Future<String> shareMedicalNoteWithDoctor({
    required String userId,
    required String noteTitle,
    required String noteContent,
    required String doctorId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return 'Note "$noteTitle" shared with doctor ($doctorId) successfully.';
  }

  @override
  Future<String> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return 'Report submitted successfully (mock).';
  }
}

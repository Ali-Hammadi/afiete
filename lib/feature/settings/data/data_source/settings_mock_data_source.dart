import 'package:afiete/feature/settings/data/data_source/settings_remote_data_source.dart';
import 'package:afiete/feature/settings/data/models/medical_profile_model.dart';

class SettingsMockDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<MedicalProfileModel> getMedicalProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    return const MedicalProfileModel(
      prescriptions: [
        MedicalPrescriptionModel(
          medicine: 'Sertraline',
          dosage: '50mg',
          schedule: 'Once daily after breakfast',
          nextRefill: '2026-05-15',
        ),
        MedicalPrescriptionModel(
          medicine: 'Magnesium',
          dosage: '200mg',
          schedule: 'At night',
          nextRefill: '2026-05-10',
        ),
      ],
      notes: [
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
      ],
    );
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

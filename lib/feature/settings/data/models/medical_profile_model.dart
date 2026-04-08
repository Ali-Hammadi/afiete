import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:equatable/equatable.dart';

class MedicalPrescriptionModel extends Equatable {
  final String medicine;
  final String dosage;
  final String schedule;
  final String nextRefill;

  const MedicalPrescriptionModel({
    required this.medicine,
    required this.dosage,
    required this.schedule,
    required this.nextRefill,
  });

  factory MedicalPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MedicalPrescriptionModel(
      medicine: json['medicine'] ?? json['name'] ?? '',
      dosage: json['dosage'] ?? json['amount'] ?? '',
      schedule: json['schedule'] ?? json['timing'] ?? '',
      nextRefill: json['nextRefill'] ?? json['next_refill'] ?? '',
    );
  }

  MedicalPrescriptionEntity toEntity() => MedicalPrescriptionEntity(
    medicine: medicine,
    dosage: dosage,
    schedule: schedule,
    nextRefill: nextRefill,
  );

  @override
  List<Object?> get props => [medicine, dosage, schedule, nextRefill];
}

class MedicalNoteModel extends Equatable {
  final String title;
  final String content;
  final String updatedAt;

  const MedicalNoteModel({
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory MedicalNoteModel.fromJson(Map<String, dynamic> json) {
    return MedicalNoteModel(
      title: json['title'] ?? '',
      content: json['content'] ?? json['note'] ?? '',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '',
    );
  }

  MedicalNoteEntity toEntity() =>
      MedicalNoteEntity(title: title, content: content, updatedAt: updatedAt);

  @override
  List<Object?> get props => [title, content, updatedAt];
}

class MedicalProfileModel extends Equatable {
  final List<MedicalPrescriptionModel> prescriptions;
  final List<MedicalNoteModel> notes;

  const MedicalProfileModel({required this.prescriptions, required this.notes});

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    final prescriptionsJson = (json['prescriptions'] as List<dynamic>?) ?? [];
    final notesJson = (json['notes'] as List<dynamic>?) ?? [];

    return MedicalProfileModel(
      prescriptions: prescriptionsJson
          .map((item) => MedicalPrescriptionModel.fromJson(item))
          .toList(),
      notes: notesJson.map((item) => MedicalNoteModel.fromJson(item)).toList(),
    );
  }

  MedicalProfileEntity toEntity() => MedicalProfileEntity(
    prescriptions: prescriptions.map((item) => item.toEntity()).toList(),
    notes: notes.map((item) => item.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [prescriptions, notes];
}

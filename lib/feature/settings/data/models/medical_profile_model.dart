import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:equatable/equatable.dart';

class MedicalPrescriptionModel extends Equatable {
  final String prescriptionNumber;
  final String medicine;
  final String dosage;
  final String schedule;
  final String nextRefill;
  final String documentType;
  final String doctorName;
  final String capturedAt;
  final String imagePath;

  const MedicalPrescriptionModel({
    this.prescriptionNumber = '',
    required this.medicine,
    required this.dosage,
    required this.schedule,
    required this.nextRefill,
    this.documentType = '',
    this.doctorName = '',
    this.capturedAt = '',
    this.imagePath = '',
  });

  factory MedicalPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MedicalPrescriptionModel(
      prescriptionNumber:
          json['prescriptionNumber'] ??
          json['prescription_number'] ??
          json['id'] ??
          '',
      medicine: json['medicine'] ?? json['name'] ?? '',
      dosage: json['dosage'] ?? json['amount'] ?? '',
      schedule: json['schedule'] ?? json['timing'] ?? '',
      nextRefill: json['nextRefill'] ?? json['next_refill'] ?? '',
      documentType: json['documentType'] ?? json['document_type'] ?? '',
      doctorName: json['doctorName'] ?? json['doctor_name'] ?? '',
      capturedAt: json['capturedAt'] ?? json['captured_at'] ?? '',
      imagePath: json['imagePath'] ?? json['image_path'] ?? '',
    );
  }

  MedicalPrescriptionEntity toEntity() => MedicalPrescriptionEntity(
    prescriptionNumber: prescriptionNumber,
    medicine: medicine,
    dosage: dosage,
    schedule: schedule,
    nextRefill: nextRefill,
    documentType: documentType,
    doctorName: doctorName,
    capturedAt: capturedAt,
    imagePath: imagePath,
  );

  @override
  List<Object?> get props => [
    prescriptionNumber,
    medicine,
    dosage,
    schedule,
    nextRefill,
    documentType,
    doctorName,
    capturedAt,
    imagePath,
  ];
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

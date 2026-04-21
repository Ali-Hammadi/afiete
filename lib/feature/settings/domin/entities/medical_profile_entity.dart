import 'package:equatable/equatable.dart';

class MedicalPrescriptionEntity extends Equatable {
  final String prescriptionNumber;
  final String medicine;
  final String dosage;
  final String schedule;
  final String nextRefill;
  final String documentType;
  final String doctorName;
  final String capturedAt;
  final String imagePath;

  const MedicalPrescriptionEntity({
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

class MedicalNoteEntity extends Equatable {
  final String title;
  final String content;
  final String updatedAt;

  const MedicalNoteEntity({
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [title, content, updatedAt];
}

class MedicalProfileEntity extends Equatable {
  final List<MedicalPrescriptionEntity> prescriptions;
  final List<MedicalNoteEntity> notes;

  const MedicalProfileEntity({
    required this.prescriptions,
    required this.notes,
  });

  @override
  List<Object?> get props => [prescriptions, notes];
}

import 'package:equatable/equatable.dart';

class MedicalPrescriptionEntity extends Equatable {
  final String medicine;
  final String dosage;
  final String schedule;
  final String nextRefill;

  const MedicalPrescriptionEntity({
    required this.medicine,
    required this.dosage,
    required this.schedule,
    required this.nextRefill,
  });

  @override
  List<Object?> get props => [medicine, dosage, schedule, nextRefill];
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

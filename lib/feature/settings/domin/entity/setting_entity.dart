import 'package:equatable/equatable.dart';

class UserSettingsProfileEntity extends Equatable {
  final String nickName;
  final String userId;
  final String email;
  final String phoneNumber;
  final String gender;
  final int age;

  const UserSettingsProfileEntity({
    required this.nickName,
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props => [
    nickName,
    userId,
    email,
    phoneNumber,
    gender,
    age,
  ];
}

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

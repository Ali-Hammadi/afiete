import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/data/datasources/doctors_remote_datasource.dart';
import 'package:afiete/feature/doctors/data/models/doctor_model.dart';

class DoctorsMockDataSourceImpl implements DoctorsRemoteDataSource {
  late final List<DoctorModel> _doctors = _seedDoctors();

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return List<DoctorModel>.from(_doctors);
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final lower = specialty.toLowerCase();
    return _doctors
        .where((doctor) => doctor.specialization.toLowerCase() == lower)
        .toList();
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _doctors.firstWhere(
      (doctor) => doctor.id == id,
      orElse: () => _doctors.first,
    );
  }

  List<DoctorModel> _seedDoctors() {
    final now = DateTime.now();
    return [
      DoctorModel(
        id: 'doc_1',
        name: 'Dr. Ahmed Ali',
        specialization: 'Psychiatrist',
        experience: '7 years',
        rating: '4.8',
        imageUrl: '',
        description:
            'Specialized in anxiety and mood disorders with evidence-based care.',
        isOnline: true,
        ratingValue: 4.8,
        createdAt: now,
        availableTimes: [
          now.add(const Duration(days: 1, hours: 10)),
          now.add(const Duration(days: 1, hours: 13)),
          now.add(const Duration(days: 2, hours: 9)),
          now.add(const Duration(days: 2, hours: 12)),
        ],
        availableDurations: const [1, 2],
        availableSessionTypes: const ['video_call', 'voice_call', 'text_chat'],
        consultationFee: const ConsultationFee(
          textChat: 10,
          videoCall: 20,
          voiceCall: 15,
        ),
      ),
      DoctorModel(
        id: 'doc_2',
        name: 'Dr. Sara Ibrahim',
        specialization: 'Psychotherapist',
        experience: '5 years',
        rating: '4.7',
        imageUrl: '',
        description: 'Focused on trauma-informed therapy and CBT techniques.',
        isOnline: true,
        ratingValue: 4.7,
        createdAt: now,
        availableTimes: [
          now.add(const Duration(days: 1, hours: 15)),
          now.add(const Duration(days: 3, hours: 11)),
          now.add(const Duration(days: 3, hours: 14)),
        ],
        availableDurations: const [1, 2],
        availableSessionTypes: const ['video_call', 'text_chat'],
        consultationFee: const ConsultationFee(
          textChat: 8,
          videoCall: 18,
          voiceCall: 0,
        ),
      ),
      DoctorModel(
        id: 'doc_3',
        name: 'Dr. Mariam Nasser',
        specialization: 'Clinical Psychologist',
        experience: '10 years',
        rating: '4.9',
        imageUrl: '',
        description:
            'Experienced in depression, burnout and emotional resilience.',
        isOnline: false,
        ratingValue: 4.9,
        createdAt: now,
        availableTimes: [
          now.add(const Duration(days: 2, hours: 16)),
          now.add(const Duration(days: 4, hours: 10)),
        ],
        availableDurations: const [2],
        availableSessionTypes: const ['voice_call', 'video_call'],
        consultationFee: const ConsultationFee(
          textChat: 0,
          videoCall: 25,
          voiceCall: 20,
        ),
      ),
    ];
  }
}

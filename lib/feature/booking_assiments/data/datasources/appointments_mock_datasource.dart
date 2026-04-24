import 'package:afiete/feature/booking_assiments/data/models/appointment_model.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_remote_datasource.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';

class AppointmentsMockDataSourceImpl implements AppointmentsRemoteDataSource {
  final List<AppointmentModel> _appointments = [
    AppointmentModel(
      id: 'apt_1',
      doctorId: 'doc_001',
      patientId: 'pat_1',
      doctorName: 'Dr. Ahmed Malik',
      scheduledAt: DateTime.now().add(const Duration(days: 1, hours: 2)),
      durationSlots: 2,
      consultationFee: const ConsultationFee(
        textChat: 15,
        videoCall: 40,
        voiceCall: 25,
      ),
      sessionType: 'video_call',
      status: 'pending_confirmation',
      requiresPayment: true,
    ),
    AppointmentModel(
      id: 'apt_2',
      doctorId: 'doc_002',
      patientId: 'pat_1',
      doctorName: 'Dr. Fatima Zahra',
      scheduledAt: DateTime.now().add(const Duration(days: 3, hours: 1)),
      durationSlots: 1,
      consultationFee: const ConsultationFee(
        textChat: 10,
        videoCall: 30,
        voiceCall: 20,
      ),
      sessionType: 'text_chat',
      status: 'confirmed',
      requiresPayment: false,
    ),
  ];

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<AppointmentModel>.from(_appointments)
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String patientId,
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final created = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      patientId: patientId,
      doctorName: doctorName,
      scheduledAt: scheduledAt,
      durationSlots: durationSlots,
      consultationFee: consultationFee,
      sessionType: sessionType,
      status: 'draft',
      requiresPayment: true,
    );

    _appointments.add(created);
    return created;
  }
}

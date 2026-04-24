import 'package:afiete/feature/booking_assiments/data/models/appointment_model.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_remote_datasource.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';

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
    AppointmentModel(
      id: 'apt_3',
      doctorId: 'doc_003',
      patientId: 'pat_1',
      doctorName: 'Dr. Mohammed Hassan',
      scheduledAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      durationSlots: 2,
      consultationFee: const ConsultationFee(
        textChat: 20,
        videoCall: 45,
        voiceCall: 30,
      ),
      sessionType: 'voice_call',
      status: 'completed',
      requiresPayment: false,
    ),
    AppointmentModel(
      id: 'apt_4',
      doctorId: 'doc_005',
      patientId: 'pat_1',
      doctorName: 'Dr. Sarah Ali',
      scheduledAt: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      durationSlots: 1,
      consultationFee: const ConsultationFee(
        textChat: 18,
        videoCall: 35,
        voiceCall: 22,
      ),
      sessionType: 'video_call',
      status: 'completed',
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

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _appointments.removeWhere((appointment) => appointment.id == appointmentId);
  }

  @override
  Future<AppointmentModel> rescheduleAppointment({
    required String appointmentId,
    required DateTime newScheduledAt,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final index = _appointments.indexWhere(
      (appointment) => appointment.id == appointmentId,
    );
    if (index < 0) {
      throw Exception('Appointment not found');
    }

    final current = _appointments[index];
    final doctor = MockDoctorsData.getMockDoctorById(current.doctorId);
    final availableTimes = doctor == null
        ? <DateTime>[]
        : List<DateTime>.from(
            (doctor['availableTimes'] as List<dynamic>? ?? const []).map(
              (time) => DateTime.parse(time.toString()),
            ),
          );

    final chosenTime = _pickBestTime(
      requestedTime: newScheduledAt,
      availableTimes: availableTimes,
    );

    final updated = AppointmentModel(
      id: current.id,
      doctorId: current.doctorId,
      patientId: current.patientId,
      doctorName: current.doctorName,
      scheduledAt: chosenTime,
      durationSlots: current.durationSlots,
      consultationFee: current.consultationFee,
      sessionType: current.sessionType,
      status: 'rescheduled',
      requiresPayment: current.requiresPayment,
    );
    _appointments[index] = updated;
    return updated;
  }

  DateTime _pickBestTime({
    required DateTime requestedTime,
    required List<DateTime> availableTimes,
  }) {
    final now = DateTime.now();
    final futureTimes =
        availableTimes.where((time) => time.isAfter(now)).toList()..sort();

    for (final time in futureTimes) {
      if (time.isAfter(requestedTime)) {
        return time;
      }
    }

    if (futureTimes.isNotEmpty) {
      return futureTimes.first;
    }

    return requestedTime.isAfter(now)
        ? requestedTime
        : now.add(const Duration(days: 1));
  }
}

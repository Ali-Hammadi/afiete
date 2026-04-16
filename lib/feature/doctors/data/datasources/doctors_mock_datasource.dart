import 'package:afiete/feature/doctors/data/datasources/doctors_remote_datasource.dart';
import 'package:afiete/feature/doctors/data/models/doctor_model.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';

class DoctorsMockDataSourceImpl implements DoctorsRemoteDataSource {
  late final List<DoctorModel> _doctors = MockDoctorsData.getMockDoctors()
      .map((json) => DoctorModel.fromJson(json))
      .toList();

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
}

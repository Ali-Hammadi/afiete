import 'package:afiete/core/constants/settings_strings.dart';

class MockReportData {
  // Mock report reasons (predefined for doctor and session reports)
  static List<Map<String, dynamic>> get mockDoctorReportReasons => [
    {
      'id': 'reason_001',
      'key': 'unprofessional',
      'label': SettingsStrings.unprofessionalBehavior,
      'icon': 'warning',
      'color': 'orange',
    },
    {
      'id': 'reason_002',
      'key': 'harassment',
      'label': SettingsStrings.harassment,
      'icon': 'block',
      'color': 'red',
    },
    {
      'id': 'reason_003',
      'key': 'inappropriateContent',
      'label': SettingsStrings.inappropriateContent,
      'icon': 'error',
      'color': 'red',
    },
    {
      'id': 'reason_004',
      'key': 'missingAppointment',
      'label': SettingsStrings.missingAppointments,
      'icon': 'schedule',
      'color': 'orange',
    },
  ];

  // Mock app report reasons
  static List<Map<String, dynamic>> get mockAppReportReasons => [
    {
      'id': 'reason_005',
      'key': 'appBug',
      'label': SettingsStrings.appBugOrIssue,
      'icon': 'bug_report',
      'color': 'red',
    },
    {
      'id': 'reason_006',
      'key': 'crashOrFreeze',
      'label': SettingsStrings.appCrashesOrFreezes,
      'icon': 'close',
      'color': 'red',
    },
    {
      'id': 'reason_007',
      'key': 'paymentIssue',
      'label': SettingsStrings.paymentOrTransactionIssue,
      'icon': 'payment',
      'color': 'orange',
    },
    {
      'id': 'reason_008',
      'key': 'other',
      'label': SettingsStrings.otherIssue,
      'icon': 'help',
      'color': 'gray',
    },
  ];

  // Mock submitted reports
  static const List<Map<String, dynamic>> mockReports = [
    {
      'id': 'report_001',
      'userId': 'user_001',
      'reportType': 'doctor',
      'targetId': 'doc_003',
      'targetName': 'Dr. Mohammed Hassan',
      'reason': 'missingAppointment',
      'description':
          'Doctor missed the scheduled appointment on April 15 without any prior notice. This is the second time this happened.',
      'status': 'reviewed',
      'createdAt': '2024-04-17T10:30:00Z',
      'resolvedAt': '2024-04-18T14:00:00Z',
    },
    {
      'id': 'report_002',
      'userId': 'user_002',
      'reportType': 'doctor',
      'targetId': 'doc_006',
      'targetName': 'Dr. Omar Taha',
      'reason': 'unprofessional',
      'description':
          'Doctor was dismissive of my concerns and made me feel uncomfortable during the session.',
      'status': 'pending',
      'createdAt': '2024-04-19T15:45:00Z',
      'resolvedAt': null,
    },
    {
      'id': 'report_003',
      'userId': 'user_001',
      'reportType': 'app',
      'targetId': null,
      'targetName': null,
      'reason': 'appBug',
      'description':
          'Video call feature crashes when trying to end the call. Need to force close the app.',
      'status': 'reviewed',
      'createdAt': '2024-04-15T11:20:00Z',
      'resolvedAt': '2024-04-16T09:00:00Z',
    },
    {
      'id': 'report_004',
      'userId': 'user_003',
      'reportType': 'app',
      'targetId': null,
      'targetName': null,
      'reason': 'paymentIssue',
      'description':
          'Charged twice for the same appointment. Please refund the duplicate charge.',
      'status': 'resolved',
      'createdAt': '2024-04-14T13:15:00Z',
      'resolvedAt': '2024-04-15T16:30:00Z',
    },
    {
      'id': 'report_005',
      'userId': 'user_002',
      'reportType': 'doctor',
      'targetId': 'doc_004',
      'targetName': 'Dr. Leila Mansour',
      'reason': 'harassment',
      'description':
          'Doctor made inappropriate personal comments that made me feel uncomfortable.',
      'status': 'pending',
      'createdAt': '2024-04-19T09:00:00Z',
      'resolvedAt': null,
    },
  ];

  static List<Map<String, dynamic>> getMockDoctorReportReasons() =>
      mockDoctorReportReasons;

  static List<Map<String, dynamic>> getMockAppReportReasons() =>
      mockAppReportReasons;

  static List<Map<String, dynamic>> getMockReports() => mockReports;

  static List<Map<String, dynamic>> getMockReportsByUserId(String userId) {
    return mockReports.where((report) => report['userId'] == userId).toList();
  }

  static List<Map<String, dynamic>> getMockReportsByType(
    String userId,
    String reportType,
  ) {
    return mockReports
        .where(
          (report) =>
              report['userId'] == userId && report['reportType'] == reportType,
        )
        .toList();
  }

  static List<Map<String, dynamic>> getMockReportsByStatus(
    String userId,
    String status,
  ) {
    return mockReports
        .where(
          (report) => report['userId'] == userId && report['status'] == status,
        )
        .toList();
  }

  static Map<String, dynamic>? getMockReportById(String id) {
    try {
      return mockReports.firstWhere((report) => report['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static int getPendingReportCountForUser(String userId) {
    return mockReports
        .where(
          (report) =>
              report['userId'] == userId && report['status'] == 'pending',
        )
        .length;
  }
}

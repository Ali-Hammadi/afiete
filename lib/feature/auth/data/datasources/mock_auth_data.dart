import 'package:afiete/feature/auth/data/models/user_model.dart';

class MockAuthData {
  // Mock user accounts for testing
  static const List<Map<String, dynamic>> mockUsers = [
    {
      'id': 'user_001',
      'name': 'Ahmed Ali',
      'email': 'ahmed.ali@example.com',
      'password': 'password123',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlcl8wMDEifQ.mock_token_001',
      'birthDate': '1995-05-15',
      'age': 29,
      'gender': 'Male',
      'phoneNumber': '+966501234567',
    },
    {
      'id': 'user_002',
      'name': 'Fatima Hassan',
      'email': 'fatima.hassan@example.com',
      'password': 'password123',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlcl8wMDIifQ.mock_token_002',
      'birthDate': '1998-03-22',
      'age': 26,
      'gender': 'Female',
      'phoneNumber': '+966502345678',
    },
    {
      'id': 'user_003',
      'name': 'Mohammed Saeed',
      'email': 'mohammed.saeed@example.com',
      'password': 'password123',
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlcl8wMDMifQ.mock_token_003',
      'birthDate': '1992-08-10',
      'age': 32,
      'gender': 'Male',
      'phoneNumber': '+966503456789',
    },
  ];

  // Get mock user by email
  static UserModel? getMockUserByEmail(String email) {
    try {
      final userJson = mockUsers.firstWhere((user) => user['email'] == email);
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  // Get all mock users as UserModel list
  static List<UserModel> getAllMockUsers() {
    return mockUsers.map((json) => UserModel.fromJson(json)).toList();
  }

  // Get mock user by ID
  static UserModel? getMockUserById(String id) {
    try {
      final userJson = mockUsers.firstWhere((user) => user['id'] == id);
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }
}

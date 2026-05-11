import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user_entity.dart';

/// Data model for User, obtained from backend API responses.
/// Handles JSON deserialization with proper null/field handling.
/// Converts to [UserAuthEntity] domain entity via [toEntity()].
class UserModel extends Equatable {
  final String id;
  final String username;
  final String? nickname;
  final String email;
  final String? dateOfBirth; // ISO 8601 format (birth_date from backend)
  final String? age;
  final String? gender;
  final String? phoneNumber; // Maps to 'phone' from backend
  final String? psychologicalHistory;
  final bool isVerified;
  final String? profileImageUrl;
  final String? accessToken;
  final String? refreshToken;

  const UserModel({
    required this.id,
    required this.username,
    this.nickname,
    required this.email,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.phoneNumber,
    this.psychologicalHistory,
    required this.isVerified,
    this.profileImageUrl,
    this.accessToken,
    this.refreshToken,
  });

  /// Parse JSON response from backend.
  /// Handles both snake_case (backend) and camelCase (legacy) field names.
  /// Also supports responses wrapped in a top-level `data` object.
  /// Backend response can have user data nested in 'user' object or at root.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rootPayload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final payload = rootPayload['user'] is Map<String, dynamic>
        ? rootPayload['user'] as Map<String, dynamic>
        : rootPayload;

    final tokens = rootPayload['tokens'] is Map<String, dynamic>
        ? rootPayload['tokens'] as Map<String, dynamic>
        : (json['tokens'] is Map<String, dynamic>
              ? json['tokens'] as Map<String, dynamic>
              : const <String, dynamic>{});

    final accessToken =
        payload['access_token'] ??
        payload['accessToken'] ??
        payload['access'] ??
        rootPayload['access_token'] ??
        rootPayload['accessToken'] ??
        rootPayload['access'] ??
        json['access_token'] ??
        json['accessToken'] ??
        json['access'] ??
        tokens['access_token'] ??
        tokens['accessToken'] ??
        tokens['access'];

    final refreshToken =
        payload['refresh_token'] ??
        payload['refreshToken'] ??
        payload['refresh'] ??
        rootPayload['refresh_token'] ??
        rootPayload['refreshToken'] ??
        rootPayload['refresh'] ??
        json['refresh_token'] ??
        json['refreshToken'] ??
        json['refresh'] ??
        tokens['refresh_token'] ??
        tokens['refreshToken'] ??
        tokens['refresh'];

    // Extract nickname from root or payload
    final nickname = rootPayload['nickname'] ?? payload['nickname'];

    // Extract psychological_history from root (not nested in user)
    final psychologicalHistory = rootPayload['psychological_history'];

    return UserModel(
      id: payload['id'] ?? payload['user_id'] ?? '',
      username: payload['username'] ?? '',
      nickname: nickname,
      email: payload['email'] ?? '',
      dateOfBirth:
          payload['birth_date'] ??
          payload['date_of_birth'] ??
          payload['dateOfBirth'],
      age: payload['age']?.toString(),
      gender: payload['gender'],
      phoneNumber:
          payload['phone'] ?? payload['phone_number'] ?? payload['phoneNumber'],
      psychologicalHistory: psychologicalHistory,
      isVerified: payload['is_verified'] ?? payload['isVerified'] ?? false,
      profileImageUrl:
          payload['profile_image_url'] ?? payload['profileImageUrl'],
      accessToken: accessToken?.toString(),
      refreshToken: refreshToken?.toString(),
    );
  }

  /// Convert model to JSON for API requests.
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'nickname': nickname,
    'email': email,
    'birth_date': dateOfBirth,
    'age': age,
    'gender': gender,
    'phone': phoneNumber,
    'psychological_history': psychologicalHistory,
    'is_verified': isVerified,
    'profile_image_url': profileImageUrl,
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };

  /// Convert data model to domain entity.
  UserAuthEntity toEntity() => UserAuthEntity(
    username: username,
    nickname: nickname,
    email: email,
    birthDate: dateOfBirth != null ? DateTime.tryParse(dateOfBirth!) : null,
    gender: gender,
    phoneNumber: phoneNumber,
    isVerified: isVerified,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  UserModel copyWith({
    String? id,
    String? username,
    String? nickname,
    String? email,
    String? dateOfBirth,
    String? age,
    String? gender,
    String? phoneNumber,
    String? psychologicalHistory,
    bool? isVerified,
    String? profileImageUrl,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      psychologicalHistory: psychologicalHistory ?? this.psychologicalHistory,
      isVerified: isVerified ?? this.isVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    nickname,
    email,
    dateOfBirth,
    age,
    gender,
    phoneNumber,
    psychologicalHistory,
    isVerified,
    profileImageUrl,
    accessToken,
    refreshToken,
  ];
}

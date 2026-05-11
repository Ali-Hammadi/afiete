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
  final String? dateOfBirth; // ISO 8601 format
  final String? gender;
  final String? phoneNumber;
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
    this.gender,
    this.phoneNumber,
    required this.isVerified,
    this.profileImageUrl,
    this.accessToken,
    this.refreshToken,
  });

  /// Parse JSON response from backend.
  /// Handles both snake_case (backend) and camelCase (legacy) field names.
  /// Also supports responses wrapped in a top-level `data` object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserModel(
      id: payload['id'] ?? payload['user_id'] ?? '',
      username: payload['username'] ?? '',
      nickname: payload['nickname'],
      email: payload['email'] ?? '',
      dateOfBirth: payload['date_of_birth'] ?? payload['dateOfBirth'],
      gender: payload['gender'],
      phoneNumber: payload['phone_number'] ?? payload['phoneNumber'],
      isVerified: payload['is_verified'] ?? payload['isVerified'] ?? false,
      profileImageUrl:
          payload['profile_image_url'] ?? payload['profileImageUrl'],
      accessToken:
          payload['access_token'] ?? payload['accessToken'] ?? payload['access'],
      refreshToken: payload['refresh_token'] ?? payload['refreshToken'] ?? payload['refresh'],
    );
  }

  /// Convert model to JSON for API requests.
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'nickname': nickname,
    'email': email,
    'date_of_birth': dateOfBirth,
    'gender': gender,
    'phone_number': phoneNumber,
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
    String? gender,
    String? phoneNumber,
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
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
    gender,
    phoneNumber,
    isVerified,
    profileImageUrl,
    accessToken,
    refreshToken,
  ];
}

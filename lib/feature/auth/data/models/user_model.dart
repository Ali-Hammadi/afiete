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
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['user_id'] ?? '',
      username: json['username'] ?? '',
      nickname: json['nickname'],
      email: json['email'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? json['dateOfBirth'],
      gender: json['gender'],
      phoneNumber: json['phone_number'] ?? json['phoneNumber'],
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'],
      accessToken: json['access_token'] ?? json['accessToken'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
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

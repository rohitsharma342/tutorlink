enum UserRole { student, tutor }

enum UserGender { male, female }

class User {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final UserGender gender;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isVerified;
  final bool isBlocked;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.gender,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.isVerified = false,
    this.isBlocked = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      gender: UserGender.values.firstWhere((e) => e.name == json['gender']),
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'gender': gender.name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'isBlocked': isBlocked,
    };
  }
}
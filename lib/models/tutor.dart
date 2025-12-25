import 'user.dart';

enum TeachingType { online, inPerson, both }

class Tutor {
  final String id;
  final User user;
  final String bio;
  final List<String> subjects;
  final List<String> gradeLevels;
  final List<TeachingType> teachingTypes;
  final String area;
  final String city;
  final double hourlyRate;
  final int yearsOfExperience;
  final double averageRating;
  final int totalRatings;
  final String? introVideoUrl;
  final bool hasActiveSubscription;
  final DateTime? subscriptionExpiryDate;
  final int profileViews;
  final bool isVerified;

  Tutor({
    required this.id,
    required this.user,
    required this.bio,
    required this.subjects,
    required this.gradeLevels,
    required this.teachingTypes,
    required this.area,
    required this.city,
    required this.hourlyRate,
    required this.yearsOfExperience,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.introVideoUrl,
    this.hasActiveSubscription = false,
    this.subscriptionExpiryDate,
    this.profileViews = 0,
    this.isVerified = false,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      user: User.fromJson(json['user']),
      bio: json['bio'],
      subjects: List<String>.from(json['subjects']),
      gradeLevels: List<String>.from(json['gradeLevels']),
      teachingTypes: (json['teachingTypes'] as List)
          .map((e) => TeachingType.values.firstWhere((t) => t.name == e))
          .toList(),
      area: json['area'],
      city: json['city'],
      hourlyRate: json['hourlyRate'].toDouble(),
      yearsOfExperience: json['yearsOfExperience'],
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] ?? 0,
      introVideoUrl: json['introVideoUrl'],
      hasActiveSubscription: json['hasActiveSubscription'] ?? false,
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'])
          : null,
      profileViews: json['profileViews'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'bio': bio,
      'subjects': subjects,
      'gradeLevels': gradeLevels,
      'teachingTypes': teachingTypes.map((e) => e.name).toList(),
      'area': area,
      'city': city,
      'hourlyRate': hourlyRate,
      'yearsOfExperience': yearsOfExperience,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'introVideoUrl': introVideoUrl,
      'hasActiveSubscription': hasActiveSubscription,
      'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
      'profileViews': profileViews,
      'isVerified': isVerified,
    };
  }
}
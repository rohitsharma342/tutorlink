import '../models/tutor.dart';
import '../models/user.dart';
import '../models/chat.dart';
import '../utils/constants.dart';

class DataService {
  static final List<Tutor> _sampleTutors = [
    Tutor(
      id: '1',
      user: User(
        id: '1',
        email: 'ahmed.hassan@email.com',
        fullName: 'Ahmed Hassan',
        role: UserRole.tutor,
        gender: UserGender.male,
        profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      bio: 'Experienced mathematics teacher with a passion for helping students excel in their studies. I specialize in algebra, calculus, and geometry.',
      subjects: ['Mathematics', 'Physics', 'Statistics'],
      gradeLevels: ['High School', 'University'],
      teachingTypes: [TeachingType.both],
      area: 'Al Malqa',
      city: 'Riyadh',
      hourlyRate: 150.0,
      yearsOfExperience: 8,
      averageRating: 4.8,
      totalRatings: 127,
      hasActiveSubscription: true,
      isVerified: true,
      profileViews: 1234,
      introVideoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    ),
    Tutor(
      id: '2',
      user: User(
        id: '2',
        email: 'sara.mohammed@email.com',
        fullName: 'Sara Mohammed',
        role: UserRole.tutor,
        gender: UserGender.female,
        profileImageUrl: 'https://images.unsplash.com/photo-1494790108755-2616c25ce5dc?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      bio: 'Professional English language instructor with international teaching experience. I help students improve their speaking, writing, and comprehension skills.',
      subjects: ['English', 'Arabic Literature', 'Writing'],
      gradeLevels: ['Elementary', 'Middle School', 'High School'],
      teachingTypes: [TeachingType.online],
      area: 'Al Nakheel',
      city: 'Riyadh',
      hourlyRate: 120.0,
      yearsOfExperience: 5,
      averageRating: 4.9,
      totalRatings: 89,
      hasActiveSubscription: true,
      isVerified: true,
      profileViews: 892,
    ),
    Tutor(
      id: '3',
      user: User(
        id: '3',
        email: 'omar.ali@email.com',
        fullName: 'Omar Ali',
        role: UserRole.tutor,
        gender: UserGender.male,
        profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
      ),
      bio: 'Chemistry and Biology specialist with lab experience. I make complex scientific concepts easy to understand through practical examples.',
      subjects: ['Chemistry', 'Biology', 'Science'],
      gradeLevels: ['Middle School', 'High School', 'University'],
      teachingTypes: [TeachingType.inPerson],
      area: 'Al Olaya',
      city: 'Riyadh',
      hourlyRate: 200.0,
      yearsOfExperience: 10,
      averageRating: 4.7,
      totalRatings: 156,
      hasActiveSubscription: true,
      isVerified: true,
      profileViews: 756,
    ),
    Tutor(
      id: '4',
      user: User(
        id: '4',
        email: 'fatima.ahmed@email.com',
        fullName: 'Fatima Ahmed',
        role: UserRole.tutor,
        gender: UserGender.female,
        profileImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
      bio: 'Arabic language and Islamic studies teacher. I help students connect with their cultural heritage while excelling academically.',
      subjects: ['Arabic', 'Islamic Studies', 'History'],
      gradeLevels: ['Elementary', 'Middle School', 'High School'],
      teachingTypes: [TeachingType.both],
      area: 'Al Yasmin',
      city: 'Jeddah',
      hourlyRate: 100.0,
      yearsOfExperience: 6,
      averageRating: 4.6,
      totalRatings: 73,
      hasActiveSubscription: true,
      isVerified: true,
      profileViews: 423,
    ),
    Tutor(
      id: '5',
      user: User(
        id: '5',
        email: 'khalid.hassan@email.com',
        fullName: 'Khalid Hassan',
        role: UserRole.tutor,
        gender: UserGender.male,
        profileImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
      bio: 'Computer Science and Programming instructor. I teach various programming languages and help students with their coding projects.',
      subjects: ['Computer Science', 'Programming', 'Mathematics'],
      gradeLevels: ['High School', 'University'],
      teachingTypes: [TeachingType.online],
      area: 'Al Rabwa',
      city: 'Riyadh',
      hourlyRate: 180.0,
      yearsOfExperience: 4,
      averageRating: 4.5,
      totalRatings: 34,
      hasActiveSubscription: true,
      isVerified: false,
      profileViews: 234,
    ),
  ];

  static List<Tutor> getAllTutors() {
    return List.from(_sampleTutors);
  }

  static Tutor? getTutorById(String id) {
    try {
      return _sampleTutors.firstWhere((tutor) => tutor.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Tutor> searchTutors(String query) {
    if (query.isEmpty) return getAllTutors();
    
    return _sampleTutors.where((tutor) {
      return tutor.user.fullName.toLowerCase().contains(query.toLowerCase()) ||
             tutor.subjects.any((subject) => subject.toLowerCase().contains(query.toLowerCase())) ||
             tutor.city.toLowerCase().contains(query.toLowerCase()) ||
             tutor.area.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<Tutor> filterTutors({
    List<String>? subjects,
    List<String>? gradeLevels,
    String? city,
    double? maxRate,
    bool? isVerified,
  }) {
    return _sampleTutors.where((tutor) {
      bool matchesSubjects = subjects == null || subjects.isEmpty ||
          subjects.any((subject) => tutor.subjects.contains(subject));
      
      bool matchesGradeLevels = gradeLevels == null || gradeLevels.isEmpty ||
          gradeLevels.any((level) => tutor.gradeLevels.contains(level));
      
      bool matchesCity = city == null || city.isEmpty ||
          tutor.city.toLowerCase() == city.toLowerCase();
      
      bool matchesRate = maxRate == null || tutor.hourlyRate <= maxRate;
      
      bool matchesVerification = isVerified == null || tutor.isVerified == isVerified;
      
      return matchesSubjects && matchesGradeLevels && matchesCity && 
             matchesRate && matchesVerification;
    }).toList();
  }

  static List<String> getAllSubjects() {
    final Set<String> subjects = {};
    for (final tutor in _sampleTutors) {
      subjects.addAll(tutor.subjects);
    }
    return subjects.toList()..sort();
  }

  static List<String> getAllGradeLevels() {
    final Set<String> gradeLevels = {};
    for (final tutor in _sampleTutors) {
      gradeLevels.addAll(tutor.gradeLevels);
    }
    return gradeLevels.toList()..sort();
  }

  static List<String> getAllCities() {
    final Set<String> cities = {};
    for (final tutor in _sampleTutors) {
      cities.add(tutor.city);
    }
    return cities.toList()..sort();
  }

  static List<ChatMessage> getSampleMessages(String tutorId) {
    return [
      ChatMessage(
        id: '1',
        senderId: 'student_1',
        receiverId: tutorId,
        content: 'Hello! I\'m interested in learning mathematics. Can you help me with calculus?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '2',
        senderId: tutorId,
        receiverId: 'student_1',
        content: 'Hello! Yes, I\'d be happy to help you with calculus. What specific topics are you struggling with?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '3',
        senderId: 'student_1',
        receiverId: tutorId,
        content: 'I\'m having trouble with derivatives and integration. Could we start with the basics?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '4',
        senderId: tutorId,
        receiverId: 'student_1',
        content: 'Perfect! Let\'s start with derivatives. When would be a good time for our first lesson?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: MessageType.text,
      ),
    ];
  }
}
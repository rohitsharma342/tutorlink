class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? attachmentUrl;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.attachmentUrl,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      attachmentUrl: json['attachmentUrl'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'attachmentUrl': attachmentUrl,
      'isRead': isRead,
    };
  }
}

enum MessageType { text, image, file }

class ChatRoom {
  final String id;
  final String studentId;
  final String tutorId;
  final List<ChatMessage> messages;
  final bool isBlocked;
  final String? blockedBy;
  final bool lessonCompleted;
  final DateTime? completedAt;
  final double? rating;
  final DateTime createdAt;
  final DateTime lastActivity;

  ChatRoom({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.messages,
    this.isBlocked = false,
    this.blockedBy,
    this.lessonCompleted = false,
    this.completedAt,
    this.rating,
    required this.createdAt,
    required this.lastActivity,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      studentId: json['studentId'],
      tutorId: json['tutorId'],
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      isBlocked: json['isBlocked'] ?? false,
      blockedBy: json['blockedBy'],
      lessonCompleted: json['lessonCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      rating: json['rating']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      lastActivity: DateTime.parse(json['lastActivity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'tutorId': tutorId,
      'messages': messages.map((m) => m.toJson()).toList(),
      'isBlocked': isBlocked,
      'blockedBy': blockedBy,
      'lessonCompleted': lessonCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
    };
  }
}
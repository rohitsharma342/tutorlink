enum ComplaintReason {
  inappropriateBehavior,
  spam,
  falseInformation,
  harassment,
  other
}

enum ComplaintStatus {
  pending,
  underReview,
  resolved,
  dismissed
}

class Complaint {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final ComplaintReason? reason;
  final String? additionalDetails;
  final List<String> attachmentUrls;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? adminNotes;

  Complaint({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    this.reason,
    this.additionalDetails,
    this.attachmentUrls = const [],
    this.status = ComplaintStatus.pending,
    required this.createdAt,
    this.resolvedAt,
    this.adminNotes,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      reporterId: json['reporterId'],
      reportedUserId: json['reportedUserId'],
      reason: json['reason'] != null
          ? ComplaintReason.values.firstWhere((e) => e.name == json['reason'])
          : null,
      additionalDetails: json['additionalDetails'],
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ComplaintStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      adminNotes: json['adminNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'reason': reason?.name,
      'additionalDetails': additionalDetails,
      'attachmentUrls': attachmentUrls,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'adminNotes': adminNotes,
    };
  }
}
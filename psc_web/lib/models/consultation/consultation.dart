/// 咨询状态枚举
enum ConsultationStatus {
  scheduled,    // 已预约
  inProgress,   // 进行中
  completed,    // 已完成
  cancelled,    // 已取消
}

/// 咨询记录模型
class Consultation {
  final String id;
  final String clientId;
  final String clientName;
  final String counselorId;
  final String counselorName;
  final DateTime startTime;
  final DateTime endTime;
  final String topic;
  final String content;
  final ConsultationStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Consultation({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.counselorId,
    required this.counselorName,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.content,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      counselorId: json['counselorId'] as String,
      counselorName: json['counselorName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      topic: json['topic'] as String,
      content: json['content'] as String,
      status: ConsultationStatus.values.firstWhere(
        (e) => e.toString() == 'ConsultationStatus.${json['status']}',
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'counselorId': counselorId,
      'counselorName': counselorName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'topic': topic,
      'content': content,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 创建一个新的Consultation实例，可以选择性地更新某些字段
  Consultation copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? counselorId,
    String? counselorName,
    DateTime? startTime,
    DateTime? endTime,
    String? topic,
    String? content,
    ConsultationStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Consultation(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      counselorId: counselorId ?? this.counselorId,
      counselorName: counselorName ?? this.counselorName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      topic: topic ?? this.topic,
      content: content ?? this.content,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 
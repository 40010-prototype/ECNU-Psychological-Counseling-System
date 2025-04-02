/// 咨询记录模型
class ConsultationRecord {
  final String id;
  final String clientName;  // 来访者姓名
  final String clientId;    // 来访者ID
  final String counselorName;  // 咨询师姓名
  final String counselorId;    // 咨询师ID
  final DateTime startTime;    // 开始时间
  final DateTime endTime;      // 结束时间
  final ConsultationStatus status;  // 咨询状态
  final String summary;            // 咨询摘要
  final List<String> tags;         // 咨询标签
  final String? notes;             // 咨询笔记

  ConsultationRecord({
    required this.id,
    required this.clientName,
    required this.clientId,
    required this.counselorName,
    required this.counselorId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.summary,
    required this.tags,
    this.notes,
  });

  factory ConsultationRecord.fromJson(Map<String, dynamic> json) {
    return ConsultationRecord(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      clientId: json['clientId'] as String,
      counselorName: json['counselorName'] as String,
      counselorId: json['counselorId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: ConsultationStatus.values.firstWhere(
        (e) => e.toString() == 'ConsultationStatus.${json['status']}',
      ),
      summary: json['summary'] as String,
      tags: List<String>.from(json['tags']),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientId': clientId,
      'counselorName': counselorName,
      'counselorId': counselorId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'summary': summary,
      'tags': tags,
      'notes': notes,
    };
  }
}

/// 咨询状态枚举
enum ConsultationStatus {
  scheduled,    // 已预约
  inProgress,   // 进行中
  completed,    // 已完成
  cancelled,    // 已取消
  noShow,       // 未出席
} 
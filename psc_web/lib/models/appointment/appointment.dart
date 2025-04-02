import 'dart:convert';

/// 预约状态枚举
enum AppointmentStatus {
  /// 待确认
  pending,
  
  /// 已确认
  confirmed,
  
  /// 已完成
  completed,
  
  /// 已取消
  cancelled,
  
  /// 未出席
  noShow,
}

/// 预约时段模型
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}

/// 预约数据模型
class Appointment {
  /// 预约ID
  final String id;
  
  /// 来访者ID
  final String clientId;
  
  /// 来访者姓名
  final String clientName;
  
  /// 咨询师ID
  final String counselorId;
  
  /// 咨询师姓名
  final String counselorName;
  
  /// 预约时间
  final DateTime appointmentTime;
  
  /// 持续时间
  final Duration duration;
  
  /// 预约原因
  final String reason;
  
  /// 预约状态
  final AppointmentStatus status;
  
  /// 取消原因
  final String? cancelReason;
  
  /// 备注
  final String? notes;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 更新时间
  final DateTime? updatedAt;

  const Appointment({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.counselorId,
    required this.counselorName,
    required this.appointmentTime,
    required this.duration,
    required this.reason,
    required this.status,
    this.cancelReason,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// 从JSON构建预约对象
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      counselorId: json['counselorId'] as String,
      counselorName: json['counselorName'] as String,
      appointmentTime: DateTime.parse(json['appointmentTime'] as String),
      duration: Duration(minutes: json['durationMinutes'] as int),
      reason: json['reason'] as String,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
      ),
      cancelReason: json['cancelReason'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'counselorId': counselorId,
      'counselorName': counselorName,
      'appointmentTime': appointmentTime.toIso8601String(),
      'durationMinutes': duration.inMinutes,
      'reason': reason,
      'status': status.toString().split('.').last,
      'cancelReason': cancelReason,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// 创建更新的预约对象
  Appointment copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? counselorId,
    String? counselorName,
    DateTime? appointmentTime,
    Duration? duration,
    String? reason,
    AppointmentStatus? status,
    String? cancelReason,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      counselorId: counselorId ?? this.counselorId,
      counselorName: counselorName ?? this.counselorName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      duration: duration ?? this.duration,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  String toString() {
    return 'Appointment(id: $id, client: $clientName, counselor: $counselorName, '
           'time: $appointmentTime, status: $status)';
  }
} 
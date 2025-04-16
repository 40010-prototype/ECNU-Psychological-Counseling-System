import 'package:flutter/material.dart';

/// 会话状态枚举
enum SessionStatus {
  active,    // 活跃
  inactive,  // 非活跃
  archived,  // 已归档
}

/// 聊天会话模型
class ChatSession {
  final String id;                // 会话ID
  final String clientId;          // 咨询者ID
  final String clientName;        // 咨询者姓名
  final String clientAvatar;      // 咨询者头像
  final String counselorId;       // 咨询师ID
  final String counselorName;     // 咨询师姓名
  final String counselorAvatar;   // 咨询师头像
  final DateTime lastMessageTime; // 最后消息时间
  final String lastMessage;       // 最后消息内容
  final int unreadCount;          // 未读消息数量
  final SessionStatus status;     // 会话状态

  ChatSession({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientAvatar,
    required this.counselorId,
    required this.counselorName,
    required this.counselorAvatar,
    required this.lastMessageTime,
    required this.lastMessage,
    this.unreadCount = 0,
    this.status = SessionStatus.active,
  });

  /// 从JSON创建会话对象
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientAvatar: json['clientAvatar'],
      counselorId: json['counselorId'],
      counselorName: json['counselorName'],
      counselorAvatar: json['counselorAvatar'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessage: json['lastMessage'],
      unreadCount: json['unreadCount'] ?? 0,
      status: SessionStatus.values.firstWhere(
        (e) => e.toString() == 'SessionStatus.${json['status']}',
        orElse: () => SessionStatus.active,
      ),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'clientAvatar': clientAvatar,
      'counselorId': counselorId,
      'counselorName': counselorName,
      'counselorAvatar': counselorAvatar,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      'status': status.toString().split('.').last,
    };
  }
} 
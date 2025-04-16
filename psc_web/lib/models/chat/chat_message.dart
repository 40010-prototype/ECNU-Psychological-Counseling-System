import 'package:flutter/material.dart';

/// 消息类型枚举
enum MessageType {
  text,      // 文本消息
  image,     // 图片消息
  file,      // 文件消息
}

/// 消息发送状态枚举
enum MessageStatus {
  sending,   // 发送中
  sent,      // 已发送
  delivered, // 已送达
  read,      // 已读
  failed,    // 发送失败
}

/// 聊天消息模型
class ChatMessage {
  final String id;                 // 消息ID
  final String senderId;           // 发送者ID
  final String receiverId;         // 接收者ID
  final String sessionId;          // 会话ID
  final String content;            // 消息内容
  final DateTime timestamp;        // 时间戳
  final MessageType type;          // 消息类型
  final MessageStatus status;      // 消息状态
  final Map<String, dynamic>? meta; // 其他元数据，如图片URL、文件信息等

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sessionId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sending,
    this.meta,
  });

  /// 从JSON创建消息对象
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      sessionId: json['sessionId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${json['status']}',
        orElse: () => MessageStatus.sent,
      ),
      meta: json['meta'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'sessionId': sessionId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'meta': meta,
    };
  }
} 
import 'dart:async';
import 'package:psc_web/models/chat/chat_message.dart';
import 'package:psc_web/models/chat/chat_session.dart';

/// 聊天服务接口
abstract class ChatService {
  /// 获取会话列表
  Future<List<ChatSession>> getSessions();
  
  /// 获取指定会话的消息历史
  Future<List<ChatMessage>> getMessages(String sessionId, {int limit = 50, int offset = 0});
  
  /// 发送消息
  Future<ChatMessage> sendMessage(String sessionId, String content, {MessageType type = MessageType.text, Map<String, dynamic>? meta});
  
  /// 标记会话已读
  Future<void> markSessionAsRead(String sessionId);
  
  /// 连接到WebSocket服务
  Future<void> connect();
  
  /// 断开WebSocket连接
  Future<void> disconnect();
  
  /// 监听新消息的流
  Stream<ChatMessage> get onMessageReceived;
  
  /// 监听会话状态变化的流
  Stream<ChatSession> get onSessionUpdated;
  
  /// 监听连接状态的流
  Stream<bool> get onConnectionStateChanged;
} 
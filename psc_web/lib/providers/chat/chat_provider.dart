import 'dart:async';
import 'package:flutter/material.dart';
import 'package:psc_web/models/chat/chat_message.dart';
import 'package:psc_web/models/chat/chat_session.dart';
import 'package:psc_web/services/chat/chat_service.dart';

/// 聊天状态提供者
class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;
  
  // 会话列表
  List<ChatSession>? _sessions;
  
  // 活跃会话ID
  String? _activeSessionId;
  
  // 活跃会话的消息列表
  List<ChatMessage>? _activeSessionMessages;
  
  // 加载状态
  bool _isLoadingSessions = false;
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;
  bool _isConnected = false;
  
  // 错误信息
  String? _error;
  
  // 订阅
  StreamSubscription? _messageSubscription;
  StreamSubscription? _sessionSubscription;
  StreamSubscription? _connectionSubscription;
  
  ChatProvider(this._chatService) {
    _initialize();
  }
  
  // Getters
  List<ChatSession>? get sessions => _sessions;
  String? get activeSessionId => _activeSessionId;
  List<ChatMessage>? get activeSessionMessages => _activeSessionMessages;
  bool get isLoadingSessions => _isLoadingSessions;
  bool get isLoadingMessages => _isLoadingMessages;
  bool get isSendingMessage => _isSendingMessage;
  bool get isConnected => _isConnected;
  String? get error => _error;
  
  // 初始化
  Future<void> _initialize() async {
    // 订阅WebSocket消息
    _messageSubscription = _chatService.onMessageReceived.listen(_handleNewMessage);
    _sessionSubscription = _chatService.onSessionUpdated.listen(_handleSessionUpdate);
    _connectionSubscription = _chatService.onConnectionStateChanged.listen((connected) {
      _isConnected = connected;
      notifyListeners();
    });
    
    // 连接WebSocket
    try {
      // await _chatService.connect();
    } catch (e) {
      _error = '连接失败: $e';
      notifyListeners();
    }
    
    // 加载会话列表
    await loadSessions();
  }
  
  // 加载会话列表
  Future<void> loadSessions() async {
    _isLoadingSessions = true;
    _error = null;
    notifyListeners();
    
    try {
      _sessions = await _chatService.getSessions();
      _isLoadingSessions = false;
      notifyListeners();
      
      // 如果有活跃会话，加载其消息
      if (_activeSessionId != null) {
        await loadMessages(_activeSessionId!);
      }
    } catch (e) {
      _isLoadingSessions = false;
      _error = '加载会话失败: $e';
      notifyListeners();
    }
  }
  
  // 加载活跃会话的消息
  Future<void> loadMessages(String sessionId) async {
    _activeSessionId = sessionId;
    _isLoadingMessages = true;
    _error = null;
    notifyListeners();
    
    try {
      // 标记会话已读
      await _chatService.markSessionAsRead(sessionId);
      
      // 从最新会话列表中更新会话状态
      await _refreshSessionAfterReading(sessionId);
      
      // 加载消息
      _activeSessionMessages = await _chatService.getMessages(sessionId);
      _isLoadingMessages = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMessages = false;
      _error = '加载消息失败: $e';
      notifyListeners();
    }
  }
  
  // 发送消息
  Future<void> sendMessage(String content, {MessageType type = MessageType.text, Map<String, dynamic>? meta}) async {
    if (_activeSessionId == null) {
      _error = '没有选中的会话';
      notifyListeners();
      return;
    }
    
    if (content.trim().isEmpty) {
      return;
    }
    
    _isSendingMessage = true;
    _error = null;
    notifyListeners();
    
    try {
      final message = await _chatService.sendMessage(
        _activeSessionId!,
        content,
        type: type,
        meta: meta,
      );
      
      // 更新活跃会话的消息列表
      if (_activeSessionMessages != null) {
        _activeSessionMessages!.add(message);
      }
      
      _isSendingMessage = false;
      notifyListeners();
    } catch (e) {
      _isSendingMessage = false;
      _error = '发送消息失败: $e';
      notifyListeners();
    }
  }
  
  // 选择会话
  Future<void> selectSession(String sessionId) async {
    if (_activeSessionId != sessionId) {
      await loadMessages(sessionId);
    }
  }
  
  // 处理新消息
  void _handleNewMessage(ChatMessage message) {
    // 如果是当前活跃会话的消息，添加到消息列表
    if (_activeSessionId != null) {
      for (final session in _sessions ?? []) {
        if (session.id == _activeSessionId &&
            (session.clientId == message.senderId || session.counselorId == message.senderId)) {
          if (_activeSessionMessages != null) {
            _activeSessionMessages!.add(message);
            
            // 如果是活跃会话，标记为已读
            _chatService.markSessionAsRead(_activeSessionId!);
            _refreshSessionAfterReading(_activeSessionId!);
            
            notifyListeners();
          }
          break;
        }
      }
    }
  }
  
  // 处理会话更新
  void _handleSessionUpdate(ChatSession updatedSession) {
    if (_sessions != null) {
      // 更新会话列表中的对应会话
      for (int i = 0; i < _sessions!.length; i++) {
        if (_sessions![i].id == updatedSession.id) {
          _sessions![i] = updatedSession;
          notifyListeners();
          break;
        }
      }
    }
  }
  
  // 标记为已读后刷新会话
  Future<void> _refreshSessionAfterReading(String sessionId) async {
    if (_sessions != null) {
      for (int i = 0; i < _sessions!.length; i++) {
        if (_sessions![i].id == sessionId) {
          final session = _sessions![i];
          _sessions![i] = ChatSession(
            id: session.id,
            clientId: session.clientId,
            clientName: session.clientName,
            clientAvatar: session.clientAvatar,
            counselorId: session.counselorId,
            counselorName: session.counselorName,
            counselorAvatar: session.counselorAvatar,
            lastMessageTime: session.lastMessageTime,
            lastMessage: session.lastMessage,
            unreadCount: 0, // 将未读数设为0
            status: session.status,
          );
          notifyListeners();
          break;
        }
      }
    }
  }
  
  @override
  void dispose() {
    _messageSubscription?.cancel();
    _sessionSubscription?.cancel();
    _connectionSubscription?.cancel();
    _chatService.disconnect();
    super.dispose();
  }
} 
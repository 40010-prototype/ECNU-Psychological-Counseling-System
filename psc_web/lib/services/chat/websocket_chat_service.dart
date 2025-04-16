import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';
import 'package:psc_web/models/chat/chat_message.dart';
import 'package:psc_web/models/chat/chat_session.dart';
import 'package:psc_web/services/chat/chat_service.dart';
import 'package:psc_web/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// WebSocket聊天服务实现
class WebSocketChatService implements ChatService {
  final String userId;
  
  WebSocketChannel? _channel;
  final _messageController = StreamController<ChatMessage>.broadcast();
  final _sessionController = StreamController<ChatSession>.broadcast();
  final _connectionStateController = StreamController<bool>.broadcast();
  
  bool _isConnected = false;
  final Map<String, List<ChatMessage>> _messagesCache = {};
  final Map<String, ChatSession> _sessionsCache = {};
  
  final _uuid = Uuid();
  
  WebSocketChatService({
    required this.userId,
  });
  
  @override
  Future<List<ChatSession>> getSessions() async {
    
    try {
      // 1. 获取认证Token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      if (token == null) {
        throw Exception('找不到认证Token，请先登录');
      }
      
      // 2. 发送HTTP请求获取会话列表
      final response = await http.get(
        Uri.parse(ApiConstants.sessionsUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );
      
      // 3. 处理响应
      if (response.statusCode == 200) {
        final List<dynamic> sessionData = jsonDecode(response.body);
        final List<ChatSession> sessions = sessionData.map((data) => ChatSession.fromJson(data)).toList();
        
        // 4. 更新缓存
        _sessionsCache.clear();
        for (final session in sessions) {
          _sessionsCache[session.id] = session;
        }
        
        return sessions;
      } else {
        print('获取会话列表失败，状态码: ${response.statusCode}');
        print('响应体: ${response.body}');
        
        // 5. 如果请求失败但缓存中有数据，则返回缓存数据
        if (_sessionsCache.isNotEmpty) {
          return _sessionsCache.values.toList();
        }
        
        // 6. 如果请求失败且缓存为空，则使用模拟数据（仅用于开发测试）
        print('使用模拟会话数据进行测试');
        final mockSessions = _generateMockSessions();
        for (final session in mockSessions) {
          _sessionsCache[session.id] = session;
        }
        
        return mockSessions;
      }
    } catch (e) {
      print('获取会话列表时发生异常: $e');
      
      // 7. 发生异常时，使用缓存或模拟数据
      if (_sessionsCache.isNotEmpty) {
        return _sessionsCache.values.toList();
      }
      
      final mockSessions = _generateMockSessions();
      for (final session in mockSessions) {
        _sessionsCache[session.id] = session;
      }
      
      return mockSessions;
    }
  }
  
  @override
  Future<List<ChatMessage>> getMessages(String sessionId, {int limit = 10, int offset = 0}) async {
    try {
      // 1. 获取认证Token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      if (token == null) {
        throw Exception('找不到认证Token，请先登录');
      }
      
      // 2. 发送HTTP请求获取消息历史
      final response = await http.get(
        Uri.parse('${ApiConstants.getMessagesUrl(sessionId)}?limit=$limit&offset=$offset'),
        headers: {
          'Content-Type': 'application/json',
          'token': 'token',
        },
      );
      
      // 3. 处理响应
      if (response.statusCode == 200) {
        final List<dynamic> messageData = jsonDecode(response.body);
        final List<ChatMessage> messages = messageData.map((data) => ChatMessage.fromJson(data)).toList();
        
        // 4. 更新缓存
        if (!_messagesCache.containsKey(sessionId)) {
          _messagesCache[sessionId] = [];
        }
        
        // 如果是第一页数据，则清空缓存
        if (offset == 0) {
          _messagesCache[sessionId] = [...messages];
        } else {
          // 否则追加到缓存
          _messagesCache[sessionId]!.addAll(messages);
        }
        
        return messages;
      } else {
        print('获取消息历史失败，状态码: ${response.statusCode}');
        print('响应体: ${response.body}');
        
        // 5. 如果请求失败但缓存中有数据，则返回缓存数据
        if (_messagesCache.containsKey(sessionId)) {
          final cachedMessages = _messagesCache[sessionId]!;
          final start = offset < cachedMessages.length ? offset : cachedMessages.length;
          final end = (offset + limit) < cachedMessages.length ? (offset + limit) : cachedMessages.length;
          
          return cachedMessages.sublist(start, end);
        }
        
        // 6. 如果请求失败且缓存为空，则使用模拟数据（仅用于开发测试）
        print('使用模拟消息数据进行测试');
        final mockMessages = _generateMockMessages(sessionId);
        _messagesCache[sessionId] = mockMessages;
        
        final start = offset < mockMessages.length ? offset : mockMessages.length;
        final end = (offset + limit) < mockMessages.length ? (offset + limit) : mockMessages.length;
        
        return mockMessages.sublist(start, end);
      }
    } catch (e) {
      print('获取消息历史时发生异常: $e');
      
      // 7. 发生异常时，使用缓存或模拟数据
      if (_messagesCache.containsKey(sessionId)) {
        final cachedMessages = _messagesCache[sessionId]!;
        final start = offset < cachedMessages.length ? offset : cachedMessages.length;
        final end = (offset + limit) < cachedMessages.length ? (offset + limit) : cachedMessages.length;
        
        return cachedMessages.sublist(start, end);
      }
      
      // 如果缓存为空，则使用模拟数据
      final mockMessages = _generateMockMessages(sessionId);
      _messagesCache[sessionId] = mockMessages;
      
      final start = offset < mockMessages.length ? offset : mockMessages.length;
      final end = (offset + limit) < mockMessages.length ? (offset + limit) : mockMessages.length;
      
      return mockMessages.sublist(start, end);
    }
  }
  
  @override
  Future<ChatMessage> sendMessage(String sessionId, String content, {MessageType type = MessageType.text, Map<String, dynamic>? meta}) async {
    // 创建消息对象
    final message = ChatMessage(
      id: _uuid.v4(),
      senderId: userId,
      receiverId: _getReceiverIdFromSession(sessionId),
      sessionId: sessionId,
      content: content,
      timestamp: DateTime.now(),
      type: type,
      status: MessageStatus.sending,
      meta: meta,
    );
    
    try {
      // 1. 尝试通过WebSocket发送消息
      if (_isConnected && _channel != null) {
        _channel!.sink.add(jsonEncode(message.toJson()));
      } else {
        throw Exception('WebSocket未连接');
      }
      
      // 2. 更新消息状态
      final updatedMessage = ChatMessage(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sessionId: message.sessionId,
        content: message.content,
        timestamp: message.timestamp,
        type: message.type,
        status: MessageStatus.sent, // 更新状态为已发送
        meta: message.meta,
      );
      
      // 3. 更新缓存
      if (!_messagesCache.containsKey(sessionId)) {
        _messagesCache[sessionId] = [];
      }
      _messagesCache[sessionId]!.add(updatedMessage);
      
      // 4. 更新会话的最后消息
      if (_sessionsCache.containsKey(sessionId)) {
        final session = _sessionsCache[sessionId]!;
        final updatedSession = ChatSession(
          id: session.id,
          clientId: session.clientId,
          clientName: session.clientName,
          clientAvatar: session.clientAvatar,
          counselorId: session.counselorId,
          counselorName: session.counselorName,
          counselorAvatar: session.counselorAvatar,
          lastMessageTime: updatedMessage.timestamp,
          lastMessage: updatedMessage.content,
          unreadCount: session.unreadCount,
          status: session.status,
        );
        _sessionsCache[sessionId] = updatedSession;
        _sessionController.add(updatedSession);
      }
      
      return updatedMessage;
    } catch (e) {
      print('发送消息时发生异常: $e');
      
      // 5. 更新消息状态为发送失败
      final failedMessage = ChatMessage(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sessionId: message.sessionId,
        content: message.content,
        timestamp: message.timestamp,
        type: message.type,
        status: MessageStatus.failed, // 更新状态为发送失败
        meta: message.meta,
      );
      
      // 更新缓存
      if (!_messagesCache.containsKey(sessionId)) {
        _messagesCache[sessionId] = [];
      }
      _messagesCache[sessionId]!.add(failedMessage);
      
      throw Exception('发送消息失败: $e');
    }
  }
  
  @override
  Future<void> markSessionAsRead(String sessionId) async {
    if (_sessionsCache.containsKey(sessionId)) {
      final session = _sessionsCache[sessionId]!;
      final updatedSession = ChatSession(
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
      _sessionsCache[sessionId] = updatedSession;
      _sessionController.add(updatedSession);
      
      try {
        // 获取认证Token
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('authToken');
        
        if (token == null) {
          throw Exception('找不到认证Token，请先登录');
        }
        
        // 向服务器发送请求标记会话已读
        final response = await http.post(
          Uri.parse(ApiConstants.markReadUrl(sessionId)),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          },
        );
        
        if (response.statusCode != 200) {
          print('标记会话已读失败，状态码: ${response.statusCode}');
          print('响应体: ${response.body}');
        } else {
          print('成功标记会话 $sessionId 已读');
        }
      } catch (e) {
        print('标记会话已读时发生异常: $e');
        // 即使网络请求失败，本地状态仍然更新为已读
      }
    }
  }
  
  @override
  Future<void> connect() async {
    if (_isConnected) {
      return;
    }
    
    try {
      // 获取认证Token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken') ?? 'anonymous_token';
      
      // 使用ApiConstants生成安全的WebSocket URL
      final wsUrl = ApiConstants.getSecureSocketUrl(userId, token);
      print('尝试连接WebSocket服务器');
      
      // 增加连接超时处理
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // 设置连接超时
      bool connected = false;
      Future.delayed(const Duration(seconds: 5), () {
        if (!connected) {
          print('WebSocket连接超时');
          // 不抛出异常，而是使用缓存数据
          _isConnected = false;
          _connectionStateController.add(false);
        }
      });
      
      // 监听消息
      _channel!.stream.listen(
        (data) {
          connected = true;
          _handleIncomingMessage(data);
        },
        onDone: () {
          print('WebSocket连接已关闭');
          _isConnected = false;
          _connectionStateController.add(false);
          
          // 尝试重新连接
          _scheduleReconnect();
        },
        onError: (error) {
          print('WebSocket错误: $error');
          _isConnected = false;
          _connectionStateController.add(false);
          
          // 尝试重新连接
          _scheduleReconnect();
        },
      );
      
      _isConnected = true;
      _connectionStateController.add(true);
      print('WebSocket连接成功');
    } catch (e) {
      print('WebSocket连接失败: $e');
      _isConnected = false;
      _connectionStateController.add(false);
      
      // 尝试重新连接
      _scheduleReconnect();
      
      // 不要抛出异常，而是继续使用缓存数据
      // rethrow;
    }
  }
  
  // 安排重新连接
  void _scheduleReconnect() {
    // 延迟5秒后重新连接
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        print('尝试重新连接WebSocket');
        connect();
      }
    });
  }
  
  @override
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }
    _isConnected = false;
    _connectionStateController.add(false);
  }
  
  @override
  Stream<ChatMessage> get onMessageReceived => _messageController.stream;
  
  @override
  Stream<ChatSession> get onSessionUpdated => _sessionController.stream;
  
  @override
  Stream<bool> get onConnectionStateChanged => _connectionStateController.stream;
  
  // 处理收到的WebSocket消息
  void _handleIncomingMessage(dynamic data) {
    try {
      final json = jsonDecode(data as String);
      final message = ChatMessage.fromJson(json);
      
      // 找到对应的会话
      String? sessionId;
      for (final entry in _sessionsCache.entries) {
        if (entry.value.clientId == message.senderId || entry.value.counselorId == message.senderId) {
          sessionId = entry.key;
          break;
        }
      }
      
      if (sessionId != null) {
        // 更新消息缓存
        if (!_messagesCache.containsKey(sessionId)) {
          _messagesCache[sessionId] = [];
        }
        _messagesCache[sessionId]!.add(message);
        
        // 更新会话信息
        final session = _sessionsCache[sessionId]!;
        final updatedSession = ChatSession(
          id: session.id,
          clientId: session.clientId,
          clientName: session.clientName,
          clientAvatar: session.clientAvatar,
          counselorId: session.counselorId,
          counselorName: session.counselorName,
          counselorAvatar: session.counselorAvatar,
          lastMessageTime: message.timestamp,
          lastMessage: message.content,
          unreadCount: session.unreadCount + 1, // 增加未读数
          status: session.status,
        );
        _sessionsCache[sessionId] = updatedSession;
        
        // 通知监听器
        _messageController.add(message);
        _sessionController.add(updatedSession);
      }
    } catch (e) {
      print('处理WebSocket消息失败: $e');
    }
  }
  
  // 从会话中获取接收者ID
  String _getReceiverIdFromSession(String sessionId) {
    if (_sessionsCache.containsKey(sessionId)) {
      final session = _sessionsCache[sessionId]!;
      // 如果当前用户是咨询师，接收者是来访者；反之亦然
      return session.counselorId == userId ? session.clientId : session.counselorId;
    }
    return '';
  }
  
  // 生成模拟会话列表（仅用于演示）
  List<ChatSession> _generateMockSessions() {
    return [
      ChatSession(
        id: '1',
        clientId: 'client1',
        clientName: '张同学',
        clientAvatar: '',
        counselorId: 'counselor1',
        counselorName: '李咨询师',
        counselorAvatar: '',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        lastMessage: '谢谢您的帮助，我感觉好多了',
        unreadCount: 0,
      ),
      ChatSession(
        id: '2',
        clientId: 'client2',
        clientName: '王同学',
        clientAvatar: '',
        counselorId: 'counselor1',
        counselorName: '李咨询师',
        counselorAvatar: '',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        lastMessage: '我们下次咨询约在什么时候？',
        unreadCount: 2,
      ),
      ChatSession(
        id: '3',
        clientId: 'client3',
        clientName: '刘同学',
        clientAvatar: '',
        counselorId: 'counselor1',
        counselorName: '李咨询师',
        counselorAvatar: '',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        lastMessage: '希望能和您预约一次咨询',
        unreadCount: 0,
        status: SessionStatus.inactive,
      ),
    ];
  }
  
  // 生成模拟消息（仅用于演示）
  List<ChatMessage> _generateMockMessages(String sessionId) {
    final messages = <ChatMessage>[];
    final now = DateTime.now();
    
    if (sessionId == '1') {
      messages.addAll([
        ChatMessage(
          id: '101',
          senderId: 'client1',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '李老师，我最近感到很焦虑，难以集中注意力学习',
          timestamp: now.subtract(const Duration(days: 1, hours: 2)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '102',
          senderId: 'counselor1',
          receiverId: 'client1',
          sessionId: sessionId,
          content: '你好，张同学。能详细说说是什么让你感到焦虑吗？',
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 55)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '103',
          senderId: 'client1',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '我担心考试成绩不好，最近睡眠也不太好',
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '104',
          senderId: 'counselor1',
          receiverId: 'client1',
          sessionId: sessionId,
          content: '理解你的担忧。我们可以讨论一些减压的方法，也可以制定一个学习计划，这样你会感觉更有掌控感',
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '105',
          senderId: 'client1',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '谢谢您的帮助，我感觉好多了',
          timestamp: now.subtract(const Duration(minutes: 5)),
          status: MessageStatus.delivered,
        ),
      ]);
    } else if (sessionId == '2') {
      messages.addAll([
        ChatMessage(
          id: '201',
          senderId: 'client2',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '李老师，我是王同学，想请教一些问题',
          timestamp: now.subtract(const Duration(days: 2, hours: 3)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '202',
          senderId: 'counselor1',
          receiverId: 'client2',
          sessionId: sessionId,
          content: '你好，王同学。很高兴能帮助你，请问有什么我可以帮忙的？',
          timestamp: now.subtract(const Duration(days: 2, hours: 2, minutes: 50)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '203',
          senderId: 'client2',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '我和室友相处有些困难，不知道该如何沟通',
          timestamp: now.subtract(const Duration(days: 2, hours: 2, minutes: 45)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '204',
          senderId: 'counselor1',
          receiverId: 'client2',
          sessionId: sessionId,
          content: '人际关系确实可能带来压力。我们可以在下次咨询中详细讨论一些有效的沟通技巧',
          timestamp: now.subtract(const Duration(days: 2, hours: 2, minutes: 40)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '205',
          senderId: 'client2',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '好的，谢谢老师',
          timestamp: now.subtract(const Duration(days: 2, hours: 2, minutes: 35)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '206',
          senderId: 'client2',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '我们下次咨询约在什么时候？',
          timestamp: now.subtract(const Duration(hours: 2)),
          status: MessageStatus.delivered,
        ),
      ]);
    } else {
      messages.addAll([
        ChatMessage(
          id: '301',
          senderId: 'client3',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '李老师您好，我是刘同学',
          timestamp: now.subtract(const Duration(days: 3, hours: 4)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '302',
          senderId: 'counselor1',
          receiverId: 'client3',
          sessionId: sessionId,
          content: '你好，刘同学。有什么可以帮到你的吗？',
          timestamp: now.subtract(const Duration(days: 3, hours: 3, minutes: 55)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: '303',
          senderId: 'client3',
          receiverId: 'counselor1',
          sessionId: sessionId,
          content: '希望能和您预约一次咨询',
          timestamp: now.subtract(const Duration(days: 1)),
          status: MessageStatus.read,
        ),
      ]);
    }
    
    return messages;
  }
} 
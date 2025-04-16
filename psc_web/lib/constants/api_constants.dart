class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/admin';
  static const String loginUrl = '$baseUrl/login';
  static const String registerUrl = '$baseUrl/register';
  static const String getInfoUrl = '$baseUrl/adminInfo';
  
  // WebSocket基础URL
  static const String socketBaseUrl = 'ws://localhost:8080/ws/chat';
  
  // 安全的WebSocket URL生成方法
  static String getSecureSocketUrl(String userId, String token) {
    return '$socketBaseUrl?userId=$userId&token=$token';
  }
  
  // 聊天相关API
  static const String sessionsUrl = '$baseUrl/sessions';
  
  // 获取特定会话信息、消息和标记已读的URL方法
  static String getSessionUrl(String sessionId) => '$baseUrl/sessions/$sessionId';
  static String getMessagesUrl(String sessionId) => '$baseUrl/sessions/$sessionId/messages';
  static String markReadUrl(String sessionId) => '$baseUrl/sessions/$sessionId/read';
}
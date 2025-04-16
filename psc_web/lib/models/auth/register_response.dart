/// 注册响应模型
class RegisterResponse {
  final bool success;         // 注册是否成功
  final String? message;      // 响应消息
  final String? error;        // 错误信息
  final String? token;        // 认证令牌
  final String? userId;       // 用户ID

  RegisterResponse({
    required this.success,
    this.message,
    this.error,
    this.token,
    this.userId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: (json['code'] == 1),
      message: json['message'] as String?,
      error: json['error'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String?,
    );
  }
} 
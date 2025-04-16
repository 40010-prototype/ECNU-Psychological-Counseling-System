import 'package:psc_web/models/user/user.dart';

/// 注册请求模型
class RegisterRequest {
  final String username;      // 用户名
  final String name;          // 姓名
  final String email;         // 邮箱
  final String? phone;        // 电话
  final String password;      // 密码
  final UserRole role;        // 角色
  final Map<String, dynamic>? profile;  // 角色特定信息

  RegisterRequest({
    required this.username,
    required this.name,
    required this.email,
    this.phone,
    required this.password,
    required this.role,
    this.profile,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.toString().split('.').last,
      'profile': profile,
    };
  }
} 
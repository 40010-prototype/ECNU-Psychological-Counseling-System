// lib/models/user/login_request.dart
class LoginRequest {
  final String name; // 用户名 (邮箱and手机号待实现)
  final String password; 

  LoginRequest({required this.name, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:psc_web/models/auth/login_request.dart';
import 'package:psc_web/models/auth/register_request.dart';
import 'package:psc_web/models/auth/register_response.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psc_web/constants/api_constants.dart';

class AuthService {
  static String get _loginUrl => ApiConstants.loginUrl;
  static String get _registerUrl => ApiConstants.registerUrl;
  static String get _userDataUrl => ApiConstants.getInfoUrl;

  /// 登录方法
  Future<String?> login(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        print('响应体: ${jsonDecode(response.body)['data']['token']}');
        return jsonDecode(response.body)['data']['token'];
      } else {
        print('登录失败，状态码: ${response.statusCode}');
        print('响应体: ${response.body}');
        return null;
      }
    } catch (error) {
      print('登录过程中发生错误: $error');
      return null;
    }
  }

  /// 获取用户数据
  Future<User?> fetchUserDataWithToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse(_userDataUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer $token',
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return User.fromJson(responseData['data']);
      } else {
        print('获取用户数据失败，状态码: ${response.statusCode}');
        print('响应体: ${response.body}');
        return null;
      }
    } catch (error) {
      print('获取用户数据过程中发生错误: $error');
      return null;
    }
  }

  /// 保存令牌到本地存储
  Future<void> saveTokenToLocalStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  /// 从本地存储获取令牌
  Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// 从本地存储移除令牌
  Future<void> removeTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  /// 注册新用户
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return RegisterResponse.fromJson(responseData);
        // return RegisterResponse(
        //   success: responseData['code'] == 1,
        // );  //待完善
      } else {
        return RegisterResponse(
          success: false,
          error: '注册失败: ${response.body}',
        );
      }
    } catch (error) {
      print('注册过程中发生错误: $error');
      return RegisterResponse(
        success: false,
        error: error.toString(),
      );
    }
  }
} 
// lib/providers/user/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:psc_web/models/auth/login_request.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/services/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _loggedInUser;
  bool _isLoading = false;
  bool _isFetchingUserData = false;
  String? _errorMessage;
  final AuthService _authService;

  AuthProvider(this._authService);

  User? get loggedInUser => _loggedInUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFetchingUserData => _isFetchingUserData;

  Future<bool> login(String name, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final LoginRequest loginRequest = LoginRequest(name: name, password: password);
    final userToken = await _authService.login(loginRequest);

    if (userToken != null) {
      await _authService.saveTokenToLocalStorage(userToken); // 保存 Token 到 localStorage
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = '用户名或密码错误';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchUserData() async {
    final String? token = await _authService.getTokenFromLocalStorage(); // 从 localStorage 获取 Token

    if (token == null || token.isEmpty) {
      _errorMessage = '未找到 Token，请重新登录';
      notifyListeners();
      return false;
    }

    _isFetchingUserData = true;
    notifyListeners();

    final User? fullUser = await _authService.fetchUserDataWithToken(token);

    if (fullUser != null) {
      _loggedInUser = fullUser;
      _isFetchingUserData = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = '获取用户数据失败';
      _isFetchingUserData = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.removeTokenFromLocalStorage();
    _loggedInUser = null;
    notifyListeners();
  }
}
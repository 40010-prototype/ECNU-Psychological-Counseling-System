import 'package:flutter/material.dart';
import 'package:psc_web/models/auth/login_request.dart';
import 'package:psc_web/models/auth/register_request.dart';
import 'package:psc_web/models/auth/register_response.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/services/auth/auth_service.dart';

class RegisterProvider with ChangeNotifier {
  final AuthService _authService;
  
  // 注册状态
  bool _isLoading = false;
  String? _errorMessage;
  int _currentStep = 0;
  UserRole? _selectedRole;
  
  // 表单数据
  final Map<String, dynamic> _formData = {};
  
  RegisterProvider(this._authService);
  
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentStep => _currentStep;
  UserRole? get selectedRole => _selectedRole;
  Map<String, dynamic> get formData => Map.unmodifiable(_formData);
  
  // 更新当前步骤
  void updateStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
  
  // 选择角色
  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }
  
  // 更新表单数据
  void updateFormData(String key, dynamic value) {
    _formData[key] = value;
    notifyListeners();
  }
  
  // 清除表单数据
  void clearFormData() {
    _formData.clear();
    _selectedRole = null;
    _currentStep = 0;
    notifyListeners();
  }
  
  // 注册方法
  Future<RegisterResponse> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // 创建注册请求
      final request = RegisterRequest(
        username: _formData['username'],
        name: _formData['name'],
        email: _formData['email'],
        phone: _formData['phone'],
        password: _formData['password'],
        role: _selectedRole!,
        profile: _formData['profile'],
      );
      
      // 调用注册服务
      final response = await _authService.register(request);
      
      _isLoading = false;
      notifyListeners();
      
      // 注册成功后自动登录
      if (response.success) {
        // 如果后端返回了token，直接使用
        if (response.token != null) {
          await _authService.saveTokenToLocalStorage(response.token!);
          return response;
        }
        
        // 否则使用注册的用户名和密码进行登录
        final loginRequest = LoginRequest(
          name: request.username, 
          password: request.password
        );
        final token = await _authService.login(loginRequest);
        
        if (token != null) {
          await _authService.saveTokenToLocalStorage(token);
          return response;
        } else {
          _errorMessage = '注册成功但自动登录失败，请手动登录';
          notifyListeners();
          return RegisterResponse(
            success: true,
            error: _errorMessage,
          );
        }
      }
      
      return response;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      
      return RegisterResponse(
        success: false,
        error: e.toString(),
      );
    }
  }
} 
import 'package:flutter/material.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/services/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;
  
  List<User>? _users;
  User? _selectedUser;
  List<User>? _counselors;
  List<User>? _supervisors;
  bool _isLoading = false;
  String? _error;
  
  UserProvider(this._userService);
  
  // Getters
  List<User>? get users => _users;
  User? get selectedUser => _selectedUser;
  List<User>? get counselors => _counselors;
  List<User>? get supervisors => _supervisors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 加载所有用户
  Future<void> loadAllUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _users = await _userService.getAllUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载用户列表失败：$e';
      notifyListeners();
    }
  }
  
  // 加载单个用户
  Future<void> loadUserById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _selectedUser = await _userService.getUserById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载用户详情失败：$e';
      notifyListeners();
    }
  }
  
  // 加载所有咨询师
  Future<void> loadAllCounselors() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _counselors = await _userService.getAllCounselors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载咨询师列表失败：$e';
      notifyListeners();
    }
  }
  
  // 加载所有督导
  Future<void> loadAllSupervisors() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _supervisors = await _userService.getAllSupervisors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载督导列表失败：$e';
      notifyListeners();
    }
  }
  
  // 创建用户
  Future<User?> createUser(User user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final newUser = await _userService.createUser(user);
      _users?.add(newUser);
      
      // 根据角色更新对应列表
      if (newUser.role == UserRole.counselor) {
        _counselors?.add(newUser);
      } else if (newUser.role == UserRole.supervisor) {
        _supervisors?.add(newUser);
      }
      
      _isLoading = false;
      notifyListeners();
      return newUser;
    } catch (e) {
      _isLoading = false;
      _error = '创建用户失败：$e';
      notifyListeners();
      return null;
    }
  }
  
  // 更新用户
  Future<User?> updateUser(User user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final updatedUser = await _userService.updateUser(user);
      
      // 更新用户列表
      final index = _users?.indexWhere((u) => u.id == user.id) ?? -1;
      if (index != -1) {
        _users?[index] = updatedUser;
      }
      
      // 更新选中的用户
      if (_selectedUser?.id == user.id) {
        _selectedUser = updatedUser;
      }
      
      // 更新咨询师列表
      if (user.role == UserRole.counselor) {
        final counselorIndex = _counselors?.indexWhere((c) => c.id == user.id) ?? -1;
        if (counselorIndex != -1) {
          _counselors?[counselorIndex] = updatedUser;
        }
      }
      
      // 更新督导列表
      if (user.role == UserRole.supervisor) {
        final supervisorIndex = _supervisors?.indexWhere((s) => s.id == user.id) ?? -1;
        if (supervisorIndex != -1) {
          _supervisors?[supervisorIndex] = updatedUser;
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return updatedUser;
    } catch (e) {
      _isLoading = false;
      _error = '更新用户失败：$e';
      notifyListeners();
      return null;
    }
  }
  
  // 更新用户状态
  Future<bool> updateUserStatus(String id, UserStatus status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _userService.updateUserStatus(id, status);
      if (success) {
        // 更新用户列表中的状态
        final user = _users?.firstWhere((u) => u.id == id);
        if (user != null) {
          final updatedUser = user.copyWith(status: status);
          await updateUser(updatedUser);
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = '更新用户状态失败：$e';
      notifyListeners();
      return false;
    }
  }
  
  // 删除用户
  Future<bool> deleteUser(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _userService.deleteUser(id);
      if (success) {
        // 从各个列表中移除用户
        _users?.removeWhere((u) => u.id == id);
        _counselors?.removeWhere((c) => c.id == id);
        _supervisors?.removeWhere((s) => s.id == id);
        
        // 如果删除的是当前选中的用户，清除选中状态
        if (_selectedUser?.id == id) {
          _selectedUser = null;
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = '删除用户失败：$e';
      notifyListeners();
      return false;
    }
  }
  
  // 重置用户密码
  Future<bool> resetPassword(String id, String newPassword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _userService.updatePassword(id, newPassword);
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = '重置密码失败：$e';
      notifyListeners();
      return false;
    }
  }
  
  // 分配督导给咨询师
  Future<bool> assignSupervisorToCounselor(String counselorId, String supervisorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _userService.assignSupervisorToCounselor(counselorId, supervisorId);
      if (success) {
        // 重新加载咨询师和督导列表以更新关系
        await loadAllCounselors();
        await loadAllSupervisors();
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = '分配督导失败：$e';
      notifyListeners();
      return false;
    }
  }
  
  // 搜索用户
  Future<List<User>> searchUsers(String keyword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final results = await _userService.searchUsers(keyword);
      
      _isLoading = false;
      notifyListeners();
      return results;
    } catch (e) {
      _isLoading = false;
      _error = '搜索用户失败：$e';
      notifyListeners();
      return [];
    }
  }
  
  // 根据角色获取用户列表
  Future<List<User>> getUsersByRole(UserRole role) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final results = await _userService.getUsersByRole(role);
      
      _isLoading = false;
      notifyListeners();
      return results;
    } catch (e) {
      _isLoading = false;
      _error = '获取用户列表失败：$e';
      notifyListeners();
      return [];
    }
  }
  
  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 
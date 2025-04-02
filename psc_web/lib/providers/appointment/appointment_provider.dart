import 'package:flutter/material.dart';
import 'package:psc_web/models/appointment/appointment.dart';
import 'package:psc_web/services/appointment/appointment_service.dart';

/// 预约管理的Provider
class AppointmentProvider extends ChangeNotifier {
  /// 预约服务
  final AppointmentService _appointmentService;
  
  /// 所有预约列表
  List<Appointment>? _appointments;
  
  /// 是否正在加载
  bool _isLoading = false;
  
  /// 错误信息
  String? _error;
  
  /// 获取预约列表
  List<Appointment>? get appointments => _appointments;
  
  /// 获取是否正在加载
  bool get isLoading => _isLoading;
  
  /// 获取错误信息
  String? get error => _error;
  
  /// 构造函数
  AppointmentProvider({required AppointmentService appointmentService})
      : _appointmentService = appointmentService;
  
  /// 加载所有预约
  Future<void> loadAllAppointments() async {
    _setLoading(true);
    _clearError();
    
    try {
      final appointments = await _appointmentService.getAllAppointments();
      _appointments = appointments;
      notifyListeners();
    } catch (e) {
      _setError('加载预约失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载指定客户的预约
  Future<void> loadAppointmentsByClient(String clientId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final appointments = await _appointmentService.getAppointmentsByClient(clientId);
      _appointments = appointments;
      notifyListeners();
    } catch (e) {
      _setError('加载客户预约失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载指定咨询师的预约
  Future<void> loadAppointmentsByCounselor(String counselorId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final appointments = await _appointmentService.getAppointmentsByCounselor(counselorId);
      _appointments = appointments;
      notifyListeners();
    } catch (e) {
      _setError('加载咨询师预约失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载指定日期范围内的预约
  Future<void> loadAppointmentsByDateRange(DateTime start, DateTime end) async {
    _setLoading(true);
    _clearError();
    
    try {
      final appointments = await _appointmentService.getAppointmentsByDateRange(start, end);
      _appointments = appointments;
      notifyListeners();
    } catch (e) {
      _setError('加载日期范围预约失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// 获取咨询师可用时间段
  Future<List<DateTime>> getAvailableTimeSlots(String counselorId, DateTime date) async {
    try {
      return await _appointmentService.getAvailableTimeSlots(counselorId, date);
    } catch (e) {
      _setError('获取可用时间段失败: ${e.toString()}');
      return [];
    }
  }
  
  /// 创建预约
  Future<Appointment?> createAppointment(Appointment appointment) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newAppointment = await _appointmentService.createAppointment(appointment);
      
      // 如果当前已有预约列表，将新预约添加到列表中
      if (_appointments != null) {
        _appointments = [..._appointments!, newAppointment];
      }
      
      notifyListeners();
      return newAppointment;
    } catch (e) {
      _setError('创建预约失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 更新预约
  Future<Appointment?> updateAppointment(Appointment appointment) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedAppointment = await _appointmentService.updateAppointment(appointment);
      
      // 如果当前已有预约列表，更新列表中对应的预约
      if (_appointments != null) {
        _appointments = _appointments!.map((a) {
          if (a.id == updatedAppointment.id) {
            return updatedAppointment;
          }
          return a;
        }).toList();
      }
      
      notifyListeners();
      return updatedAppointment;
    } catch (e) {
      _setError('更新预约失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 确认预约
  Future<Appointment?> confirmAppointment(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedAppointment = await _appointmentService.confirmAppointment(id);
      
      // 如果当前已有预约列表，更新列表中对应的预约
      if (_appointments != null) {
        _appointments = _appointments!.map((a) {
          if (a.id == updatedAppointment.id) {
            return updatedAppointment;
          }
          return a;
        }).toList();
      }
      
      notifyListeners();
      return updatedAppointment;
    } catch (e) {
      _setError('确认预约失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 完成预约
  Future<Appointment?> completeAppointment(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedAppointment = await _appointmentService.completeAppointment(id);
      
      // 如果当前已有预约列表，更新列表中对应的预约
      if (_appointments != null) {
        _appointments = _appointments!.map((a) {
          if (a.id == updatedAppointment.id) {
            return updatedAppointment;
          }
          return a;
        }).toList();
      }
      
      notifyListeners();
      return updatedAppointment;
    } catch (e) {
      _setError('完成预约失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 取消预约
  Future<Appointment?> cancelAppointment(String id, String reason) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedAppointment = await _appointmentService.cancelAppointment(id, reason);
      
      // 如果当前已有预约列表，更新列表中对应的预约
      if (_appointments != null) {
        _appointments = _appointments!.map((a) {
          if (a.id == updatedAppointment.id) {
            return updatedAppointment;
          }
          return a;
        }).toList();
      }
      
      notifyListeners();
      return updatedAppointment;
    } catch (e) {
      _setError('取消预约失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 标记为未出席
  Future<Appointment?> markAsNoShow(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedAppointment = await _appointmentService.markAsNoShow(id);
      
      // 如果当前已有预约列表，更新列表中对应的预约
      if (_appointments != null) {
        _appointments = _appointments!.map((a) {
          if (a.id == updatedAppointment.id) {
            return updatedAppointment;
          }
          return a;
        }).toList();
      }
      
      notifyListeners();
      return updatedAppointment;
    } catch (e) {
      _setError('标记为未出席失败: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// 设置错误信息
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  /// 清除错误信息
  void _clearError() {
    _error = null;
    notifyListeners();
  }
} 
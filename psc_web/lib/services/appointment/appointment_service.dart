import 'package:psc_web/models/appointment/appointment.dart';

/// 预约服务接口
abstract class AppointmentService {
  /// 获取所有预约
  Future<List<Appointment>> getAllAppointments();
  
  /// 获取指定ID的预约
  Future<Appointment?> getAppointmentById(String id);
  
  /// 获取指定客户的预约
  Future<List<Appointment>> getAppointmentsByClient(String clientId);
  
  /// 获取指定咨询师的预约
  Future<List<Appointment>> getAppointmentsByCounselor(String counselorId);
  
  /// 获取指定日期范围内的预约
  Future<List<Appointment>> getAppointmentsByDateRange(DateTime start, DateTime end);
  
  /// 获取咨询师的可用时间段
  Future<List<DateTime>> getAvailableTimeSlots(String counselorId, DateTime date);
  
  /// 创建预约
  Future<Appointment> createAppointment(Appointment appointment);
  
  /// 更新预约
  Future<Appointment> updateAppointment(Appointment appointment);
  
  /// 确认预约
  Future<Appointment> confirmAppointment(String id);
  
  /// 完成预约
  Future<Appointment> completeAppointment(String id);
  
  /// 取消预约
  Future<Appointment> cancelAppointment(String id, String reason);
  
  /// 标记为未出席
  Future<Appointment> markAsNoShow(String id);
}

/// 预约服务的模拟实现
class MockAppointmentService implements AppointmentService {
  // 模拟预约列表
  final List<Appointment> _appointments = [
    Appointment(
      id: 'appt-001',
      clientId: 'client-001',
      clientName: '张三',
      counselorId: 'counselor-001',
      counselorName: '王老师',
      appointmentTime: DateTime.now().add(const Duration(days: 2, hours: 10)),
      duration: const Duration(minutes: 60),
      reason: '学业压力',
      status: AppointmentStatus.confirmed,
      notes: '首次咨询，需要准备一些基本评估',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Appointment(
      id: 'appt-002',
      clientId: 'client-002',
      clientName: '李四',
      counselorId: 'counselor-002',
      counselorName: '刘老师',
      appointmentTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      duration: const Duration(minutes: 90),
      reason: '人际关系问题',
      status: AppointmentStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Appointment(
      id: 'appt-003',
      clientId: 'client-003',
      clientName: '王五',
      counselorId: 'counselor-001',
      counselorName: '王老师',
      appointmentTime: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      duration: const Duration(minutes: 60),
      reason: '情绪困扰',
      status: AppointmentStatus.completed,
      notes: '需要后续跟进，建议两周后再次咨询',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Appointment(
      id: 'appt-004',
      clientId: 'client-004',
      clientName: '赵六',
      counselorId: 'counselor-003',
      counselorName: '张老师',
      appointmentTime: DateTime.now().subtract(const Duration(days: 1, hours: 15)),
      duration: const Duration(minutes: 60),
      reason: '职业规划咨询',
      status: AppointmentStatus.noShow,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Appointment(
      id: 'appt-005',
      clientId: 'client-001',
      clientName: '张三',
      counselorId: 'counselor-002',
      counselorName: '刘老师',
      appointmentTime: DateTime.now().subtract(const Duration(days: 5, hours: 11)),
      duration: const Duration(minutes: 60),
      reason: '学业压力后续咨询',
      status: AppointmentStatus.cancelled,
      cancelReason: '临时有事无法参加',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Appointment(
      id: 'appt-006',
      clientId: 'client-005',
      clientName: '孙七',
      counselorId: 'counselor-001',
      counselorName: '王老师',
      appointmentTime: DateTime.now().add(const Duration(days: 5, hours: 16)),
      duration: const Duration(minutes: 60),
      reason: '考试焦虑',
      status: AppointmentStatus.confirmed,
      notes: '期末考试前的压力管理',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  
  // 咨询师默认可用时间段（上午9点到下午5点，每小时一个时间段）
  final Map<String, List<DateTime>> _defaultTimeSlots = {};
  
  /// 构造函数 - 初始化默认时间段
  MockAppointmentService() {
    // 为每个咨询师生成未来7天的默认可用时间段
    final counselorIds = ['counselor-001', 'counselor-002', 'counselor-003'];
    
    for (final counselorId in counselorIds) {
      _defaultTimeSlots[counselorId] = [];
      
      // 生成未来7天的时间段
      for (int day = 0; day < 7; day++) {
        final date = DateTime.now().add(Duration(days: day));
        final startDate = DateTime(date.year, date.month, date.day, 9, 0); // 从上午9点开始
        
        // 每天8个时间段：9:00, 10:00, 11:00, 13:00, 14:00, 15:00, 16:00, 17:00
        for (int hour = 9; hour <= 17; hour++) {
          // 排除中午12点的时间段
          if (hour != 12) {
            final timeSlot = DateTime(date.year, date.month, date.day, hour, 0);
            _defaultTimeSlots[counselorId]!.add(timeSlot);
          }
        }
      }
    }
  }
  
  @override
  Future<List<Appointment>> getAllAppointments() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));
    return _appointments;
  }
  
  @override
  Future<Appointment?> getAppointmentById(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (final appointment in _appointments) {
      if (appointment.id == id) {
        return appointment;
      }
    }
    
    return null;
  }
  
  @override
  Future<List<Appointment>> getAppointmentsByClient(String clientId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 700));
    
    return _appointments.where((appointment) => appointment.clientId == clientId).toList();
  }
  
  @override
  Future<List<Appointment>> getAppointmentsByCounselor(String counselorId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 700));
    
    return _appointments.where((appointment) => appointment.counselorId == counselorId).toList();
  }
  
  @override
  Future<List<Appointment>> getAppointmentsByDateRange(DateTime start, DateTime end) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 700));
    
    return _appointments.where((appointment) {
      return appointment.appointmentTime.isAfter(start) && 
             appointment.appointmentTime.isBefore(end);
    }).toList();
  }
  
  @override
  Future<List<DateTime>> getAvailableTimeSlots(String counselorId, DateTime date) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (!_defaultTimeSlots.containsKey(counselorId)) {
      return [];
    }
    
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    
    // 获取该咨询师当天的所有默认时间段
    final allTimeSlots = _defaultTimeSlots[counselorId]!.where((slot) {
      return slot.isAfter(dateStart) && slot.isBefore(dateEnd);
    }).toList();
    
    // 获取该咨询师当天已经预约的时间段
    final bookedAppointments = _appointments.where((appointment) {
      return appointment.counselorId == counselorId && 
             appointment.appointmentTime.isAfter(dateStart) && 
             appointment.appointmentTime.isBefore(dateEnd) &&
             (appointment.status == AppointmentStatus.confirmed || 
              appointment.status == AppointmentStatus.pending);
    }).toList();
    
    // 从所有时间段中移除已预约的时间段
    final availableTimeSlots = allTimeSlots.where((timeSlot) {
      return !bookedAppointments.any((appointment) {
        return appointment.appointmentTime.hour == timeSlot.hour &&
               appointment.appointmentTime.minute == timeSlot.minute;
      });
    }).toList();
    
    return availableTimeSlots;
  }
  
  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // 检查时间段是否可用
    final counselorId = appointment.counselorId;
    final appointmentTime = appointment.appointmentTime;
    
    final availableTimeSlots = await getAvailableTimeSlots(
      counselorId, 
      DateTime(appointmentTime.year, appointmentTime.month, appointmentTime.day),
    );
    
    final isTimeSlotAvailable = availableTimeSlots.any((timeSlot) {
      return timeSlot.hour == appointmentTime.hour && 
             timeSlot.minute == appointmentTime.minute;
    });
    
    if (!isTimeSlotAvailable) {
      throw Exception('所选时间段已被预约');
    }
    
    // 创建新的预约ID
    final newId = 'appt-${_appointments.length + 1}'.padLeft(7, '0');
    
    // 创建新的预约对象
    final newAppointment = appointment.copyWith(
      id: newId,
      createdAt: DateTime.now(),
      status: AppointmentStatus.pending,
    );
    
    // 添加到预约列表
    _appointments.add(newAppointment);
    
    return newAppointment;
  }
  
  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));
    
    // 查找原始预约
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    
    if (index == -1) {
      throw Exception('预约未找到');
    }
    
    // 如果更改了时间或咨询师，检查新的时间段是否可用
    final originalAppointment = _appointments[index];
    if (originalAppointment.counselorId != appointment.counselorId || 
        originalAppointment.appointmentTime != appointment.appointmentTime) {
      
      final counselorId = appointment.counselorId;
      final appointmentTime = appointment.appointmentTime;
      
      final availableTimeSlots = await getAvailableTimeSlots(
        counselorId, 
        DateTime(appointmentTime.year, appointmentTime.month, appointmentTime.day),
      );
      
      final isTimeSlotAvailable = availableTimeSlots.any((timeSlot) {
        return timeSlot.hour == appointmentTime.hour && 
               timeSlot.minute == appointmentTime.minute;
      });
      
      // 同时要考虑自己原来占用的时间段
      final isSameTimeSlot = originalAppointment.appointmentTime.year == appointmentTime.year &&
                             originalAppointment.appointmentTime.month == appointmentTime.month &&
                             originalAppointment.appointmentTime.day == appointmentTime.day &&
                             originalAppointment.appointmentTime.hour == appointmentTime.hour &&
                             originalAppointment.appointmentTime.minute == appointmentTime.minute;
      
      if (!isTimeSlotAvailable && !isSameTimeSlot) {
        throw Exception('所选时间段已被预约');
      }
    }
    
    // 更新预约
    final updatedAppointment = appointment.copyWith(
      updatedAt: DateTime.now(),
    );
    
    _appointments[index] = updatedAppointment;
    
    return updatedAppointment;
  }
  
  @override
  Future<Appointment> confirmAppointment(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    // 查找预约
    final index = _appointments.indexWhere((a) => a.id == id);
    
    if (index == -1) {
      throw Exception('预约未找到');
    }
    
    // 只有待确认的预约才能被确认
    if (_appointments[index].status != AppointmentStatus.pending) {
      throw Exception('只有待确认的预约才能被确认');
    }
    
    // 更新预约状态
    final updatedAppointment = _appointments[index].copyWith(
      status: AppointmentStatus.confirmed,
      updatedAt: DateTime.now(),
    );
    
    _appointments[index] = updatedAppointment;
    
    return updatedAppointment;
  }
  
  @override
  Future<Appointment> completeAppointment(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    // 查找预约
    final index = _appointments.indexWhere((a) => a.id == id);
    
    if (index == -1) {
      throw Exception('预约未找到');
    }
    
    // 只有已确认的预约才能被标记为已完成
    if (_appointments[index].status != AppointmentStatus.confirmed) {
      throw Exception('只有已确认的预约才能被标记为已完成');
    }
    
    // 更新预约状态
    final updatedAppointment = _appointments[index].copyWith(
      status: AppointmentStatus.completed,
      updatedAt: DateTime.now(),
    );
    
    _appointments[index] = updatedAppointment;
    
    return updatedAppointment;
  }
  
  @override
  Future<Appointment> cancelAppointment(String id, String reason) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    // 查找预约
    final index = _appointments.indexWhere((a) => a.id == id);
    
    if (index == -1) {
      throw Exception('预约未找到');
    }
    
    // 已完成或已取消的预约不能再被取消
    if (_appointments[index].status == AppointmentStatus.completed || 
        _appointments[index].status == AppointmentStatus.cancelled) {
      throw Exception('已完成或已取消的预约不能再被取消');
    }
    
    // 更新预约状态
    final updatedAppointment = _appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
      cancelReason: reason,
      updatedAt: DateTime.now(),
    );
    
    _appointments[index] = updatedAppointment;
    
    return updatedAppointment;
  }
  
  @override
  Future<Appointment> markAsNoShow(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));
    
    // 查找预约
    final index = _appointments.indexWhere((a) => a.id == id);
    
    if (index == -1) {
      throw Exception('预约未找到');
    }
    
    // 只有已确认的预约才能被标记为未出席
    if (_appointments[index].status != AppointmentStatus.confirmed) {
      throw Exception('只有已确认的预约才能被标记为未出席');
    }
    
    // 更新预约状态
    final updatedAppointment = _appointments[index].copyWith(
      status: AppointmentStatus.noShow,
      updatedAt: DateTime.now(),
    );
    
    _appointments[index] = updatedAppointment;
    
    return updatedAppointment;
  }
}

/// 时间段模型
class TimeSlot {
  final String startTime; // 格式: "HH:MM"
  final String endTime;   // 格式: "HH:MM"
  
  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });
} 
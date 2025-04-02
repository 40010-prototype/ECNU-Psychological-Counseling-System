import 'package:psc_web/models/consultation/consultation.dart';

/// 咨询记录服务接口
abstract class ConsultationService {
  /// 获取所有咨询记录
  Future<List<Consultation>> getAllConsultations();
  
  /// 获取指定ID的咨询记录
  Future<Consultation> getConsultationById(String id);
  
  /// 获取指定客户的咨询记录
  Future<List<Consultation>> getConsultationsByClient(String clientId);
  
  /// 获取指定咨询师的咨询记录
  Future<List<Consultation>> getConsultationsByCounselor(String counselorId);
  
  /// 获取指定日期范围的咨询记录
  Future<List<Consultation>> getConsultationsByDateRange(DateTime start, DateTime end);
  
  /// 创建咨询记录
  Future<Consultation> createConsultation(Consultation consultation);
  
  /// 更新咨询记录
  Future<Consultation> updateConsultation(Consultation consultation);
  
  /// 删除咨询记录
  Future<bool> deleteConsultation(String id);
}

/// 模拟咨询记录服务实现
class MockConsultationService implements ConsultationService {
  final List<Consultation> _consultations = [
    Consultation(
      id: '1',
      clientId: 'C001',
      clientName: '张三',
      counselorId: 'CO001',
      counselorName: '李咨询师',
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 1)),
      topic: '学业压力',
      content: '来访者表示最近学习压力较大，经常失眠...',
      status: ConsultationStatus.completed,
      notes: '建议进行放松训练',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Consultation(
      id: '2',
      clientId: 'C002',
      clientName: '李四',
      counselorId: 'CO002',
      counselorName: '王咨询师',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      topic: '人际关系',
      content: '来访者表示与室友关系紧张...',
      status: ConsultationStatus.scheduled,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Consultation(
      id: '3',
      clientId: 'C003',
      clientName: '王五',
      counselorId: 'CO001',
      counselorName: '李咨询师',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      topic: '情感困扰',
      content: '来访者表示最近与恋人关系出现问题...',
      status: ConsultationStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Future<List<Consultation>> getAllConsultations() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _consultations;
  }

  @override
  Future<Consultation> getConsultationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _consultations.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<Consultation>> getConsultationsByClient(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _consultations.where((c) => c.clientId == clientId).toList();
  }

  @override
  Future<List<Consultation>> getConsultationsByCounselor(String counselorId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _consultations.where((c) => c.counselorId == counselorId).toList();
  }

  @override
  Future<List<Consultation>> getConsultationsByDateRange(DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _consultations.where((c) => 
      c.startTime.isAfter(start) && c.endTime.isBefore(end)
    ).toList();
  }

  @override
  Future<Consultation> createConsultation(Consultation consultation) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _consultations.add(consultation);
    return consultation;
  }

  @override
  Future<Consultation> updateConsultation(Consultation consultation) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _consultations.indexWhere((c) => c.id == consultation.id);
    if (index != -1) {
      _consultations[index] = consultation;
    }
    return consultation;
  }

  @override
  Future<bool> deleteConsultation(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _consultations.indexWhere((c) => c.id == id);
    if (index != -1) {
      _consultations.removeAt(index);
      return true;
    }
    return false;
  }
} 
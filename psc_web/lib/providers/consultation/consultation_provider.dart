import 'package:flutter/material.dart';
import 'package:psc_web/models/consultation/consultation.dart';
import 'package:psc_web/services/consultation/consultation_service.dart';

class ConsultationProvider extends ChangeNotifier {
  final ConsultationService _consultationService;
  List<Consultation>? _consultations;
  Consultation? _selectedConsultation;
  bool _isLoading = false;
  String? _error;
  
  ConsultationProvider(this._consultationService);
  
  // Getters
  List<Consultation>? get consultations => _consultations;
  Consultation? get selectedConsultation => _selectedConsultation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 加载所有咨询记录
  Future<void> loadConsultations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _consultations = await _consultationService.getAllConsultations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 加载单个咨询记录
  Future<void> loadConsultationById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _selectedConsultation = await _consultationService.getConsultationById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载咨询记录详情失败：$e';
      notifyListeners();
    }
  }
  
  // 按客户ID加载咨询记录
  Future<void> loadConsultationsByClient(String clientId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _consultations = await _consultationService.getConsultationsByClient(clientId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载客户咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 按咨询师ID加载咨询记录
  Future<void> loadConsultationsByCounselor(String counselorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _consultations = await _consultationService.getConsultationsByCounselor(counselorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载咨询师咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 按日期范围加载咨询记录
  Future<void> loadConsultationsByDateRange(DateTime start, DateTime end) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _consultations = await _consultationService.getConsultationsByDateRange(start, end);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载日期范围咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 创建咨询记录
  Future<void> createConsultation(Consultation consultation) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final newConsultation = await _consultationService.createConsultation(consultation);
      _consultations?.add(newConsultation);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '创建咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 更新咨询记录
  Future<void> updateConsultation(Consultation consultation) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final updatedConsultation = await _consultationService.updateConsultation(consultation);
      final index = _consultations?.indexWhere((c) => c.id == consultation.id);
      if (index != null && index != -1) {
        _consultations?[index] = updatedConsultation;
      }
      
      // 如果是当前选中的咨询记录，也要更新
      if (_selectedConsultation?.id == consultation.id) {
        _selectedConsultation = updatedConsultation;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '更新咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 删除咨询记录
  Future<void> deleteConsultation(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _consultationService.deleteConsultation(id);
      
      if (success) {
        // 更新本地数据
        if (_consultations != null) {
          _consultations!.removeWhere((c) => c.id == id);
        }
        
        // 如果是当前选中的咨询记录，清除选中状态
        if (_selectedConsultation?.id == id) {
          _selectedConsultation = null;
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '删除咨询记录失败：$e';
      notifyListeners();
    }
  }
  
  // 选择一条咨询记录
  void selectConsultation(Consultation consultation) {
    _selectedConsultation = consultation;
    notifyListeners();
  }
  
  // 清除选择
  void clearSelection() {
    _selectedConsultation = null;
    notifyListeners();
  }
  
  // 刷新数据
  void refresh() {
    loadConsultations();
  }
  
  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 
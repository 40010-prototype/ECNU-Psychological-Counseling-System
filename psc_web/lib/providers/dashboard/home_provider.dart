import 'package:flutter/material.dart';
import 'package:psc_web/models/dashboard/home_data.dart';
import 'package:psc_web/services/dashboard/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService;
  HomeData? _homeData;
  bool _isLoading = false;
  String? _error;

  HomeProvider(this._homeService);

  HomeData? get homeData => _homeData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _homeData = await _homeService.getHomeData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '加载数据失败：$e';
      notifyListeners();
    }
  }

  void refresh() {
    loadHomeData();
  }
} 
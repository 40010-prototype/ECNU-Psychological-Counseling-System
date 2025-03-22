import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 登录和注册界面的动画管理类
class LoginAnimationController {
  late AnimationController controller;
  late Animation<double> slideAnimation;
  late Animation<double> fadeAnimation;
  
  /// 初始化动画控制器和相关动画
  LoginAnimationController(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 700),
      // 添加更平滑的曲线
      animationBehavior: AnimationBehavior.preserve,
    );

    // 使用缓动曲线获得更自然的动画
    slideAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut, // 使用三次贝塞尔曲线
    );

    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    
    // 预热动画 - 这有助于第一次动画更顺畅
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.value = 0.001;
      controller.reverse();
    });
  }
  
  /// 切换登录/注册视图
  void toggleView() {
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
  
  /// 释放资源
  void dispose() {
    controller.dispose();
  }
  
  /// 判断当前是否处于登录状态
  bool get isLogin => slideAnimation.value <= 0.5;
  
  /// 添加状态监听
  void addListener(VoidCallback listener) {
    controller.addListener(listener);
  }
  
  /// 添加状态变化监听
  void addStatusListener(AnimationStatusListener listener) {
    controller.addStatusListener(listener);
  }
} 
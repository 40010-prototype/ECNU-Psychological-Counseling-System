import 'package:flutter/material.dart';

/// 菜单项模型
class MenuItemModel {
  /// 标题
  final String title;
  
  /// 图标
  final IconData icon;
  
  /// 选中状态图标
  final IconData activeIcon;
  
  /// 徽章数量
  final int? badgeCount;

  /// 菜单项模型构造函数
  MenuItemModel({
    required this.title,
    required this.icon,
    required this.activeIcon,
    this.badgeCount,
  });
} 
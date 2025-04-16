import 'package:flutter/material.dart';

/// 应用中使用的颜色常量
/// 精简版颜色系统，只保留关键色彩
class AppColors {
  // 品牌基础色
  static const Color primary = Color(0xFF8696A7);      // 主色 (灰蓝色)
  static const Color secondary = Color(0xFF6b5152);    // 次要品牌色 (深灰棕色)
  static const Color accent = Color(0xFFafb0b2);       // 强调色 (浅灰色)

  // 中性色彩
  static const Color background = Color(0xfff4ece4);   // 背景色 (米白色)
  static const Color surface = Color(0xFFf7f2ec);      // 表面色 (卡片背景)
  static const Color border = Color(0xFFd5d0ca);       // 边框色
  static const Color divider = Color(0xFFe9e4de);      // 分隔线色

  // 文本颜色
  static const Color textPrimary = Color(0xFF4a4a4a);  // 主要文本
  static const Color textSecondary = Color(0xFF6d6d6d); // 次要文本

  // 功能色
  static const Color error = Color(0xFFb35a5a);        // 错误红
  static const Color warning = Color(0xFFd6a86e);      // 警告橙
  static const Color success = Color(0xFF6fa277);      // 成功绿
  static const Color info = Color(0xFF6f90b3);         // 提示蓝
  
  // === 兼容旧代码的颜色映射 ===
  
  // 旧版主色映射
  static const Color primaryLight = Color(0xFFa7b4c2);  // 浅主色
  static const Color primaryAccent = secondary;        // 主色强调 -> 使用secondary
  static const Color secondaryAccent = accent;         // 辅助色强调 -> 使用accent
  
  // 旧版背景/表面颜色映射
  static const Color cardBackground = surface;         // 卡片背景 -> 使用surface
  static const Color cardSelected = Color(0xFFe5ded7); // 选中卡片背景
  static const Color glassBgLight = Color(0xFFe9e4de); // 浅色毛玻璃背景
  static const Color glassBgDark = Color(0xFFd5d0ca);  // 深色毛玻璃背景
  
  // 旧版文本颜色映射
  static const Color textDisabled = Color(0xFF9e9e9e); // 禁用文本颜色
  static const Color primaryText = textPrimary;        // 兼容旧名称
  static const Color secondaryText = textSecondary;    // 兼容旧名称
  
  // 旧版输入框相关颜色映射
  static const Color inputBackground = surface;        // 输入框背景 -> 使用surface
  static const Color inputBorder = border;             // 输入框边框 -> 使用border
  static const Color inputFocused = primary;           // 输入框聚焦 -> 使用primary
  
  // 旧版进度指示器颜色映射
  static const Color progressActive = primary;         // 活动进度 -> 使用primary
  static const Color progressInactive = border;        // 非活动进度 -> 使用border
  static const Color progressComplete = secondary;     // 完成进度 -> 使用secondary
  static const Color progressText = textPrimary;       // 进度文字 -> 使用textPrimary
  
  // 旧版按钮颜色映射
  static const Color buttonPrimary = primary;          // 主按钮 -> 使用primary
  static const Color buttonSecondary = secondary;      // 次要按钮 -> 使用secondary
  static const Color buttonDisabled = accent;          // 禁用按钮 -> 使用accent
}

import 'package:flutter/material.dart';
import 'dart:math';

/// 登录和注册界面的装饰组件集合
class AuthDecorations {
  /// 创建背景装饰
  static Widget buildBackground(BuildContext context, Animation<double> slideAnimation) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    
    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Stack(
        children: [
          // 顶部装饰圆形
          AnimatedBuilder(
            animation: slideAnimation,
            builder: (context, child) {
              // 计算圆形位置 - 从右上角移动到左下角
              final double topPosition = -size.height * 0.15 + (slideAnimation.value * size.height * 0.5);
              final double rightPosition = -size.width * 0.1 - (slideAnimation.value * size.width * 0.5);
              
              return Positioned(
                top: topPosition,
                right: rightPosition,
                child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(max(0.1 - slideAnimation.value, 0.0)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 创建左侧区域的装饰
  static Widget buildLeftSideDecorations(BuildContext context, double width) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 渐变颜色
    final decorationBackgroundStart = colorScheme.primary;
    final decorationBackgroundEnd = Color.lerp(colorScheme.primary, colorScheme.secondary, 0.7)!;
    
    return Stack(
      children: [
        // 装饰背景
        Positioned.fill(
          child: ClipRRect(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        decorationBackgroundStart,
                        decorationBackgroundEnd,
                      ],
                    ),
                  ),
                ),
                // 玻璃态圆形装饰
                Positioned(
                  top: - width * 0.2,
                  left: -width * 0.3,
                  child: Container(
                    width: width * 0.8,
                    height: width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -width * 0.4,
                  right: -width * 0.2,
                  child: Container(
                    width: width * 0.7,
                    height: width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 创建右侧区域的装饰（注册状态）
  static Widget buildRightSideDecorations(BuildContext context, Animation<double> slideAnimation, Size size) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: (slideAnimation.value - 0.5) * 2,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
          ),
          child: Stack(
            children: [
              // 从左侧淡入并飞入的圆形
              AnimatedBuilder(
                animation: slideAnimation,
                builder: (context, child) {
                  // 计算动画进度(0-1)
                  double progress = (slideAnimation.value - 0.5) * 2;
                  // 限制在0-1范围内
                  progress = max(0.0, min(1.0, progress));
                  
                  return Positioned(
                    left: -100 + (progress * 200), // 从左侧-100位置移动到100位置
                    bottom: size.height * 0.15,
                    child: Opacity(
                      opacity: progress,
                      child: Container(
                        width: 1000,
                        height: 1000,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.08),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 创建圆形图标容器
  static Widget buildIconContainer(BuildContext context, IconData icon, {bool isDarkMode = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? 
          Colors.white.withOpacity(0.2) : 
          colorScheme.primary.withOpacity(0.2),
      ),
      child: Icon(
        icon,
        size: 40,
        color: isDarkMode ? 
          colorScheme.onPrimary : 
          colorScheme.primary,
      ),
    );
  }
} 
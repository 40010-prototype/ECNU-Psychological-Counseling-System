import 'package:flutter/material.dart';

/// 系统设置页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 80,
            color: colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            '系统设置页面',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这里将显示系统配置和个人偏好设置',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
} 
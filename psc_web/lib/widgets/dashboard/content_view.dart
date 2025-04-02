import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/widgets/dashboard/pages/home_page.dart';
import 'package:psc_web/widgets/dashboard/pages/consultation_records_page.dart';
import 'package:psc_web/widgets/dashboard/pages/schedule_page.dart';
import 'package:psc_web/widgets/dashboard/pages/counselor_management_page.dart';
import 'package:psc_web/widgets/dashboard/pages/supervisor_management_page.dart';
import 'package:psc_web/widgets/dashboard/pages/user_management_page.dart';
import 'package:psc_web/widgets/dashboard/pages/appointment_management_page.dart';
import 'package:psc_web/widgets/dashboard/pages/settings_page.dart';
import 'package:psc_web/providers/consultation/consultation_provider.dart';

/// 内容视图组件
class ContentView extends StatelessWidget {
  /// 选中的菜单项索引
  final int selectedIndex;
  
  /// 选中的菜单项
  final MenuItemModel menuItem;

  const ContentView({
    Key? key,
    required this.selectedIndex,
    required this.menuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 尝试访问ConsultationProvider，验证是否已注册
    try {
      Provider.of<ConsultationProvider>(context, listen: false);
      print('ContentView: ConsultationProvider 已成功注册');
    } catch (e) {
      print('ContentView: ConsultationProvider 访问错误: $e');
    }
    
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          // 页面标题栏
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 页面标题
                Text(
                  menuItem.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                
                const Spacer(),
                
                // 搜索框
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索...',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 用户头像
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    '管',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 页面内容区域
          Expanded(
            child: _buildPageContent(context),
          ),
        ],
      ),
    );
  }
  
  // 根据选中的菜单项构建对应的页面内容
  Widget _buildPageContent(BuildContext context) {
    // 为每个菜单项创建对应的页面内容
    switch (selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ConsultationRecordsPage();
      case 2:
        return const SchedulePage();
      case 3:
        return const CounselorManagementPage();
      case 4:
        return const SupervisorManagementPage();
      case 5:
        return const UserManagementPage();
      case 6:
        return const AppointmentManagementPage();
      case 7:
        return const SettingsPage();
      default:
        return const Center(
          child: Text('页面未找到'),
        );
    }
  }
} 
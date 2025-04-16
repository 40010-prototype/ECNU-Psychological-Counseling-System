import 'package:flutter/material.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/admin/pages/home/home_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/consultation_records/consultation_records_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/schedule/schedule_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/counselor_management/counselor_management_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/supervisor_management/supervisor_management_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/user_management/user_management_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/appointment_management/appointment_management_page.dart';
import 'package:psc_web/pages/dashboard/admin/pages/settings/settings_page.dart';
import 'package:psc_web/pages/dashboard/supervisor/pages/my_counselors_page.dart';
import 'package:psc_web/pages/dashboard/counselor/pages/my_appointments_page.dart';
import 'package:psc_web/pages/dashboard/counselor/pages/chat_page.dart';

/// 基于角色的内容视图组件
class RoleContentView extends StatelessWidget {
  /// 选中的菜单项索引
  final int selectedIndex;
  
  /// 选中的菜单项
  final MenuItemModel menuItem;
  
  /// 用户角色
  final UserRole userRole;

  const RoleContentView({
    Key? key,
    required this.selectedIndex,
    required this.menuItem,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          // 页面顶部区域 - 完全透明，只保留搜索框和头像
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                    _getAvatarText(userRole),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: _buildPageContent(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 获取头像显示文字
  String _getAvatarText(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '管';
      case UserRole.supervisor:
        return '督';
      case UserRole.counselor:
        return '咨';
      case UserRole.client:
        return '访';
      default:
        return '用';
    }
  }
  
  // 根据选中的菜单项和用户角色构建对应的页面内容
  Widget _buildPageContent(BuildContext context) {
    // 公共页面组件
    const homepage = HomePage();
    const consultationRecordsPage = ConsultationRecordsPage();
    const schedulePage = SchedulePage();
    
    // 根据角色提供不同页面
    switch (userRole) {
      case UserRole.admin:
        return _buildAdminPageContent(selectedIndex);
      case UserRole.supervisor:
        return _buildSupervisorPageContent(selectedIndex);
      case UserRole.counselor:
        return _buildCounselorPageContent(selectedIndex);
      default:
        return const Center(child: Text('未知角色页面'));
    }
  }
  
  // 管理员页面内容
  Widget _buildAdminPageContent(int index) {
    switch (index) {
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
        return const Center(child: Text('页面未找到'));
    }
  }
  
  // 督导页面内容
  Widget _buildSupervisorPageContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MyCounselorsPage();
      case 2:
        return const Center(child: Text('督导案例页面'));
      case 3:
        return const Center(child: Text('督导评估页面'));
      case 4:
        return const ConsultationRecordsPage();
      case 5:
        return const SchedulePage();
      case 6:
        return const Center(child: Text('个人资料页面'));
      case 7:
        return const Center(child: Text('消息通知页面'));
      default:
        return const Center(child: Text('页面未找到'));
    }
  }
  
  // 咨询师页面内容
  Widget _buildCounselorPageContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MyAppointmentsPage();
      case 2:
        return const ConsultationRecordsPage();
      case 3:
        return const ChatPage(
          counselorId: 'counselor1', // 应该使用实际的咨询师ID
        );
      case 4:
        return const Center(child: Text('我的排班页面'));
      case 5:
        return const Center(child: Text('督导指导页面'));
      case 6:
        return const Center(child: Text('个人资料页面'));
      case 7:
        return const Center(child: Text('消息通知页面'));
      default:
        return const Center(child: Text('页面未找到'));
    }
  }
} 
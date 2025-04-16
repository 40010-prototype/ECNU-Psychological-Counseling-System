import 'package:flutter/material.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/admin/admin_dashboard_page.dart';
import 'package:psc_web/pages/dashboard/counselor/counselor_dashboard_page.dart';
import 'package:psc_web/pages/dashboard/supervisor/supervisor_dashboard_page.dart';

/// Dashboard路由器 - 根据用户角色选择正确的Dashboard页面
class DashboardRouter extends StatelessWidget {
  /// 用户角色
  final UserRole userRole;

  const DashboardRouter({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case UserRole.admin:
        return const AdminDashboardPage();
      case UserRole.counselor:
        return const CounselorDashboardPage();
      case UserRole.supervisor:
        return const SupervisorDashboardPage();
      default:
        // 默认情况下显示管理员dashboard
        return const AdminDashboardPage();
    }
  }
} 
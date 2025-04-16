import 'package:flutter/material.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/base/base_dashboard_page.dart';

/// 督导仪表盘页面
class SupervisorDashboardPage extends BaseDashboardPage {
  const SupervisorDashboardPage({Key? key}) : super(key: key);

  @override
  State<SupervisorDashboardPage> createState() => _SupervisorDashboardPageState();
}

class _SupervisorDashboardPageState extends BaseDashboardPageState<SupervisorDashboardPage> {
  @override
  List<MenuItemModel> getMenuItems() {
    return [
      MenuItemModel(
        title: '首页',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      MenuItemModel(
        title: '我的咨询师',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
      ),
      MenuItemModel(
        title: '督导案例',
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder,
      ),
      MenuItemModel(
        title: '督导评估',
        icon: Icons.assessment_outlined,
        activeIcon: Icons.assessment,
      ),
      MenuItemModel(
        title: '咨询记录审核',
        icon: Icons.fact_check_outlined,
        activeIcon: Icons.fact_check,
      ),
      MenuItemModel(
        title: '排班安排',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
      ),
      MenuItemModel(
        title: '个人资料',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
      ),
      MenuItemModel(
        title: '消息通知',
        icon: Icons.notifications_outlined,
        activeIcon: Icons.notifications,
      ),
    ];
  }
  
  @override
  UserRole getUserRole() {
    return UserRole.supervisor;
  }
} 
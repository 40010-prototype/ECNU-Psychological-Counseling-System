import 'package:flutter/material.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/base/base_dashboard_page.dart';

/// 管理员仪表盘页面
class AdminDashboardPage extends BaseDashboardPage {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends BaseDashboardPageState<AdminDashboardPage> {
  @override
  List<MenuItemModel> getMenuItems() {
    return [
      MenuItemModel(
        title: '首页',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      MenuItemModel(
        title: '咨询记录',
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
      ),
      MenuItemModel(
        title: '排班表',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
      ),
      MenuItemModel(
        title: '咨询师管理',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
      ),
      MenuItemModel(
        title: '督导管理',
        icon: Icons.support_agent_outlined,
        activeIcon: Icons.support_agent,
      ),
      MenuItemModel(
        title: '用户管理',
        icon: Icons.supervised_user_circle_outlined,
        activeIcon: Icons.supervised_user_circle,
      ),
      MenuItemModel(
        title: '预约管理',
        icon: Icons.event_available_outlined,
        activeIcon: Icons.event_available,
      ),
      MenuItemModel(
        title: '系统设置',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
      ),
    ];
  }
  
  @override
  UserRole getUserRole() {
    return UserRole.admin;
  }
} 
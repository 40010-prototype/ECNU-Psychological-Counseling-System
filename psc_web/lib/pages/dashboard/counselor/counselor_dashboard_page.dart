import 'package:flutter/material.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/base/base_dashboard_page.dart';

/// 咨询师仪表盘页面
class CounselorDashboardPage extends BaseDashboardPage {
  const CounselorDashboardPage({Key? key}) : super(key: key);

  @override
  State<CounselorDashboardPage> createState() => _CounselorDashboardPageState();
}

class _CounselorDashboardPageState extends BaseDashboardPageState<CounselorDashboardPage> {
  @override
  List<MenuItemModel> getMenuItems() {
    return [
      MenuItemModel(
        title: '首页',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      MenuItemModel(
        title: '我的预约',
        icon: Icons.event_available_outlined,
        activeIcon: Icons.event_available,
      ),
      MenuItemModel(
        title: '咨询记录',
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
      ),
      MenuItemModel(
        title: '聊天咨询',
        icon: Icons.chat_outlined,
        activeIcon: Icons.chat,
      ),
      MenuItemModel(
        title: '我的排班',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
      ),
      MenuItemModel(
        title: '督导指导',
        icon: Icons.support_agent_outlined,
        activeIcon: Icons.support_agent,
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
    return UserRole.counselor;
  }
} 
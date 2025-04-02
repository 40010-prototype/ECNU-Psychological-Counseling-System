import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/widgets/dashboard/sidebar.dart';
import 'package:psc_web/widgets/dashboard/right_panel.dart';
import 'package:psc_web/widgets/dashboard/content_view.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/providers/consultation/consultation_provider.dart';

/// 主面板页面
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // 选中的菜单项索引
  int _selectedIndex = 0;

  // 右侧面板是否展开
  bool _isRightPanelExpanded = true;

  // 主要菜单项
  final List<MenuItemModel> _menuItems = [
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

  // 动画控制器
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // 确保初始状态与_isRightPanelExpanded保持一致
    if (_isRightPanelExpanded) {
      _animationController.value = 1.0;
    } else {
      _animationController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 切换菜单项
  void _onSelectMenuItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 切换右侧面板
  void _toggleRightPanel() {
    setState(() {
      _isRightPanelExpanded = !_isRightPanelExpanded;
      if (_isRightPanelExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 尝试访问ConsultationProvider，验证是否已注册
    try {
      Provider.of<ConsultationProvider>(context, listen: false);
      print('ConsultationProvider 已成功注册');
    } catch (e) {
      print('ConsultationProvider 访问错误: $e');
    }
    
    return Scaffold(
      backgroundColor: colorScheme.background.withOpacity(0.95),
      body: Row(
        children: [
          // 左侧边栏
          SideBar(
            menuItems: _menuItems,
            selectedIndex: _selectedIndex,
            onSelectMenuItem: _onSelectMenuItem,
          ),
          
          // 中间内容区域
          Expanded(
            child: ContentView(
              selectedIndex: _selectedIndex,
              menuItem: _menuItems[_selectedIndex],
            ),
          ),
          
          // 右侧面板
          RightPanel(
            isExpanded: _isRightPanelExpanded,
            animationController: _animationController,
            onToggle: _toggleRightPanel,
          ),
        ],
      ),
    );
  }
}

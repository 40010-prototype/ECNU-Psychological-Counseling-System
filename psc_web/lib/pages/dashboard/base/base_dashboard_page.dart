import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/widgets/dashboard/sidebar.dart';
import 'package:psc_web/widgets/dashboard/right_panel.dart';
import 'package:psc_web/widgets/dashboard/role_content_view.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/consultation/consultation_provider.dart';

/// 基础仪表盘页面 - 所有角色dashboard的基类
abstract class BaseDashboardPage extends StatefulWidget {
  const BaseDashboardPage({Key? key}) : super(key: key);
}

abstract class BaseDashboardPageState<T extends BaseDashboardPage> extends State<T>
    with SingleTickerProviderStateMixin {
  // 选中的菜单项索引
  int _selectedIndex = 0;

  // 右侧面板是否展开
  bool _isRightPanelExpanded = true;

  // 动画控制器
  late AnimationController _animationController;

  /// 获取菜单项 - 子类必须实现此方法提供特定角色的菜单
  List<MenuItemModel> getMenuItems();
  
  /// 获取用户角色 - 子类必须实现此方法提供用户角色
  UserRole getUserRole();

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
    if (_isRightPanelExpanded) {
        _toggleRightPanel();
      }
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
    final menuItems = getMenuItems();
    final userRole = getUserRole();
    
    return Scaffold(
      backgroundColor: colorScheme.background.withOpacity(0.95),
      body: Row(
        children: [
          // 左侧边栏
          SideBar(
            menuItems: menuItems,
            selectedIndex: _selectedIndex,
            onSelectMenuItem: _onSelectMenuItem,
          ),
          
          // 中间内容区域
          Expanded(
            child: RoleContentView(
              selectedIndex: _selectedIndex,
              menuItem: menuItems[_selectedIndex],
              userRole: userRole,
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
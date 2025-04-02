import 'package:flutter/material.dart';
import 'package:psc_web/models/menu_item_model.dart';
import 'package:psc_web/theme/app_colors.dart';

/// 侧边栏组件
class SideBar extends StatefulWidget {
  /// 菜单项列表
  final List<MenuItemModel> menuItems;
  
  /// 选中的菜单项索引
  final int selectedIndex;
  
  /// 菜单项选择回调
  final Function(int) onSelectMenuItem;

  const SideBar({
    Key? key,
    required this.menuItems,
    required this.selectedIndex,
    required this.onSelectMenuItem,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  // 菜单项动画控制器
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _slideAnimations;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    _initAnimations();
    
    // 开始依次播放动画
    _playAnimationsSequentially();
  }
  
  // 初始化动画
  void _initAnimations() {
    _animationControllers = List.generate(
      widget.menuItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    
    _slideAnimations = List.generate(
      widget.menuItems.length,
      (index) => Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationControllers[index],
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }
  
  // 依次播放动画
  void _playAnimationsSequentially() async {
    for (int i = 0; i < _animationControllers.length; i++) {
      // 依次延迟播放每个动画，实现级联效果
      await Future.delayed(Duration(milliseconds: 100 * i));
      _animationControllers[i].forward();
    }
  }
  
  @override
  void dispose() {
    // 释放所有动画控制器
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: 250,
      color: colorScheme.surface,
      child: Column(
        children: [
          // 头部 Logo 区域
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.psychology,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '心理咨询系统',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // 分割线
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.primary.withOpacity(0.1),
          ),
          
          // 菜单列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: widget.menuItems.length,
              itemBuilder: (context, index) {
                final item = widget.menuItems[index];
                final isSelected = index == widget.selectedIndex;
                
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: _buildMenuItem(item, index, isSelected),
                );
              },
            ),
          ),
          
          // 底部区域
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '管理员',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '系统管理员',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  color: colorScheme.onSurface.withOpacity(0.7),
                  onPressed: () {
                    // 登出逻辑
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 构建菜单项
  Widget _buildMenuItem(MenuItemModel item, int index, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: () => widget.onSelectMenuItem(index),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // 左侧选中指示器
            if (isSelected)
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            
            // 图标
            Padding(
              padding: EdgeInsets.only(left: isSelected ? 12 : 16),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 22,
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 标题
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? colorScheme.primary 
                      : colorScheme.onSurface,
                ),
              ),
            ),
            
            // 徽章
            if (item.badgeCount != null && item.badgeCount! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badgeCount! > 99 ? '99+' : item.badgeCount.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 
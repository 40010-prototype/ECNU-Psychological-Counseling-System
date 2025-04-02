import 'package:flutter/material.dart';

/// 右侧面板组件
class RightPanel extends StatelessWidget {
  /// 是否展开
  final bool isExpanded;

  /// 动画控制器
  final AnimationController animationController;

  /// 切换回调
  final VoidCallback onToggle;

  const RightPanel({
    Key? key,
    required this.isExpanded,
    required this.animationController,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 宽度动画
    final Animation<double> widthAnimation = Tween<double>(
      begin: 80.0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // 内容透明度动画
    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          width: widthAnimation.value,
          color: colorScheme.surface,
          child: Column(
            children: [
              // 头部 - 包含收起按钮
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isExpanded 
                            ? Icons.chevron_right 
                            : Icons.chevron_left,
                        color: colorScheme.primary,
                      ),
                      onPressed: onToggle,
                      tooltip: isExpanded ? '收起面板' : '展开面板',
                    ),
                    
                    // 标题 - 仅在展开时显示
                    if (widthAnimation.value > 120)
                      Expanded(
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: Text(
                            '通知',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // 内容区域
              Expanded(
                child: isExpanded
                    ? FadeTransition(
                        opacity: fadeAnimation,
                        child: _buildExpandedContent(context),
                      )
                    : _buildCollapsedContent(context),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // 收起状态内容
  Widget _buildCollapsedContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 通知图标
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 12),
          padding: const EdgeInsets.only(left: 18),
          width: double.infinity,
          height: 40,
          alignment: Alignment.centerLeft,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: colorScheme.onSurface.withOpacity(0.7),
                size: 24,
              ),
              // 角标
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: colorScheme.onError,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 消息图标
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.only(left: 18),
          width: double.infinity,
          height: 40,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.mail_outline,
            color: colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
        ),
        
        // 设置图标
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.only(left: 18),
          width: double.infinity,
          height: 40,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.settings_outlined,
            color: colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
        ),
      ],
    );
  }
  
  // 展开状态内容
  Widget _buildExpandedContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 未读通知标题
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '未读通知',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        
        // 通知项
        _buildNotificationItem(
          context,
          title: '系统通知',
          message: '您有3条未读消息',
          time: '10分钟前',
          icon: Icons.notifications,
        ),
        
        _buildNotificationItem(
          context,
          title: '排班更新',
          message: '下周排班表已更新',
          time: '1小时前',
          icon: Icons.calendar_today,
        ),
        
        _buildNotificationItem(
          context,
          title: '新咨询预约',
          message: '有新的咨询预约请及时处理',
          time: '2小时前',
          icon: Icons.event_note,
          isUnread: true,
        ),
        
        // 已读通知标题
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            '已读通知',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        
        // 已读通知项
        _buildNotificationItem(
          context,
          title: '系统维护',
          message: '系统将于周日凌晨2点进行例行维护',
          time: '昨天',
          icon: Icons.info_outline,
          isUnread: false,
        ),
        
        _buildNotificationItem(
          context,
          title: '账号安全',
          message: '您的账号已成功登录',
          time: '3天前',
          icon: Icons.security,
          isUnread: false,
        ),
      ],
    );
  }
  
  // 通知项
  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    required IconData icon,
    bool isUnread = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread 
            ? colorScheme.primary.withOpacity(0.1) 
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // 查看通知详情
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUnread 
                        ? colorScheme.primary.withOpacity(0.2) 
                        : colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isUnread 
                        ? colorScheme.primary 
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isUnread 
                                    ? colorScheme.primary 
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
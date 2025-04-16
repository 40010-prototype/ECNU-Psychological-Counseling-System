import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/chat/chat_session.dart';
import 'package:psc_web/providers/chat/chat_provider.dart';

/// 聊天会话列表组件
class SessionList extends StatelessWidget {
  const SessionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // 显示加载状态
        if (chatProvider.isLoadingSessions) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // 显示错误信息
        if (chatProvider.error != null && (chatProvider.sessions == null || chatProvider.sessions!.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatProvider.error!,
                  style: TextStyle(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => chatProvider.loadSessions(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        // 显示空会话列表
        if (chatProvider.sessions == null || chatProvider.sessions!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无聊天会话',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }
        
        // 显示会话列表
        return Column(
          children: [
            // 搜索框
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            
            // 在线状态选择器
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('全部')),
                  ButtonSegment(value: 'active', label: Text('活跃')),
                  ButtonSegment(value: 'inactive', label: Text('非活跃')),
                ],
                selected: const {'all'},
                onSelectionChanged: (values) {
                  // 实现过滤功能
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 会话列表
            Expanded(
              child: ListView.builder(
                itemCount: chatProvider.sessions!.length,
                itemBuilder: (context, index) {
                  final session = chatProvider.sessions![index];
                  return _buildSessionItem(context, session, chatProvider);
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildSessionItem(BuildContext context, ChatSession session, ChatProvider chatProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive = chatProvider.activeSessionId == session.id;
    
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      color: isActive
          ? colorScheme.primaryContainer.withOpacity(0.3)
          : colorScheme.surface,
      elevation: isActive ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: colorScheme.primary, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => chatProvider.selectSession(session.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              // 头像
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      session.clientName[0],
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (session.status == SessionStatus.active)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // 会话信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名字和时间
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 名字
                        Text(
                          session.clientName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // 时间
                        Text(
                          _formatTime(session.lastMessageTime),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // 最后消息和未读数
                    Row(
                      children: [
                        // 最后消息
                        Expanded(
                          child: Text(
                            session.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                        
                        // 未读数
                        if (session.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              session.unreadCount.toString(),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
    } else if (difference.inDays > 0) {
      return '${dateTime.month}月${dateTime.day}日';
    } else if (difference.inHours > 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
} 
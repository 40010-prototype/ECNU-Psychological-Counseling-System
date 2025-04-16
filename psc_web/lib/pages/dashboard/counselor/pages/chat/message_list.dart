import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/chat/chat_message.dart';
import 'package:psc_web/providers/chat/chat_provider.dart';
import 'package:intl/intl.dart';

/// 聊天消息列表组件
class MessageList extends StatefulWidget {
  /// 咨询师ID
  final String counselorId;

  const MessageList({
    Key? key,
    required this.counselorId,
  }) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // 在收到新消息时滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // 如果没有选中的会话
        if (chatProvider.activeSessionId == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '选择一个会话开始聊天',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }
        
        // 显示加载状态
        if (chatProvider.isLoadingMessages) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // 显示错误信息
        if (chatProvider.error != null && (chatProvider.activeSessionMessages == null || chatProvider.activeSessionMessages!.isEmpty)) {
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
                  onPressed: () {
                    if (chatProvider.activeSessionId != null) {
                      chatProvider.loadMessages(chatProvider.activeSessionId!);
                    }
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        // 显示空消息列表
        if (chatProvider.activeSessionMessages == null || chatProvider.activeSessionMessages!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message_outlined,
                  size: 48,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无消息',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }
        
        // 在构建完成后滚动到底部
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
        
        // 显示消息列表
        final messages = chatProvider.activeSessionMessages!;
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final previousMessage = index > 0 ? messages[index - 1] : null;
            
            // 是否显示日期分隔线
            final showDateDivider = previousMessage == null ||
                !_isSameDay(previousMessage.timestamp, message.timestamp);
            
            return Column(
              children: [
                // 日期分隔线
                if (showDateDivider)
                  _buildDateDivider(context, message.timestamp),
                
                // 消息气泡
                _buildMessageBubble(context, message),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildDateDivider(BuildContext context, DateTime dateTime) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(dateTime),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMine = message.senderId == widget.counselorId;
    
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          color: isMine
              ? colorScheme.primary.withOpacity(0.8)
              : colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isMine ? 50 : 0,
            right: isMine ? 0 : 50,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 消息内容
                Text(
                  message.content,
                  style: TextStyle(
                    color: isMine ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
                
                // 时间和状态
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 时间
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: textTheme.bodySmall?.copyWith(
                        color: isMine
                            ? colorScheme.onPrimary.withOpacity(0.7)
                            : colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                    
                    // 状态图标（仅自己的消息显示）
                    if (isMine) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(context, message.status),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusIcon(BuildContext context, MessageStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.check,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.failed:
        return Icon(
          Icons.error_outline,
          size: 12,
          color: Colors.red[300],
        );
    }
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    
    if (_isSameDay(dateTime, now)) {
      return '今天';
    } else if (_isSameDay(dateTime, now.subtract(const Duration(days: 1)))) {
      return '昨天';
    } else if (dateTime.year == now.year) {
      return DateFormat('MM月dd日').format(dateTime);
    } else {
      return DateFormat('yyyy年MM月dd日').format(dateTime);
    }
  }
  
  String _formatMessageTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/pages/dashboard/counselor/pages/chat/session_list.dart';
import 'package:psc_web/pages/dashboard/counselor/pages/chat/message_list.dart';
import 'package:psc_web/pages/dashboard/counselor/pages/chat/message_input.dart';
import 'package:psc_web/services/chat/websocket_chat_service.dart';
import 'package:psc_web/providers/chat/chat_provider.dart';

/// 咨询师聊天页面
class ChatPage extends StatelessWidget {
  final String counselorId;

  const ChatPage({
    Key? key,
    required this.counselorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        WebSocketChatService(
          userId: counselorId,
        ),
      ),
      child: ChatView(counselorId: counselorId),
    );
  }
}

/// 聊天视图组件
class ChatView extends StatelessWidget {
  final String counselorId;

  const ChatView({
    Key? key,
    required this.counselorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 768;
    final activeSessionId = context.select<ChatProvider, String?>((p) => p.activeSessionId);

    return Stack(
      children: [
        isNarrow
            ? _buildNarrowLayout(context, activeSessionId)
            : _buildWideLayout(context),
        
        // 悬浮刷新按钮
        Positioned(
          bottom: 80.0,
          right: 16.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                final provider = Provider.of<ChatProvider>(context, listen: false);
                provider.loadSessions();
              },
              tooltip: '刷新会话列表',
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.refresh),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建窄屏布局（主要是移动设备）
  Widget _buildNarrowLayout(BuildContext context, String? activeSessionId) {
    if (activeSessionId == null) {
      return const SessionList();
    } else {
      return Column(
        children: [
          Expanded(
            child: MessageList(counselorId: counselorId),
          ),
          MessageInput(),
        ],
      );
    }
  }

  /// 构建宽屏布局（主要是桌面设备）
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: const SessionList(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: MessageList(counselorId: counselorId),
              ),
              MessageInput(),
            ],
          ),
        ),
      ],
    );
  }
} 
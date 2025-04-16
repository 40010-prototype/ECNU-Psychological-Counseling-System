import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/chat/chat_provider.dart';

/// 消息输入框组件
class MessageInput extends StatefulWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  /// 发送消息
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      return;
    }
    
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    
    // 调用Provider发送消息
    context.read<ChatProvider>().sendMessage(text);
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final isConnected = chatProvider.isConnected;
        final hasActiveSession = chatProvider.activeSessionId != null;
        final isLoading = chatProvider.isSendingMessage;
        
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              // 附件按钮
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: hasActiveSession && isConnected
                    ? () {
                        // 处理附件上传
                      }
                    : null,
                tooltip: '发送附件',
              ),
              
              // 表情按钮
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: hasActiveSession && isConnected
                    ? () {
                        // 显示表情选择器
                      }
                    : null,
                tooltip: '表情',
              ),
              
              // 输入框
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText
                        :!isConnected
                            ? '连接断开...'
                        : !hasActiveSession
                            ? '选择一个会话开始聊天'
                            : '输入消息...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  maxLines: 5,
                  minLines: 1,
                  enabled: hasActiveSession && isConnected,
                  textInputAction: TextInputAction.send,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.trim().isNotEmpty;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 发送按钮
              isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      color: _isComposing ? colorScheme.primary : null,
                      onPressed: hasActiveSession && isConnected && _isComposing
                          ? () => _handleSubmitted(_controller.text)
                          : null,
                      tooltip: '发送',
                    ),
            ],
          ),
        );
      },
    );
  }
} 
import 'package:flutter/material.dart';
import '../../widgets/inputs/styled_text_field.dart';

/// 登录表单组件
class LoginForm extends StatefulWidget {
  final VoidCallback onToggleView;

  const LoginForm({
    Key? key,
    required this.onToggleView,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // 处理登录逻辑
    print('登录: 用户名=${_usernameController.text}, 密码=${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 450,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 登录标题
            Text(
              '欢迎登录',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '请使用您的账号和密码登录系统',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),

            // 用户名输入框
            StyledTextField(
              controller: _usernameController,
              labelText: '用户名',
              hintText: '请输入您的用户名',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 24),

            // 密码输入框
            StyledTextField(
              controller: _passwordController,
              labelText: '密码',
              hintText: '请输入您的密码',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              obscurePassword: _obscurePassword,
              onToggleObscure: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            const SizedBox(height: 16),

            // 记住我和忘记密码行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 记住我选项
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '记住我',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // 忘记密码
                TextButton(
                  onPressed: () {
                    // 处理忘记密码逻辑
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text('忘记密码?'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 登录按钮
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // 添加阴影提升立体感
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text(
                '登录',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 注册账号链接
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '还没有账号? ',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: widget.onToggleView,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text('立即注册'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 左侧登录欢迎内容组件
class LoginWelcomeContent extends StatelessWidget {
  final VoidCallback onToggleView;

  const LoginWelcomeContent({
    Key? key,
    required this.onToggleView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final decorationTextColor = colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标和标题
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              Icons.psychology,
              size: 40,
              color: decorationTextColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '心理咨询系统',
            style: textTheme.headlineMedium?.copyWith(
              color: decorationTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '倾听心声，守护健康',
            style: textTheme.titleMedium?.copyWith(
              color: decorationTextColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 40),

          // 注册按钮
          ElevatedButton(
            onPressed: onToggleView,
            style: ElevatedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              // 添加阴影
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              '注册账号',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
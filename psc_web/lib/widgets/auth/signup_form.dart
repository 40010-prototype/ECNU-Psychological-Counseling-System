import 'package:flutter/material.dart';
import '../../widgets/inputs/styled_text_field.dart';

/// 注册表单组件
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    // 注册逻辑
    print('注册: 用户名=${_usernameController.text}, 邮箱=${_emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 圆形图标背景
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              Icons.app_registration,
              size: 40,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '创建账号',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '填写信息以注册新账号',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),

          // 用户名
          StyledTextField(
            controller: _usernameController,
            labelText: '用户名',
            hintText: '请输入用户名',
            prefixIcon: Icons.person_outline,
            isDarkMode: true,
          ),
          const SizedBox(height: 16),

          // 邮箱
          StyledTextField(
            controller: _emailController,
            labelText: '邮箱',
            hintText: '请输入您的邮箱',
            prefixIcon: Icons.email_outlined,
            isDarkMode: true,
          ),
          const SizedBox(height: 16),

          // 密码
          StyledTextField(
            controller: _passwordController,
            labelText: '密码',
            hintText: '请输入密码',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscurePassword: _obscurePassword,
            onToggleObscure: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            isDarkMode: true,
          ),
          const SizedBox(height: 16),

          // 确认密码
          StyledTextField(
            controller: _confirmPasswordController,
            labelText: '确认密码',
            hintText: '请再次输入密码',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscurePassword: _obscureConfirmPassword,
            onToggleObscure: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            isDarkMode: true,
          ),
          const SizedBox(height: 32),

          // 注册按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSignup,
              style: ElevatedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text(
                '注册',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 右侧注册欢迎内容组件
class SignupWelcomeContent extends StatelessWidget {
  final VoidCallback onToggleView;

  const SignupWelcomeContent({
    Key? key,
    required this.onToggleView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 圆形图标背景
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.2),
            ),
            child: Icon(
              Icons.psychology,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '已有账号?',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '立即登录，开始您的心理健康之旅',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 40),

          // 去登录按钮
          SizedBox(
            width: 200, // 限制按钮宽度
            child: ElevatedButton(
              onPressed: onToggleView,
              style: ElevatedButton.styleFrom(
                foregroundColor: colorScheme.onPrimary,
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: Text(
                '去登录',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
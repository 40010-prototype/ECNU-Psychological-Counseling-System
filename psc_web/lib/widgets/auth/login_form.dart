import 'package:flutter/material.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/widgets/inputs/styled_text_field.dart';

/// 登录表单组件
class LoginForm extends StatefulWidget {
  final VoidCallback onToggleView;

  const LoginForm({super.key, required this.onToggleView});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // // 处理登录逻辑
    // print('登录: 用户名=${_usernameController.text}, 密码=${_passwordController.text}');

    // // 模拟用户角色 (在实际应用中，这将从后端获取)
    // UserRole userRole;

    // // 简单示例：根据用户名判断角色
    // if (_usernameController.text.contains('admin')) {
    //   userRole = UserRole.admin;
    // } else if (_usernameController.text.contains('counselor')) {
    //   userRole = UserRole.counselor;
    // } else if (_usernameController.text.contains('supervisor')) {
    //   userRole = UserRole.supervisor;
    // } else {
    //   // 默认角色
    //   userRole = UserRole.client;
    // }

    // // 登录成功后导航到仪表盘页面，并传递用户角色
    // Navigator.pushReplacementNamed(
    //   context,
    //   '/dashboard',
    //   arguments: {'userRole': userRole},
    // );

    // return;


    if (_formKey.currentState?.validate() ?? true) {
      setState(() {
        _isLoading = true; // 开始登录时显示加载
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      bool loginSuccess = await authProvider.login(username, password);

      if (loginSuccess) {
        // 登录成功后获取用户数据
        bool userDataFetched = await authProvider.fetchUserData();
        setState(() {
          _isLoading = authProvider.isFetchingUserData; // 更新加载状态
        });
        if (userDataFetched) {
          final loggedInUser = authProvider.loggedInUser;
          if (loggedInUser != null && loggedInUser.role != null) {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
              arguments: {'userRole': loggedInUser.role},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('登录成功，但用户信息获取失败。')),
            );
            print('错误：登录成功但用户信息或角色为空');
            setState(() {
              _isLoading = false; // 发生错误停止加载
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.errorMessage ?? '获取用户数据失败。')),
          );
          setState(() {
            _isLoading = false; // 获取数据失败停止加载
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? '登录失败，请检查用户名和密码。')),
        );
        setState(() {
          _isLoading = false; // 登录失败停止加载
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // 添加阴影提升立体感
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text(
                '登录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // 注册账号链接
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '还没有账号? ',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
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

  const LoginWelcomeContent({super.key, required this.onToggleView});

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
            child: Icon(Icons.psychology, size: 40, color: decorationTextColor),
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              // 添加阴影
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              '注册账号',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

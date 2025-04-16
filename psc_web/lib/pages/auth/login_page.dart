import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/signup_form.dart';
import '../../widgets/auth/animated_container.dart';
import '../../widgets/auth/auth_decorations.dart';
import '../../utils/animations/login_animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // 动画控制器
  late LoginAnimationController _animationController;
  
  // 防止重复点击标志
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _animationController = LoginAnimationController(this);
    
    // 添加状态监听以更新UI
    _animationController.controller.addStatusListener(_updateAnimationStatus);
    
    // 设置性能优化
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // 预先加载Widget树，减少首次动画卡顿
      precacheLoginComponents();
    });
  }

  @override
  void dispose() {
    // 移除监听器，防止内存泄漏
    _animationController.controller.removeStatusListener(_updateAnimationStatus);
    _animationController.dispose();
    super.dispose();
  }

  // 更新动画状态，仅在必要时调用setState
  void _updateAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  // 预缓存组件提高性能
  void precacheLoginComponents() {
    // 预热部分组件图像资源
    precacheImage(const AssetImage('assets/images/logo.png'), context);
  }

  // 切换登录/注册视图
  void _toggleView() {
    if (_isAnimating) return; // 防止重复点击

    setState(() {
      _isAnimating = true;
    });

    try {
      _animationController.toggleView();
    } catch (e) {
      // 错误处理
      debugPrint('动画执行出错: $e');
      setState(() {
        _isAnimating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 使用RepaintBoundary包装整个登录界面提高性能
    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            // 背景装饰
            Positioned.fill(
              child: AuthDecorations.buildBackground(context, _animationController.slideAnimation),
            ),

            // 主内容区域
            Row(
              children: [
                // 左侧区域 - 动画容器
                LeftAnimatedContainer(
                  animationController: _animationController,
                  onToggleView: _toggleView,
                  loginWelcomeContent: LoginWelcomeContent(onToggleView: _toggleView),
                  signupFormContent: SignupForm(onToggleView: _toggleView),
                ),

                // 右侧区域 - 动画容器
                RightAnimatedContainer(
                  animationController: _animationController,
                  onToggleView: _toggleView,
                  loginFormContent: LoginForm(onToggleView: _toggleView),
                  signupWelcomeContent: SignupWelcomeContent(onToggleView: _toggleView),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
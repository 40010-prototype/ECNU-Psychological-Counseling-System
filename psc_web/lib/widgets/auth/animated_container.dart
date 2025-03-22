import 'package:flutter/material.dart';
import '../../utils/animations/login_animations.dart';
import 'auth_decorations.dart';

/// 左侧动画容器（包含登录欢迎内容或注册表单，取决于当前状态）
class LeftAnimatedContainer extends StatelessWidget {
  final LoginAnimationController animationController;
  final VoidCallback onToggleView;
  final Widget loginWelcomeContent;
  final Widget signupFormContent;

  const LeftAnimatedContainer({
    Key? key,
    required this.animationController,
    required this.onToggleView,
    required this.loginWelcomeContent,
    required this.signupFormContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      // 通过添加空的builder，避免整个子树重建
      builder: (context, child) {
        // 精确控制宽度比例：
        // 登录状态（动画值为0）: 左侧40%, 右侧60%
        // 注册状态（动画值为1）: 左侧60%, 右侧40%
        final leftWidth =
            size.width *
            (0.4 + (animationController.slideAnimation.value * 0.2));

        return SizedBox(width: leftWidth, height: size.height, child: child);
      },
      // 将不需要每帧重建的内容移到这里
      child: Stack(
        children: [
          // 装饰背景 - 包装在RepaintBoundary来隔离绘制
          RepaintBoundary(child: _buildLeftSideBackground()),

          // 登录欢迎内容和注册表单内容 - 使用独立的AnimatedBuilder
          _buildLoginContent(),
          _buildSignupContent(),
        ],
      ),
    );
  }

  // 背景装饰 - 独立方法便于维护
  Widget _buildLeftSideBackground() {
    return Builder(
      builder: (context) {
        return AuthDecorations.buildLeftSideDecorations(
          context,
          MediaQuery.of(context).size.width * 0.6,
        ); // 使用最大宽度
      },
    );
  }

  // 登录欢迎内容
  Widget _buildLoginContent() {
    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      builder: (context, child) {
        return Opacity(
          opacity:
              animationController.slideAnimation.value <= 0.5
                  ? 1.0 - (animationController.slideAnimation.value * 2)
                  : 0.0,
          child: Transform.translate(
            offset: Offset(-100 * animationController.slideAnimation.value, 0),
            child: child,
          ),
        );
      },
      child: loginWelcomeContent, // 传入子组件避免重建
    );
  }

  // 注册表单内容
  Widget _buildSignupContent() {
    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      builder: (context, child) {
        // 只有当需要显示时才渲染
        if (animationController.slideAnimation.value < 0.3) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity:
              animationController.slideAnimation.value >= 0.5
                  ? (animationController.slideAnimation.value - 0.5) * 2
                  : 0.0,
          child: Transform.translate(
            offset: Offset(
              100 * (1.0 - animationController.slideAnimation.value),
              0,
            ),
            child: child,
          ),
        );
      },
      child: signupFormContent, // 传入子组件避免重建
    );
  }
}

/// 右侧动画容器（包含登录表单或注册欢迎内容，取决于当前状态）
class RightAnimatedContainer extends StatelessWidget {
  final LoginAnimationController animationController;
  final VoidCallback onToggleView;
  final Widget loginFormContent;
  final Widget signupWelcomeContent;

  const RightAnimatedContainer({
    Key? key,
    required this.animationController,
    required this.onToggleView,
    required this.loginFormContent,
    required this.signupWelcomeContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 右侧装饰区域
            _buildRightSideBackground(context),

            // 登录表单内容
            _buildLoginFormContent(),

            // 注册欢迎内容
            _buildSignupWelcomeContent(context),
          ],
        ),
      ),
    );
  }

  // 右侧背景装饰
  Widget _buildRightSideBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      builder: (context, _) {
        // 只在动画过半时显示
        if (animationController.slideAnimation.value < 0.5) {
          return const SizedBox.shrink();
        }

        return AuthDecorations.buildRightSideDecorations(
          context,
          animationController.slideAnimation,
          size,
        );
      },
    );
  }

  // 登录表单内容
  Widget _buildLoginFormContent() {
    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      builder: (context, child) {
        // 当动画过大值时不再渲染，提高性能
        if (animationController.slideAnimation.value > 0.9) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity:
              animationController.slideAnimation.value <= 0.5
                  ? 1.0
                  : 1.0 -
                      ((animationController.slideAnimation.value - 0.5) * 2),
          child: Transform.translate(
            offset: Offset(100 * animationController.slideAnimation.value, 0),
            child: child,
          ),
        );
      },
      child: loginFormContent, // 传入子组件避免重建
    );
  }

  // 注册欢迎内容
  Widget _buildSignupWelcomeContent(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController.slideAnimation,
      builder: (context, child) {
        // 只在动画值大于0.5时显示
        if (animationController.slideAnimation.value < 0.5) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: ((animationController.slideAnimation.value - 0.5) * 2).clamp(
            0.0,
            1.0,
          ),
          child: child,
        );
      },
      child: signupWelcomeContent, // 传入子组件避免重建
    );
  }
}

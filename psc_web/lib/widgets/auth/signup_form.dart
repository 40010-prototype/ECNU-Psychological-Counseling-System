import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/auth/auth_provider.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/routes/app_routes.dart';
import 'package:psc_web/theme/app_colors.dart';
import 'package:psc_web/widgets/auth/signup_progress_indicator.dart';
import 'package:psc_web/widgets/auth/signup_steps/basic_info_form.dart';
import 'package:psc_web/widgets/auth/signup_steps/role_specific_form.dart';
import 'package:psc_web/widgets/auth/signup_steps/confirmation_form.dart';

/// 注册表单组件
class SignupForm extends StatefulWidget {
  final VoidCallback onToggleView;

  const SignupForm({
    super.key,
    required this.onToggleView,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 680;
    final padding = isSmallScreen ? 12.0 : 16.0;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          // 进度指示器
          if (!isSmallScreen) const SignupProgressIndicator(),
          SizedBox(height: isSmallScreen ? 8 : 12),
          
          // 表单内容
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildCurrentStep(registerProvider.currentStep),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return BasicInfoForm(
          key: const ValueKey('basic_info'),
          onNext: () {
            final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
            registerProvider.updateStep(1);
          },
        );
      case 1:
        return RoleSpecificForm(
          key: const ValueKey('role_specific'),
          onNext: () {
            final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
            registerProvider.updateStep(2);
          },
          onPrevious: () {
            final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
            registerProvider.updateStep(0);
          },
        );
      case 2:
        return ConfirmationForm(
          key: const ValueKey('confirmation'),
          onPrevious: () {
            final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
            registerProvider.updateStep(1);
          },
          onRegister: _handleRegister,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleRegister() async {
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // 显示加载指示器
    setState(() {
      // 可以添加一个本地状态来显示加载中
    });
    
    final response = await registerProvider.register();
    
    if (response.success) {
      // 注册并自动登录成功后，获取用户信息
      final userDataSuccess = await authProvider.fetchUserData();
      
      if (userDataSuccess && mounted) {
        // 成功获取用户信息，跳转到仪表盘
        final loggedInUser = authProvider.loggedInUser;
        if (loggedInUser != null) {
          Navigator.pushReplacementNamed(
            context,
            AppRoute.dashboardRoute,
            arguments: {'userRole': loggedInUser.role},
          );
          
          // 清除注册表单数据
          registerProvider.clearFormData();
          return;
        }
      }
      
      // 如果获取用户信息失败，但注册成功，返回登录页面
      if (mounted) {
        widget.onToggleView();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('注册成功，请登录您的账号'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } else {
      // 显示错误信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? '注册失败'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}

/// 右侧注册欢迎内容组件
class SignupWelcomeContent extends StatelessWidget {
  final VoidCallback onToggleView;

  const SignupWelcomeContent({
    super.key,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: Icon(
              Icons.psychology,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '已有账号?',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '立即登录，开始您的心理健康之旅',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),

          // 去登录按钮
          SizedBox(
            width: 200, // 限制按钮宽度
            child: ElevatedButton(
              onPressed: onToggleView,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text(
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
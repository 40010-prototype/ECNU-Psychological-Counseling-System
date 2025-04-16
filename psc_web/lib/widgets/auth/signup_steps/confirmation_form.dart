import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/theme/app_colors.dart';

class ConfirmationForm extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onRegister;

  const ConfirmationForm({
    super.key,
    required this.onPrevious,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final formData = registerProvider.formData;
    final profile = formData['profile'] as Map<String, dynamic>?;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 680;
    final isMobile = screenSize.width < 600;
    
    // 根据屏幕大小调整内边距和垂直间距
    final double verticalPadding = isSmallScreen ? 10.0 : 16.0;
    final double verticalGap = isSmallScreen ? 8.0 : 16.0;
    final double fontSize = isSmallScreen ? 13.0 : 14.0;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isSmallScreen) ...[
              // 成功图标
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: isSmallScreen ? 24 : 32,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              
              // 标题
              Text(
                '请确认您的注册信息',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              
              // 子标题
              Text(
                '确认信息无误后点击"注册"完成注册',
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: verticalGap),
            ],
            
            // 信息卡片 - 使用Expanded和ListView防止溢出
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 基本信息
                          _buildSection(
                            context,
                            '基本信息',
                            Icons.person_outline,
                            [
                              _buildInfoRow('用户名', formData['username'], isMobile, isSmallScreen),
                              _buildInfoRow('姓名', formData['name'], isMobile, isSmallScreen),
                              _buildInfoRow('邮箱', formData['email'], isMobile, isSmallScreen),
                              if (formData['phone'] != null && formData['phone'] != '')
                                _buildInfoRow('电话', formData['phone'], isMobile, isSmallScreen),
                              _buildInfoRow('角色', _getRoleName(registerProvider.selectedRole), isMobile, isSmallScreen),
                            ],
                            isSmallScreen,
                          ),
                          
                          const Divider(height: 32),
                          
                          // 角色特定信息
                          if (profile != null)
                            _buildSection(
                              context,
                              _getRoleSpecificTitle(registerProvider.selectedRole),
                              _getRoleIcon(registerProvider.selectedRole),
                              _buildRoleSpecificInfo(registerProvider.selectedRole, profile, isMobile, isSmallScreen),
                              isSmallScreen,
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalGap),
                  
                  // 隐私政策同意
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassBgLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 12, 
                      vertical: isSmallScreen ? 6 : 8
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: isSmallScreen ? 0.8 : 1.0,
                          child: Checkbox(
                            value: true, // TODO: 添加状态管理
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              // TODO: 处理同意状态
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: isSmallScreen ? 2 : 4),
                            child: Text.rich(
                              TextSpan(
                                text: '我已阅读并同意',
                                children: [
                                  TextSpan(
                                    text: '《用户协议》',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(text: '和'),
                                  TextSpan(
                                    text: '《隐私政策》',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: fontSize,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: verticalGap),
            
            // 按钮行
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 上一步按钮
                OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 20,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: isSmallScreen ? 14 : 16),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Text(
                        '上一步',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 20),
                // 注册按钮
                ElevatedButton(
                  onPressed: onRegister,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.buttonPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 20,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '注册',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Icon(Icons.check_circle_outline, size: isSmallScreen ? 14 : 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<Widget> children, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: isSmallScreen ? 16 : 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value, bool isMobile, bool isSmallScreen) {
    final fontSize = isSmallScreen ? 13.0 : 14.0;
    final labelSize = isSmallScreen ? 12.0 : 13.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelSize,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.toString() ?? '未填写',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: labelSize,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value?.toString() ?? '未填写',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getRoleName(UserRole? role) {
    switch (role) {
      case UserRole.counselor:
        return '咨询师';
      case UserRole.supervisor:
        return '督导';
      default:
        return '未知';
    }
  }

  String _getRoleSpecificTitle(UserRole? role) {
    switch (role) {
      case UserRole.counselor:
        return '咨询师信息';
      case UserRole.supervisor:
        return '督导信息';
      default:
        return '详细信息';
    }
  }

  IconData _getRoleIcon(UserRole? role) {
    switch (role) {
      case UserRole.counselor:
        return Icons.psychology_outlined;
      case UserRole.supervisor:
        return Icons.supervised_user_circle_outlined;
      default:
        return Icons.info_outline;
    }
  }

  List<Widget> _buildRoleSpecificInfo(UserRole? role, Map<String, dynamic> profile, bool isMobile, bool isSmallScreen) {
    switch (role) {
      case UserRole.counselor:
        return [
          _buildInfoRow('职称', profile['title'], isMobile, isSmallScreen),
          _buildInfoRow('资质', profile['qualification'], isMobile, isSmallScreen),
          _buildInfoRow('专长领域', (profile['expertise'] as List?)?.join(', ') ?? '未填写', isMobile, isSmallScreen),
          _buildInfoRow('个人简介', profile['introduction'], isMobile, isSmallScreen),
        ];
      case UserRole.supervisor:
        return [
          _buildInfoRow('职称', profile['title'], isMobile, isSmallScreen),
          _buildInfoRow('资质', profile['qualification'], isMobile, isSmallScreen),
          _buildInfoRow('专长领域', (profile['expertise'] as List?)?.join(', ') ?? '未填写', isMobile, isSmallScreen),
          _buildInfoRow('个人简介', profile['introduction'], isMobile, isSmallScreen),
        ];
      default:
        return [];
    }
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/theme/app_colors.dart';
import 'package:psc_web/widgets/inputs/styled_text_field.dart';

class RoleSpecificForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const RoleSpecificForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<RoleSpecificForm> createState() => _RoleSpecificFormState();
}

class _RoleSpecificFormState extends State<RoleSpecificForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, bool> _obscureText;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    
    switch (registerProvider.selectedRole) {
      case UserRole.counselor:
        _controllers = {
          'title': TextEditingController(),
          'qualification': TextEditingController(),
          'introduction': TextEditingController(),
        };
        break;
      case UserRole.supervisor:
        _controllers = {
          'title': TextEditingController(),
          'qualification': TextEditingController(),
          'introduction': TextEditingController(),
        };
        break;
      default:
        _controllers = {};
    }
    
    _obscureText = {
      for (var key in _controllers.keys) key: false,
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
      final profile = <String, dynamic>{};
      
      // 根据角色收集特定信息
      switch (registerProvider.selectedRole) {
        case UserRole.counselor:
          profile['title'] = _controllers['title']!.text;
          profile['qualification'] = _controllers['qualification']!.text;
          profile['expertise'] = []; // 需要实现多选
          profile['introduction'] = _controllers['introduction']!.text;
          break;
        case UserRole.supervisor:
          profile['title'] = _controllers['title']!.text;
          profile['qualification'] = _controllers['qualification']!.text;
          profile['expertise'] = []; // 需要实现多选
          profile['introduction'] = _controllers['introduction']!.text;
          profile['supervisees'] = []; // 初始为空
          break;
        default:
          break;
      }
      
      registerProvider.updateFormData('profile', profile);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 680;
    final isMobile = screenSize.width < 600;
    
    // 根据屏幕大小调整内边距和垂直间距
    final double verticalPadding = isSmallScreen ? 10.0 : 16.0;
    final double verticalGap = isSmallScreen ? 8.0 : 16.0;
    final double fieldGap = isSmallScreen ? 10.0 : 16.0;
    final double iconSize = isSmallScreen ? 28.0 : 32.0;

    // 根据角色获取表单标题
    String formTitle = '';
    String formSubtitle = '';
    
    switch (registerProvider.selectedRole) {
      case UserRole.counselor:
        formTitle = '咨询师信息';
        formSubtitle = '请填写您的专业资质信息';
        break;
      case UserRole.supervisor:
        formTitle = '督导信息';
        formSubtitle = '请填写您的专业资质信息';
        break;
      default:
        break;
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isSmallScreen) ...[
                // 角色图标
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getRoleIcon(registerProvider.selectedRole),
                    size: iconSize,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                // 标题
                Text(
                  formTitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 8),
                
                // 子标题
                Text(
                  formSubtitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: verticalGap),
              ],
              
              // 根据角色显示不同的表单
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Builder(builder: (context) {
                      Widget roleForm;
                      
                      switch (registerProvider.selectedRole) {
                        case UserRole.counselor:
                          roleForm = _buildCounselorForm(isSmallScreen, fieldGap);
                          break;
                        case UserRole.supervisor:
                          roleForm = _buildSupervisorForm(isSmallScreen, fieldGap);
                          break;
                        default:
                          roleForm = const SizedBox.shrink();
                      }
                      
                      return roleForm;
                    }),
                  ],
                ),
              ),
              
              SizedBox(height: verticalGap),
              
              // 底部按钮区域
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 上一步按钮
                  OutlinedButton(
                    onPressed: widget.onPrevious,
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
                            fontSize: isSmallScreen ? 13 : 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 20),
                  // 下一步按钮
                  ElevatedButton(
                    onPressed: _handleNext,
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
                          '下一步',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 6),
                        Icon(Icons.arrow_forward, size: isSmallScreen ? 14 : 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 获取角色对应的图标
  IconData _getRoleIcon(UserRole? role) {
    switch (role) {
      case UserRole.counselor:
        return Icons.psychology_outlined;
      case UserRole.supervisor:
        return Icons.supervisor_account_outlined;
      default:
        return Icons.person_outline;
    }
  }

  Widget _buildCounselorForm(bool isSmallScreen, double fieldGap) {
    return Column(
      children: [
        StyledTextField(
          controller: _controllers['title']!,
          labelText: '职称',
          hintText: '请输入职称',
          prefixIcon: Icons.work_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入职称';
            }
            return null;
          },
        ),
        SizedBox(height: fieldGap),
        StyledTextField(
          controller: _controllers['qualification']!,
          labelText: '资质',
          hintText: '请输入资质',
          prefixIcon: Icons.verified_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入资质';
            }
            return null;
          },
        ),
        SizedBox(height: fieldGap),
        // 个人简介
        Container(
          height: isSmallScreen ? 100 : 120,
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              controller: _controllers['introduction']!,
              maxLines: isSmallScreen ? 3 : 4,
              decoration: InputDecoration(
                labelText: '个人简介',
                hintText: '请输入个人简介',
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
                hintStyle: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
                prefixIcon: Icon(
                  Icons.description_outlined, 
                  color: AppColors.secondary,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupervisorForm(bool isSmallScreen, double fieldGap) {
    return Column(
      children: [
        StyledTextField(
          controller: _controllers['title']!,
          labelText: '职称',
          hintText: '请输入职称',
          prefixIcon: Icons.work_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入职称';
            }
            return null;
          },
        ),
        SizedBox(height: fieldGap),
        StyledTextField(
          controller: _controllers['qualification']!,
          labelText: '资质',
          hintText: '请输入资质',
          prefixIcon: Icons.verified_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入资质';
            }
            return null;
          },
        ),
        SizedBox(height: fieldGap),
        // 个人简介
        Container(
          height: isSmallScreen ? 100 : 120,
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              controller: _controllers['introduction']!,
              maxLines: isSmallScreen ? 3 : 4,
              decoration: InputDecoration(
                labelText: '个人简介',
                hintText: '请输入个人简介',
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
                hintStyle: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
                prefixIcon: Icon(
                  Icons.description_outlined, 
                  color: AppColors.secondary,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 
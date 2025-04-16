import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/theme/app_colors.dart';
import 'package:psc_web/widgets/inputs/styled_text_field.dart';
import 'package:psc_web/widgets/auth/role_selector.dart';

class BasicInfoForm extends StatefulWidget {
  final VoidCallback onNext;

  const BasicInfoForm({
    super.key,
    required this.onNext,
  });

  @override
  State<BasicInfoForm> createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
      
      // 更新表单数据
      registerProvider.updateFormData('username', _usernameController.text);
      registerProvider.updateFormData('name', _nameController.text);
      registerProvider.updateFormData('email', _emailController.text);
      registerProvider.updateFormData('phone', _phoneController.text);
      registerProvider.updateFormData('password', _passwordController.text);
      
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

    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 标题和副标题
              if (!isSmallScreen) ...[
                Text(
                  '创建您的账号',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '填写基本信息以开始注册',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: verticalGap),
              ],
              
              // 表单字段 - 根据屏幕宽度调整布局
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // 用户名和姓名
                    if (!isMobile) 
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextField(
                              controller: _usernameController,
                              labelText: '用户名',
                              hintText: '请输入用户名',
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入用户名';
                                }
                                if (value.length < 3) {
                                  return '用户名至少3个字符';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StyledTextField(
                              controller: _nameController,
                              labelText: '姓名',
                              hintText: '请输入真实姓名',
                              prefixIcon: Icons.badge_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入姓名';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          StyledTextField(
                            controller: _usernameController,
                            labelText: '用户名',
                            hintText: '请输入用户名',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入用户名';
                              }
                              if (value.length < 3) {
                                return '用户名至少3个字符';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldGap),
                          StyledTextField(
                            controller: _nameController,
                            labelText: '姓名',
                            hintText: '请输入真实姓名',
                            prefixIcon: Icons.badge_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入姓名';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    
                    SizedBox(height: fieldGap),
    
                    // 邮箱和电话
                    if (!isMobile) 
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextField(
                              controller: _emailController,
                              labelText: '邮箱',
                              hintText: '请输入邮箱地址',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入邮箱地址';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return '请输入有效的邮箱地址';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StyledTextField(
                              controller: _phoneController,
                              labelText: '电话（可选）',
                              hintText: '请输入联系电话',
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          StyledTextField(
                            controller: _emailController,
                            labelText: '邮箱',
                            hintText: '请输入邮箱地址',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入邮箱地址';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return '请输入有效的邮箱地址';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldGap),
                          StyledTextField(
                            controller: _phoneController,
                            labelText: '电话（可选）',
                            hintText: '请输入联系电话',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    
                    SizedBox(height: fieldGap),
    
                    // 密码和确认密码
                    if (!isMobile) 
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextField(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入密码';
                                }
                                if (value.length < 6) {
                                  return '密码至少6个字符';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StyledTextField(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请确认密码';
                                }
                                if (value != _passwordController.text) {
                                  return '两次输入的密码不一致';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入密码';
                              }
                              if (value.length < 6) {
                                return '密码至少6个字符';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldGap),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请确认密码';
                              }
                              if (value != _passwordController.text) {
                                return '两次输入的密码不一致';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    
                    SizedBox(height: verticalGap),
    
                    // 角色选择
                    const RoleSelector(),
                  ],
                ),
              ),
              
              SizedBox(height: verticalGap),
              
              // 下一步按钮
              SizedBox(
                width: isMobile ? double.infinity : 300,
                height: isSmallScreen ? 40 : 48,
                child: ElevatedButton(
                  onPressed: registerProvider.selectedRole != null ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.buttonPrimary,
                    disabledBackgroundColor: AppColors.buttonDisabled,
                    disabledForegroundColor: Colors.white.withOpacity(0.8),
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
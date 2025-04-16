import 'package:flutter/material.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/theme/app_colors.dart';
import 'package:provider/provider.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 680;
    final isMobile = screenSize.width < 600;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择您的角色',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoleCard(
                context,
                UserRole.counselor,
                '咨询师',
                '我是提供心理咨询的专业人员',
                Icons.psychology_outlined,
                registerProvider.selectedRole == UserRole.counselor,
                isMobile,
                isSmallScreen,
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              _buildRoleCard(
                context,
                UserRole.supervisor,
                '督导',
                '我是负责督导咨询师的专业人员',
                Icons.supervisor_account_outlined,
                registerProvider.selectedRole == UserRole.supervisor,
                isMobile,
                isSmallScreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    UserRole role,
    String title,
    String description,
    IconData icon,
    bool isSelected,
    bool isMobile,
    bool isSmallScreen,
  ) {
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    final width = isSmallScreen ? 140.0 : (isMobile ? 150.0 : 180.0);
    final height = isSmallScreen ? 150.0 : 180.0;
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => registerProvider.selectRole(role),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.cardSelected
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.glassBgLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: isSmallScreen ? 24 : 32,
                  color: isSelected 
                      ? Colors.white 
                      : AppColors.secondary,
                ),
              ),
              SizedBox(height: isSmallScreen ? 10 : 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
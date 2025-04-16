import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/auth/register_provider.dart';
import 'package:psc_web/theme/app_colors.dart';

class SignupProgressIndicator extends StatelessWidget {
  const SignupProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final currentStep = registerProvider.currentStep;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStep(context, 0, '基本信息', currentStep),
              _buildConnector(context, 0, currentStep),
              _buildStep(context, 1, '详细信息', currentStep),
              _buildConnector(context, 1, currentStep),
              _buildStep(context, 2, '确认', currentStep),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.glassBgLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _getStepDescription(currentStep),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, int step, String label, int currentStep) {
    final isCompleted = step < currentStep;
    final isCurrent = step == currentStep;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.progressComplete
                : isCurrent
                    ? AppColors.progressActive
                    : AppColors.progressInactive,
            boxShadow: isCurrent ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    size: 22,
                    color: Colors.white,
                  )
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isCurrent
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted
                ? AppColors.progressComplete
                : isCurrent
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context, int connectorPosition, int currentStep) {
    final isCompleted = connectorPosition < currentStep;
    
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: isCompleted 
              ? LinearGradient(
                  colors: [
                    AppColors.progressComplete,
                    AppColors.progressActive,
                  ],
                )
              : null,
          color: isCompleted ? null : AppColors.progressInactive,
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }

  String _getStepDescription(int currentStep) {
    switch (currentStep) {
      case 0:
        return '填写基本信息，包括用户名、密码和角色选择';
      case 1:
        return '根据您选择的角色，填写详细信息';
      case 2:
        return '确认您的注册信息，完成注册';
      default:
        return '';
    }
  }
} 
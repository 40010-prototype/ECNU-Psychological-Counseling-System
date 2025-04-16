import 'package:flutter/material.dart';

/// 自定义样式的文本输入框
class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscurePassword;
  final VoidCallback? onToggleObscure;
  final bool isDarkMode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscurePassword = false,
    this.onToggleObscure,
    this.isDarkMode = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 根据是否是暗色模式决定颜色
    final Color textColor = isDarkMode 
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    
    final Color fillColor = isDarkMode 
        ? colorScheme.onPrimary.withOpacity(0.1)
        : Colors.grey.shade50;
        
    final Color borderColor = isDarkMode 
        ? colorScheme.onPrimary.withOpacity(0.3)
        : colorScheme.outline.withOpacity(0.3);
        
    final Color focusedBorderColor = isDarkMode 
        ? colorScheme.onPrimary
        : colorScheme.primary;
        
    final Color iconColor = isDarkMode
        ? colorScheme.onPrimary.withOpacity(0.7)
        : colorScheme.primary.withOpacity(0.8);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 添加一个标签文本
        if (!isDarkMode) 
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
          obscureText: isPassword && obscurePassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            // 如果是暗色模式，才在输入框内显示标签
            labelText: isDarkMode ? labelText : null,
            hintText: hintText,
            hintStyle: TextStyle(
              color: textColor.withOpacity(0.5),
              fontSize: 14,
            ),
            labelStyle: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: fillColor,
            prefixIcon: Icon(
              prefixIcon,
              color: iconColor,
              size: 20,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: iconColor,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            errorStyle: TextStyle(
              color: colorScheme.error,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
} 
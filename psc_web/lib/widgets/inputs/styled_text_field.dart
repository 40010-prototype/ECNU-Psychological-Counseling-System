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

  const StyledTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscurePassword = false,
    this.onToggleObscure,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 根据是否是暗色模式决定颜色
    final Color textColor = isDarkMode 
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    
    final Color fillColor = isDarkMode 
        ? colorScheme.onPrimary.withOpacity(0.1)
        : colorScheme.surfaceVariant.withOpacity(0.3);
        
    final Color borderColor = isDarkMode 
        ? colorScheme.onPrimary.withOpacity(0.3)
        : colorScheme.outline.withOpacity(0.5);
        
    final Color focusedBorderColor = isDarkMode 
        ? colorScheme.onPrimary
        : colorScheme.primary;
    
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      obscureText: isPassword && obscurePassword,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
        labelStyle: TextStyle(color: textColor.withOpacity(0.8)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: fillColor,
        prefixIcon: Icon(
          prefixIcon,
          color: textColor.withOpacity(0.7),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: textColor.withOpacity(0.7),
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
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
} 
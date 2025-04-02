import 'package:flutter/material.dart';
import 'package:psc_web/theme/app_colors.dart'; // 确保路径正确

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // 使用Material 3
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryAccent,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryAccent,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.primaryText,
      onSurface: AppColors.primaryText,
      onError: Colors.white,
    ),
    // AppBar主题
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // 文本主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.primaryText),
      bodyMedium: TextStyle(color: AppColors.primaryText),
      bodySmall: TextStyle(color: AppColors.secondaryText),
      labelLarge: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
    ),
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // 卡片主题
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondaryText.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.secondaryText),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
    ),
    // 分割线主题
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEAEBEC),
      thickness: 1,
      space: 24,
    ),
    // 滚动条主题
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(8),
      thickness: WidgetStateProperty.all(8),
      thumbColor: WidgetStateProperty.all(AppColors.secondaryText.withOpacity(0.3)),
    ),
  );

  // 深色主题
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryAccent.withOpacity(0.8),
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryAccent.withOpacity(0.8),
      surface: const Color(0xFF1E1E1E),
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    // AppBar主题
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // 文本主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
      labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // 卡片主题
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: AppColors.primary.withOpacity(0.9)),
    ),
    // 分割线主题
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3A),
      thickness: 1,
      space: 24,
    ),
    // 滚动条主题
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(8),
      thickness: WidgetStateProperty.all(8),
      thumbColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.4)),
    ),
  );
}
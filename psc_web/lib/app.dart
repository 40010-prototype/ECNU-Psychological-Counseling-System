import 'package:flutter/material.dart';
import 'package:psc_web/theme/app_theme.dart'; // 确保路径正确
import 'package:psc_web/routes/app_routes.dart'; // 确保路径正确

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心理咨询系统',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // 如果您有定义深色主题
      themeMode: ThemeMode.light, // 或者 ThemeMode.system 根据用户设备设置
      initialRoute: AppRoute.loginRoute, // 设置应用的初始路由
      onGenerateRoute: AppRoute.generateRoute, // 使用 AppRoute 来生成路由
    );
  }
}
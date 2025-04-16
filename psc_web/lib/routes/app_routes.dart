import 'package:flutter/material.dart';
import 'package:psc_web/pages/auth/login_page.dart'; // 更新路径
import 'package:psc_web/pages/dashboard/dashboard_router.dart'; // 导入Dashboard路由器
import 'package:psc_web/models/user/user.dart'; // 导入用户模型
// 您可能还有其他的屏幕组件需要导入

class AppRoute {
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard'; // 添加仪表盘路由
  // 您可以定义其他的路由常量，例如主页、仪表盘等

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 提取路由参数
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboardRoute:
        // 从参数中获取用户角色，默认为管理员
        final userRole = args?['userRole'] as UserRole? ?? UserRole.admin;
        return MaterialPageRoute(
          builder: (_) => DashboardRouter(userRole: userRole),
        );
      // case homeRoute:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case dashboardRoute:
      //   return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('错误')),
        body: const Center(child: Text('页面未找到')),
      );
    });
  }
}
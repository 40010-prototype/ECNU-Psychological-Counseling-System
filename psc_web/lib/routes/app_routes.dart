import 'package:flutter/material.dart';
import 'package:psc_web/pages/auth/login_page.dart'; // 更新路径
import 'package:psc_web/pages/auth/signup_page.dart'; // 导入注册页面
import 'package:psc_web/pages/dashboard/dashboard_page.dart'; // 导入仪表盘页面
// 您可能还有其他的屏幕组件需要导入

class AppRoute {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup'; // 添加注册路由
  static const String dashboardRoute = '/dashboard'; // 添加仪表盘路由
  // 您可以定义其他的路由常量，例如主页、仪表盘等

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
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
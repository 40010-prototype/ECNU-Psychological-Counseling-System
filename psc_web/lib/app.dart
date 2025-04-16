import 'package:flutter/material.dart';
import 'package:psc_web/theme/app_theme.dart'; // 确保路径正确
import 'package:psc_web/routes/app_routes.dart'; // 确保路径正确
import 'package:provider/provider.dart';
import 'package:psc_web/providers/dashboard/home_provider.dart';
import 'package:psc_web/services/dashboard/home_service.dart';
import 'package:psc_web/providers/consultation/consultation_provider.dart';
import 'package:psc_web/services/consultation/consultation_service.dart';
import 'package:psc_web/providers/appointment/appointment_provider.dart';
import 'package:psc_web/services/appointment/appointment_service.dart';
import 'package:psc_web/providers/user/user_provider.dart';
import 'package:psc_web/services/user/user_service.dart';
import 'package:psc_web/providers/auth/auth_provider.dart';
import 'package:psc_web/services/auth/auth_service.dart';
import 'package:psc_web/providers/auth/register_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(MockHomeService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ConsultationProvider(MockConsultationService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(appointmentService: MockAppointmentService()),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(MockUserService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()), // 实例化 AuthProvider 并传入 AuthService
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(AuthService()), // 添加 RegisterProvider
        ),
      ],
      child: MaterialApp(
        title: '心理咨询系统',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme, // 如果您有定义深色主题
        themeMode: ThemeMode.light, // 或者 ThemeMode.system 根据用户设备设置
        initialRoute: AppRoute.loginRoute, // 设置应用的初始路由
        onGenerateRoute: AppRoute.generateRoute, // 使用 AppRoute 来生成路由
      ),
    );
  }
}
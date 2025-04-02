import 'package:psc_web/models/dashboard/home_data.dart';

/// 首页服务接口
abstract class HomeService {
  Future<HomeData> getHomeData();
}

/// 模拟首页服务实现
class MockHomeService implements HomeService {
  @override
  Future<HomeData> getHomeData() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));
    
    // 返回模拟数据
    return HomeData(
      totalAppointments: 156,
      todayAppointments: 8,
      pendingAppointments: 12,
      totalClients: 89,
      activeClients: 45,
      recentActivities: [
        RecentActivity(
          id: '1',
          title: '新预约',
          description: '张同学预约了明天下午2点的咨询',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: ActivityType.appointment,
        ),
        RecentActivity(
          id: '2',
          title: '咨询完成',
          description: '李同学的咨询已完成',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: ActivityType.consultation,
        ),
        RecentActivity(
          id: '3',
          title: '新用户注册',
          description: '王同学注册了账号',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: ActivityType.registration,
        ),
        RecentActivity(
          id: '4',
          title: '系统通知',
          description: '系统将于今晚22:00进行例行维护',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          type: ActivityType.system,
        ),
      ],
    );
  }
} 
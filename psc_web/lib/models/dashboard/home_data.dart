/// 首页数据模型
class HomeData {
  final int totalAppointments;      // 总预约数
  final int todayAppointments;      // 今日预约数
  final int pendingAppointments;    // 待处理预约数
  final int totalClients;          // 总来访者数
  final int activeClients;         // 活跃来访者数
  final List<RecentActivity> recentActivities;  // 最近活动

  HomeData({
    required this.totalAppointments,
    required this.todayAppointments,
    required this.pendingAppointments,
    required this.totalClients,
    required this.activeClients,
    required this.recentActivities,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      totalAppointments: json['totalAppointments'] as int,
      todayAppointments: json['todayAppointments'] as int,
      pendingAppointments: json['pendingAppointments'] as int,
      totalClients: json['totalClients'] as int,
      activeClients: json['activeClients'] as int,
      recentActivities: (json['recentActivities'] as List)
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
    );
  }
}

/// 最近活动模型
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == 'ActivityType.${json['type']}',
      ),
    );
  }
}

/// 活动类型枚举
enum ActivityType {
  appointment,    // 预约
  consultation,   // 咨询
  registration,   // 注册
  system,         // 系统
} 
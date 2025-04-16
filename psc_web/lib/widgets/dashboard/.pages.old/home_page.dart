import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/dashboard/home_provider.dart';
import 'package:psc_web/models/dashboard/home_data.dart';

/// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 在组件初始化时加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (homeProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  homeProvider.error!,
                  style: TextStyle(color: colorScheme.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => homeProvider.refresh(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        final homeData = homeProvider.homeData;
        if (homeData == null) {
          return const Center(
            child: Text('暂无数据'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 统计卡片
              _buildStatCards(context, homeData),
              const SizedBox(height: 24),
              
              // 最近活动
              _buildRecentActivities(context, homeData.recentActivities),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCards(BuildContext context, HomeData data) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          context,
          '总预约数',
          data.totalAppointments.toString(),
          Icons.event_available,
          colorScheme.primary,
        ),
        _buildStatCard(
          context,
          '今日预约',
          data.todayAppointments.toString(),
          Icons.today,
          colorScheme.primaryContainer,
        ),
        _buildStatCard(
          context,
          '待处理预约',
          data.pendingAppointments.toString(),
          Icons.pending_actions,
          colorScheme.secondary,
        ),
        _buildStatCard(
          context,
          '活跃来访者',
          data.activeClients.toString(),
          Icons.people,
          colorScheme.secondaryContainer,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, List<RecentActivity> activities) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最近活动',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  leading: _buildActivityIcon(activity.type),
                  title: Text(activity.title),
                  subtitle: Text(activity.description),
                  trailing: Text(
                    _formatTime(activity.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(ActivityType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case ActivityType.appointment:
        icon = Icons.event_available;
        color = Colors.blue;
        break;
      case ActivityType.consultation:
        icon = Icons.psychology;
        color = Colors.green;
        break;
      case ActivityType.registration:
        icon = Icons.person_add;
        color = Colors.orange;
        break;
      case ActivityType.system:
        icon = Icons.notifications;
        color = Colors.red;
        break;
    }
    
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
} 
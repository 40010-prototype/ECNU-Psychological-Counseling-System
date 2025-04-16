import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/providers/consultation/consultation_provider.dart';
import 'package:psc_web/models/consultation/consultation.dart';

/// 咨询记录页面
class ConsultationRecordsPage extends StatefulWidget {
  const ConsultationRecordsPage({super.key});

  @override
  State<ConsultationRecordsPage> createState() => _ConsultationRecordsPageState();
}

class _ConsultationRecordsPageState extends State<ConsultationRecordsPage> {
  @override
  void initState() {
    super.initState();
    // 加载咨询记录数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsultationProvider>().loadConsultations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<ConsultationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.error!,
                  style: TextStyle(color: colorScheme.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadConsultations(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        final consultations = provider.consultations;
        if (consultations == null || consultations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无咨询记录',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // 顶部操作栏
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 搜索框
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索咨询记录...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        // TODO: 实现搜索功能
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 筛选按钮
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: 实现筛选功能
                    },
                  ),
                  // 新建记录按钮
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('新建记录'),
                    onPressed: () {
                      // TODO: 实现新建记录功能
                    },
                  ),
                ],
              ),
            ),
            
            // 记录列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: consultations.length,
                itemBuilder: (context, index) {
                  final consultation = consultations[index];
                  return _buildConsultationCard(context, consultation);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConsultationCard(BuildContext context, Consultation consultation) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: 跳转到详情页面
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部信息
              Row(
                children: [
                  // 来访者信息
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            consultation.clientName[0],
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consultation.clientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${consultation.clientId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 状态标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(consultation.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getStatusText(consultation.status),
                      style: TextStyle(
                        color: _getStatusColor(consultation.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 咨询信息
              Row(
                children: [
                  // 咨询师信息
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          consultation.counselorName,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 时间信息
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(consultation.startTime),
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 咨询主题
              Text(
                consultation.topic,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ConsultationStatus status) {
    switch (status) {
      case ConsultationStatus.completed:
        return Colors.green;
      case ConsultationStatus.inProgress:
        return Colors.blue;
      case ConsultationStatus.scheduled:
        return Colors.orange;
      case ConsultationStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(ConsultationStatus status) {
    switch (status) {
      case ConsultationStatus.completed:
        return '已完成';
      case ConsultationStatus.inProgress:
        return '进行中';
      case ConsultationStatus.scheduled:
        return '已预约';
      case ConsultationStatus.cancelled:
        return '已取消';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 
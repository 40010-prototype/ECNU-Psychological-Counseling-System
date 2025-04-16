import 'package:flutter/material.dart';

/// 排班表页面
class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // 当前选中的日期
  late DateTime _selectedDate;
  // 显示的周的起始日期
  late DateTime _weekStartDate;
  
  // 咨询师列表
  final List<Map<String, dynamic>> _counselors = [
    {
      'id': 'c001',
      'name': '王咨询师',
      'avatar': 'W',
      'title': '心理咨询师',
      'specialties': ['抑郁症', '焦虑症', '人际关系'],
    },
    {
      'id': 'c002',
      'name': '李咨询师',
      'avatar': 'L',
      'title': '临床心理学家',
      'specialties': ['婚姻家庭', '青少年心理', '情绪管理'],
    },
    {
      'id': 'c003',
      'name': '张咨询师',
      'avatar': 'Z',
      'title': '心理治疗师',
      'specialties': ['创伤治疗', '认知行为疗法', '压力管理'],
    },
  ];
  
  // 时间段
  final List<String> _timeSlots = [
    '08:00-09:00',
    '09:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '14:00-15:00',
    '15:00-16:00',
    '16:00-17:00',
    '17:00-18:00',
  ];
  
  // 排班数据（模拟数据）
  final Map<String, List<Map<String, dynamic>>> _scheduleData = {
    'c001': [
      {
        'date': '2023-12-18',
        'slots': ['08:00-09:00', '09:00-10:00', '14:00-15:00', '15:00-16:00'],
      },
      {
        'date': '2023-12-19',
        'slots': ['10:00-11:00', '11:00-12:00', '16:00-17:00', '17:00-18:00'],
      },
      {
        'date': '2023-12-20',
        'slots': ['08:00-09:00', '09:00-10:00', '14:00-15:00', '15:00-16:00'],
      },
    ],
    'c002': [
      {
        'date': '2023-12-18',
        'slots': ['10:00-11:00', '11:00-12:00', '16:00-17:00', '17:00-18:00'],
      },
      {
        'date': '2023-12-20',
        'slots': ['08:00-09:00', '09:00-10:00', '14:00-15:00', '15:00-16:00'],
      },
      {
        'date': '2023-12-22',
        'slots': ['10:00-11:00', '11:00-12:00', '16:00-17:00', '17:00-18:00'],
      },
    ],
    'c003': [
      {
        'date': '2023-12-19',
        'slots': ['08:00-09:00', '09:00-10:00', '14:00-15:00', '15:00-16:00'],
      },
      {
        'date': '2023-12-21',
        'slots': ['10:00-11:00', '11:00-12:00', '16:00-17:00', '17:00-18:00'],
      },
      {
        'date': '2023-12-22',
        'slots': ['08:00-09:00', '09:00-10:00', '14:00-15:00', '15:00-16:00'],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekStartDate = _getWeekStartDate(_selectedDate);
  }

  // 获取本周的起始日期（周一）
  DateTime _getWeekStartDate(DateTime date) {
    int difference = date.weekday - 1;
    return date.subtract(Duration(days: difference));
  }

  // 切换到上一周
  void _previousWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.subtract(const Duration(days: 7));
    });
  }

  // 切换到下一周
  void _nextWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.add(const Duration(days: 7));
    });
  }

  // 切换到当前周
  void _currentWeek() {
    setState(() {
      _weekStartDate = _getWeekStartDate(DateTime.now());
    });
  }

  // 选择日期
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  // 检查咨询师在特定日期是否有空闲时段
  bool _isCounselorAvailable(String counselorId, DateTime date) {
    if (!_scheduleData.containsKey(counselorId)) return false;
    
    String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    for (var schedule in _scheduleData[counselorId]!) {
      if (schedule['date'] == dateStr) {
        return schedule['slots'].isNotEmpty;
      }
    }
    
    return false;
  }

  // 获取咨询师在特定日期的可用时段
  List<String> _getCounselorSlots(String counselorId, DateTime date) {
    if (!_scheduleData.containsKey(counselorId)) return [];
    
    String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    for (var schedule in _scheduleData[counselorId]!) {
      if (schedule['date'] == dateStr) {
        return List<String>.from(schedule['slots']);
      }
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 日期选择器和周导航
          _buildWeekNavigator(colorScheme),
          
          const SizedBox(height: 16),
          
          // 周视图
          _buildWeekView(colorScheme),
          
          const SizedBox(height: 24),
          
          // 标题
          Text(
            '咨询师排班',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 咨询师列表
          Expanded(
            child: ListView.builder(
              itemCount: _counselors.length,
              itemBuilder: (context, index) {
                final counselor = _counselors[index];
                return _buildCounselorScheduleCard(counselor, colorScheme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator(ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          '${_weekStartDate.year}年${_weekStartDate.month}月',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _previousWeek,
          tooltip: '上一周',
        ),
        TextButton(
          onPressed: _currentWeek,
          child: const Text('本周'),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: _nextWeek,
          tooltip: '下一周',
        ),
      ],
    );
  }

  Widget _buildWeekView(ColorScheme colorScheme) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(7, (index) {
          final date = _weekStartDate.add(Duration(days: index));
          final isSelected = date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day;
          final isToday = date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;
          
          return Expanded(
            child: InkWell(
              onTap: () => _selectDate(date),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ['一', '二', '三', '四', '五', '六', '日'][index],
                      style: TextStyle(
                        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday && !isSelected ? colorScheme.primary.withOpacity(0.2) : null,
                      ),
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected 
                              ? colorScheme.onPrimary 
                              : (isToday ? colorScheme.primary : colorScheme.onSurface),
                            fontWeight: isSelected || isToday ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCounselorScheduleCard(Map<String, dynamic> counselor, ColorScheme colorScheme) {
    final availableSlots = _getCounselorSlots(counselor['id'], _selectedDate);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 咨询师信息
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    counselor['avatar'],
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      counselor['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      counselor['title'],
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // 状态标识
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: availableSlots.isNotEmpty 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    availableSlots.isNotEmpty ? '有空闲' : '无空闲',
                    style: TextStyle(
                      color: availableSlots.isNotEmpty ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 专长标签
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                counselor['specialties'].length,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    counselor['specialties'][index],
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 可用时段
            if (availableSlots.isNotEmpty) ...[
              Text(
                '可用时段',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSlots.map((slot) => OutlinedButton(
                  onPressed: () {
                    // TODO: 处理预约逻辑
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(slot),
                )).toList(),
              ),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '当天无可用时段',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
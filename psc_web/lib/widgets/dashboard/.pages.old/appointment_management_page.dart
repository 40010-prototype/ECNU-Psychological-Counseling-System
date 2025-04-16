import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/appointment/appointment.dart';
import 'package:psc_web/providers/appointment/appointment_provider.dart';
import 'package:psc_web/theme/app_colors.dart';

/// 预约管理页面
class AppointmentManagementPage extends StatefulWidget {
  const AppointmentManagementPage({Key? key}) : super(key: key);

  @override
  State<AppointmentManagementPage> createState() => _AppointmentManagementPageState();
}

class _AppointmentManagementPageState extends State<AppointmentManagementPage> with SingleTickerProviderStateMixin {
  // 搜索关键词
  String _searchKeyword = '';
  
  // 筛选选项
  String? _filterStatus;
  String? _filterCounselor;
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Tab控制器
  late TabController _tabController;
  
  // 选中的预约ID
  String? _selectedAppointmentId;
  
  // 状态选项
  final List<String> _statusOptions = [
    '全部',
    '待确认',
    '已确认',
    '已完成',
    '已取消',
    '未出席',
  ];
  
  // 咨询师选项
  final List<String> _counselorOptions = [
    '全部',
    '王老师',
    '刘老师',
    '张老师',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 加载预约数据
    Future.microtask(() {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // 获取预约状态对应的TabIndex
  int _getTabIndexForStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.confirmed:
        return 0; // 即将到来
      case AppointmentStatus.completed:
      case AppointmentStatus.noShow:
        return 1; // 已完成
      case AppointmentStatus.cancelled:
        return 2; // 已取消
      default:
        return 0;
    }
  }
  
  // 获取筛选后的预约列表
  List<Appointment> _getFilteredAppointments(List<Appointment> appointments, int tabIndex) {
    return appointments.where((appointment) {
      // 首先按状态分组到不同Tab页
      final appointmentTabIndex = _getTabIndexForStatus(appointment.status);
      if (appointmentTabIndex != tabIndex) {
        return false;
      }
      
      // 搜索关键词筛选
      if (_searchKeyword.isNotEmpty) {
        final keyword = _searchKeyword.toLowerCase();
        final clientName = appointment.clientName.toLowerCase();
        final counselorName = appointment.counselorName.toLowerCase();
        final reason = appointment.reason.toLowerCase();
        
        if (!clientName.contains(keyword) && 
            !counselorName.contains(keyword) && 
            !reason.contains(keyword)) {
          return false;
        }
      }
      
      // 状态筛选
      if (_filterStatus != null && _filterStatus != '全部') {
        final status = appointment.status;
        final filterStatus = _statusStringToEnum(_filterStatus!);
        if (status != filterStatus) {
          return false;
        }
      }
      
      // 咨询师筛选
      if (_filterCounselor != null && _filterCounselor != '全部') {
        if (appointment.counselorName != _filterCounselor) {
          return false;
        }
      }
      
      // 日期范围筛选
      if (_startDate != null) {
        final startDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
        if (appointment.appointmentTime.isBefore(startDate)) {
          return false;
        }
      }
      
      if (_endDate != null) {
        final endDate = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        if (appointment.appointmentTime.isAfter(endDate)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
  
  // 将状态字符串转换为枚举
  AppointmentStatus _statusStringToEnum(String statusString) {
    switch (statusString) {
      case '待确认':
        return AppointmentStatus.pending;
      case '已确认':
        return AppointmentStatus.confirmed;
      case '已完成':
        return AppointmentStatus.completed;
      case '已取消':
        return AppointmentStatus.cancelled;
      case '未出席':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.pending;
    }
  }
  
  // 获取状态枚举对应的字符串
  String _statusEnumToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return '待确认';
      case AppointmentStatus.confirmed:
        return '已确认';
      case AppointmentStatus.completed:
        return '已完成';
      case AppointmentStatus.cancelled:
        return '已取消';
      case AppointmentStatus.noShow:
        return '未出席';
    }
  }
  
  // 获取状态对应的颜色
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.grey;
    }
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
          // 搜索和筛选栏
          _buildSearchFilterBar(colorScheme),
          
          const SizedBox(height: 16),
          
          // 标签页
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '即将到来'),
              Tab(text: '已完成'),
              Tab(text: '已取消'),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
          ),
          
          const SizedBox(height: 16),
          
          // 预约数据
          Expanded(
            child: Consumer<AppointmentProvider>(
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
                          onPressed: () => provider.loadAllAppointments(),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  );
                }
                
                final appointments = provider.appointments ?? [];
                
                if (appointments.isEmpty) {
                  return _buildEmptyState(colorScheme);
                }
                
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 预约列表
                    Expanded(
                      flex: 3,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // 即将到来
                          _buildAppointmentList(_getFilteredAppointments(appointments, 0), colorScheme),
                          // 已完成
                          _buildAppointmentList(_getFilteredAppointments(appointments, 1), colorScheme),
                          // 已取消
                          _buildAppointmentList(_getFilteredAppointments(appointments, 2), colorScheme),
                        ],
                      ),
                    ),
                    
                    // 分隔线和预约详情
                    if (_selectedAppointmentId != null) ...[
                      const SizedBox(width: 16),
                      const VerticalDivider(),
                      const SizedBox(width: 16),
                      
                      // 预约详情
                      Expanded(
                        flex: 2,
                        child: _buildAppointmentDetail(
                          _getAppointmentById(appointments, _selectedAppointmentId!),
                          colorScheme,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // 根据ID获取预约
  Appointment? _getAppointmentById(List<Appointment> appointments, String id) {
    for (final appointment in appointments) {
      if (appointment.id == id) {
        return appointment;
      }
    }
    return null;
  }
  
  Widget _buildSearchFilterBar(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            // 搜索框
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索预约...',
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
                  setState(() {
                    _searchKeyword = value;
                  });
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 创建预约按钮
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('创建预约'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
              ),
              onPressed: () {
                // TODO: 创建预约逻辑
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 筛选选项
        Row(
          children: [
            Text(
              '筛选:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 状态筛选
            DropdownButton<String>(
              hint: const Text('状态'),
              value: _filterStatus,
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status == '全部' ? null : status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filterStatus = value;
                });
              },
            ),
            
            const SizedBox(width: 16),
            
            // 咨询师筛选
            DropdownButton<String>(
              hint: const Text('咨询师'),
              value: _filterCounselor,
              items: _counselorOptions.map((counselor) {
                return DropdownMenuItem<String>(
                  value: counselor == '全部' ? null : counselor,
                  child: Text(counselor),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filterCounselor = value;
                });
              },
            ),
            
            const SizedBox(width: 16),
            
            // 开始日期选择
            TextButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(_startDate == null 
                ? '开始日期' 
                : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                
                if (date != null) {
                  setState(() {
                    _startDate = date;
                  });
                }
              },
            ),
            
            const SizedBox(width: 16),
            
            // 结束日期选择
            TextButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(_endDate == null 
                ? '结束日期' 
                : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                
                if (date != null) {
                  setState(() {
                    _endDate = date;
                  });
                }
              },
            ),
            
            const Spacer(),
            
            // 清除筛选按钮
            TextButton.icon(
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('清除筛选'),
              onPressed: () {
                setState(() {
                  _searchKeyword = '';
                  _filterStatus = null;
                  _filterCounselor = null;
                  _startDate = null;
                  _endDate = null;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到符合条件的预约',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppointmentList(List<Appointment> appointments, ColorScheme colorScheme) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: colorScheme.onBackground.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '没有找到符合条件的预约',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final isSelected = _selectedAppointmentId == appointment.id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAppointmentId = appointment.id;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头部信息
                  Row(
                    children: [
                      // 时间信息
                      Icon(
                        Icons.event,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDateTime(appointment.appointmentTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${appointment.duration.inMinutes}分钟',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      // 状态标签
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(appointment.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _statusEnumToString(appointment.status),
                          style: TextStyle(
                            color: _getStatusColor(appointment.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  
                  // 来访者和咨询师信息
                  Row(
                    children: [
                      // 来访者信息
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.primary.withOpacity(0.1),
                              radius: 20,
                              child: Text(
                                appointment.clientName[0],
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '来访者: ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      appointment.clientName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'ID: ${appointment.clientId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // 咨询师信息
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.secondary.withOpacity(0.1),
                              radius: 20,
                              child: Text(
                                appointment.counselorName[0],
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '咨询师: ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      appointment.counselorName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'ID: ${appointment.counselorId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 原因
                  Row(
                    children: [
                      const Text(
                        '预约原因: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(appointment.reason),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAppointmentDetail(Appointment? appointment, ColorScheme colorScheme) {
    if (appointment == null) {
      return Center(
        child: Text(
          '未找到预约详情',
          style: TextStyle(
            color: colorScheme.error,
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和关闭按钮
          Row(
            children: [
              Text(
                '预约详情',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: '关闭详情',
                onPressed: () {
                  setState(() {
                    _selectedAppointmentId = null;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 状态和操作按钮
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '当前状态: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(appointment.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _statusEnumToString(appointment.status),
                          style: TextStyle(
                            color: _getStatusColor(appointment.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 操作按钮
                  const Text(
                    '预约操作',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 根据预约状态显示不同的操作按钮
                  Row(
                    children: [
                      if (appointment.status == AppointmentStatus.pending) ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('确认预约'),
                          onPressed: () {
                            _confirmAppointment(appointment.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('取消预约'),
                          onPressed: () {
                            _showCancelDialog(appointment.id);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                      
                      if (appointment.status == AppointmentStatus.confirmed) ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: const Text('标记为已完成'),
                          onPressed: () {
                            _completeAppointment(appointment.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.person_off),
                          label: const Text('标记为未出席'),
                          onPressed: () {
                            _markAsNoShow(appointment.id);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('取消预约'),
                          onPressed: () {
                            _showCancelDialog(appointment.id);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                      
                      if (appointment.status == AppointmentStatus.completed || 
                          appointment.status == AppointmentStatus.noShow || 
                          appointment.status == AppointmentStatus.cancelled) ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('恢复为待确认'),
                          onPressed: () {
                            _resetAppointment(appointment);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 预约详情
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '预约信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 预约时间
                  _buildDetailItem(
                    icon: Icons.access_time,
                    title: '预约时间',
                    content: _formatDateTime(appointment.appointmentTime),
                  ),
                  
                  // 持续时间
                  _buildDetailItem(
                    icon: Icons.timelapse,
                    title: '持续时间',
                    content: '${appointment.duration.inMinutes}分钟',
                  ),
                  
                  // 预约原因
                  _buildDetailItem(
                    icon: Icons.subject,
                    title: '预约原因',
                    content: appointment.reason,
                  ),
                  
                  // 来访者信息
                  _buildDetailItem(
                    icon: Icons.person,
                    title: '来访者',
                    content: '${appointment.clientName} (ID: ${appointment.clientId})',
                  ),
                  
                  // 咨询师信息
                  _buildDetailItem(
                    icon: Icons.psychology,
                    title: '咨询师',
                    content: '${appointment.counselorName} (ID: ${appointment.counselorId})',
                  ),
                  
                  // 创建和更新时间
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: '创建时间',
                    content: _formatDateTime(appointment.createdAt),
                  ),
                  
                  if (appointment.updatedAt != null)
                    _buildDetailItem(
                      icon: Icons.update,
                      title: '最后更新',
                      content: _formatDateTime(appointment.updatedAt!),
                    ),
                  
                  // 备注
                  if (appointment.notes != null && appointment.notes!.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.note,
                      title: '备注',
                      content: appointment.notes!,
                      isMultiLine: true,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  // 确认预约
  void _confirmAppointment(String id) {
    context.read<AppointmentProvider>().confirmAppointment(id).then((_) {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
  
  // 显示取消预约对话框
  void _showCancelDialog(String id) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消预约'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请输入取消原因:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '取消原因',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelAppointment(id, reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认取消'),
          ),
        ],
      ),
    );
  }
  
  // 取消预约
  void _cancelAppointment(String id, String reason) {
    context.read<AppointmentProvider>().cancelAppointment(id, reason).then((_) {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
  
  // 标记为已完成
  void _completeAppointment(String id) {
    context.read<AppointmentProvider>().completeAppointment(id).then((_) {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
  
  // 标记为未出席
  void _markAsNoShow(String id) {
    context.read<AppointmentProvider>().markAsNoShow(id).then((_) {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
  
  // 恢复预约为待确认状态
  void _resetAppointment(Appointment appointment) {
    final updatedAppointment = appointment.copyWith(
      status: AppointmentStatus.pending,
      updatedAt: DateTime.now(),
    );
    
    context.read<AppointmentProvider>().updateAppointment(updatedAppointment).then((_) {
      context.read<AppointmentProvider>().loadAllAppointments();
    });
  }
} 
import 'package:flutter/material.dart';

/// 咨询师管理页面
class CounselorManagementPage extends StatefulWidget {
  const CounselorManagementPage({Key? key}) : super(key: key);

  @override
  State<CounselorManagementPage> createState() => _CounselorManagementPageState();
}

class _CounselorManagementPageState extends State<CounselorManagementPage> {
  // 搜索关键词
  String _searchKeyword = '';
  
  // 筛选选项
  String? _filterStatus;
  String? _filterSpecialty;
  
  // 模拟咨询师数据
  final List<Map<String, dynamic>> _counselors = [
    {
      'id': 'c001',
      'name': '王咨询师',
      'avatar': 'W',
      'title': '心理咨询师',
      'email': 'wang@example.com',
      'phone': '13800138001',
      'status': '在职',
      'supervisorId': 's001',
      'supervisorName': '张督导',
      'specialties': ['抑郁症', '焦虑症', '人际关系'],
      'availableTimesPerWeek': 15,
      'rating': 4.8,
      'casesCount': 120,
    },
    {
      'id': 'c002',
      'name': '李咨询师',
      'avatar': 'L',
      'title': '临床心理学家',
      'email': 'li@example.com',
      'phone': '13800138002',
      'status': '在职',
      'supervisorId': 's002',
      'supervisorName': '刘督导',
      'specialties': ['婚姻家庭', '青少年心理', '情绪管理'],
      'availableTimesPerWeek': 12,
      'rating': 4.9,
      'casesCount': 98,
    },
    {
      'id': 'c003',
      'name': '张咨询师',
      'avatar': 'Z',
      'title': '心理治疗师',
      'email': 'zhang@example.com',
      'phone': '13800138003',
      'status': '在职',
      'supervisorId': 's001',
      'supervisorName': '张督导',
      'specialties': ['创伤治疗', '认知行为疗法', '压力管理'],
      'availableTimesPerWeek': 18,
      'rating': 4.7,
      'casesCount': 156,
    },
    {
      'id': 'c004',
      'name': '赵咨询师',
      'avatar': 'Z',
      'title': '心理咨询师',
      'email': 'zhao@example.com',
      'phone': '13800138004',
      'status': '休假',
      'supervisorId': 's002',
      'supervisorName': '刘督导',
      'specialties': ['抑郁症', '焦虑症', '职场压力'],
      'availableTimesPerWeek': 0,
      'rating': 4.6,
      'casesCount': 87,
    },
    {
      'id': 'c005',
      'name': '孙咨询师',
      'avatar': 'S',
      'title': '婚姻家庭咨询师',
      'email': 'sun@example.com',
      'phone': '13800138005',
      'status': '在职',
      'supervisorId': 's003',
      'supervisorName': '王督导',
      'specialties': ['婚姻家庭', '亲子关系', '情感问题'],
      'availableTimesPerWeek': 20,
      'rating': 4.9,
      'casesCount': 210,
    },
  ];
  
  // 状态选项
  final List<String> _statusOptions = ['全部', '在职', '休假', '离职'];
  
  // 专长选项
  final List<String> _specialtyOptions = [
    '全部',
    '抑郁症',
    '焦虑症',
    '人际关系',
    '婚姻家庭',
    '青少年心理',
    '情绪管理',
    '创伤治疗',
    '认知行为疗法',
    '压力管理',
    '职场压力',
    '亲子关系',
    '情感问题',
  ];
  
  // 获取筛选后的咨询师列表
  List<Map<String, dynamic>> get _filteredCounselors {
    return _counselors.where((counselor) {
      // 搜索关键词筛选
      if (_searchKeyword.isNotEmpty) {
        final keyword = _searchKeyword.toLowerCase();
        final name = counselor['name'].toLowerCase();
        final title = counselor['title'].toLowerCase();
        final email = counselor['email'].toLowerCase();
        
        if (!name.contains(keyword) && 
            !title.contains(keyword) && 
            !email.contains(keyword)) {
          return false;
        }
      }
      
      // 状态筛选
      if (_filterStatus != null && _filterStatus != '全部') {
        if (counselor['status'] != _filterStatus) {
          return false;
        }
      }
      
      // 专长筛选
      if (_filterSpecialty != null && _filterSpecialty != '全部') {
        final specialties = List<String>.from(counselor['specialties']);
        if (!specialties.contains(_filterSpecialty)) {
          return false;
        }
      }
      
      return true;
    }).toList();
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
          
          const SizedBox(height: 20),
          
          // 咨询师列表
          Expanded(
            child: _filteredCounselors.isEmpty
                ? _buildEmptyState(colorScheme)
                : _buildCounselorList(colorScheme),
          ),
        ],
      ),
    );
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
                  hintText: '搜索咨询师...',
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
            
            // 添加新咨询师按钮
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('添加咨询师'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
              ),
              onPressed: () {
                // TODO: 添加咨询师逻辑
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 筛选选项
        Row(
          children: [
            Text(
              '筛选条件：',
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
            
            const SizedBox(width: 24),
            
            // 专长筛选
            DropdownButton<String>(
              hint: const Text('专长'),
              value: _filterSpecialty,
              items: _specialtyOptions.map((specialty) {
                return DropdownMenuItem<String>(
                  value: specialty == '全部' ? null : specialty,
                  child: Text(specialty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filterSpecialty = value;
                });
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
                  _filterSpecialty = null;
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
            Icons.people_outline,
            size: 64,
            color: colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到符合条件的咨询师',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorList(ColorScheme colorScheme) {
    return ListView.builder(
      itemCount: _filteredCounselors.length,
      itemBuilder: (context, index) {
        final counselor = _filteredCounselors[index];
        return _buildCounselorCard(counselor, colorScheme);
      },
    );
  }

  Widget _buildCounselorCard(Map<String, dynamic> counselor, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 咨询师信息行
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    counselor['avatar'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // 基本信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            counselor['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: counselor['status'] == '在职'
                                  ? Colors.green.withOpacity(0.1)
                                  : counselor['status'] == '休假'
                                      ? Colors.orange.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              counselor['status'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: counselor['status'] == '在职'
                                    ? Colors.green
                                    : counselor['status'] == '休假'
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        counselor['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${counselor['rating']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.folder,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${counselor['casesCount']} 个案例',
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '每周 ${counselor['availableTimesPerWeek']} 个时段',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 联系信息
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            counselor['email'],
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            counselor['phone'],
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 操作按钮
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: '编辑',
                      onPressed: () {
                        // TODO: 编辑咨询师逻辑
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.assignment_outlined),
                      tooltip: '查看案例',
                      onPressed: () {
                        // TODO: 查看案例逻辑
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      tooltip: '查看排班',
                      onPressed: () {
                        // TODO: 查看排班逻辑
                      },
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // 督导信息及专长
            Row(
              children: [
                // 督导信息
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '督导：',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        counselor['supervisorName'],
                        style: TextStyle(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 专长
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '专长领域：',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          counselor['specialties'].length,
                          (index) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              counselor['specialties'][index],
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
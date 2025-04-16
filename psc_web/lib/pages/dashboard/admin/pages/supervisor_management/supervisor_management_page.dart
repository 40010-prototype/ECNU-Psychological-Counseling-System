import 'package:flutter/material.dart';

/// 督导管理页面
class SupervisorManagementPage extends StatefulWidget {
  const SupervisorManagementPage({Key? key}) : super(key: key);

  @override
  State<SupervisorManagementPage> createState() => _SupervisorManagementPageState();
}

class _SupervisorManagementPageState extends State<SupervisorManagementPage> {
  // 搜索关键词
  String _searchKeyword = '';
  
  // 筛选选项
  String? _filterStatus;
  String? _filterSpecialty;
  
  // 模拟督导数据
  final List<Map<String, dynamic>> _supervisors = [
    {
      'id': 's001',
      'name': '张督导',
      'avatar': 'Z',
      'title': '高级心理督导师',
      'email': 'zhang_supervisor@example.com',
      'phone': '13900139001',
      'status': '在职',
      'specialties': ['抑郁症', '焦虑症', '人际关系', '认知行为疗法'],
      'counselorCount': 8,
      'experience': 12, // 年
      'rating': 4.9,
      'availability': '周一至周五',
      'qualifications': [
        '国家二级心理咨询师',
        '美国心理学会认证督导',
        '认知行为疗法专业培训',
      ],
    },
    {
      'id': 's002',
      'name': '刘督导',
      'avatar': 'L',
      'title': '资深心理督导师',
      'email': 'liu_supervisor@example.com',
      'phone': '13900139002',
      'status': '在职',
      'specialties': ['婚姻家庭', '青少年心理', '情绪管理', '精神分析'],
      'counselorCount': 6,
      'experience': 10, // 年
      'rating': 4.8,
      'availability': '周二、周四、周六',
      'qualifications': [
        '国家一级心理咨询师',
        '家庭治疗师认证',
        '儿童青少年心理专业培训',
      ],
    },
    {
      'id': 's003',
      'name': '王督导',
      'avatar': 'W',
      'title': '临床心理督导师',
      'email': 'wang_supervisor@example.com',
      'phone': '13900139003',
      'status': '在职',
      'specialties': ['创伤治疗', '压力管理', '睡眠障碍', '正念疗法'],
      'counselorCount': 5,
      'experience': 8, // 年
      'rating': 4.7,
      'availability': '周一、周三、周五',
      'qualifications': [
        '临床心理学硕士',
        'EMDR治疗认证',
        '正念减压认证导师',
      ],
    },
    {
      'id': 's004',
      'name': '李督导',
      'avatar': 'L',
      'title': '资深心理督导师',
      'email': 'li_supervisor@example.com',
      'phone': '13900139004',
      'status': '休假',
      'specialties': ['人格障碍', '成瘾行为', '创伤后应激障碍'],
      'counselorCount': 3,
      'experience': 15, // 年
      'rating': 4.9,
      'availability': '周二、周四',
      'qualifications': [
        '临床心理学博士',
        '辩证行为疗法认证',
        '创伤治疗专家认证',
      ],
    },
  ];
  
  // 督导所管理的咨询师
  final Map<String, List<Map<String, dynamic>>> _supervisorCounselors = {
    's001': [
      {'id': 'c001', 'name': '王咨询师'},
      {'id': 'c003', 'name': '张咨询师'},
      {'id': 'c006', 'name': '钱咨询师'},
      {'id': 'c008', 'name': '吴咨询师'},
      {'id': 'c009', 'name': '郑咨询师'},
      {'id': 'c011', 'name': '冯咨询师'},
      {'id': 'c012', 'name': '陈咨询师'},
      {'id': 'c015', 'name': '朱咨询师'},
    ],
    's002': [
      {'id': 'c002', 'name': '李咨询师'},
      {'id': 'c004', 'name': '赵咨询师'},
      {'id': 'c007', 'name': '郭咨询师'},
      {'id': 'c010', 'name': '周咨询师'},
      {'id': 'c013', 'name': '许咨询师'},
      {'id': 'c014', 'name': '何咨询师'},
    ],
    's003': [
      {'id': 'c005', 'name': '孙咨询师'},
      {'id': 'c016', 'name': '贾咨询师'},
      {'id': 'c017', 'name': '彭咨询师'},
      {'id': 'c018', 'name': '毛咨询师'},
      {'id': 'c019', 'name': '董咨询师'},
    ],
    's004': [
      {'id': 'c020', 'name': '袁咨询师'},
      {'id': 'c021', 'name': '于咨询师'},
      {'id': 'c022', 'name': '徐咨询师'},
    ],
  };
  
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
    '压力管理',
    '睡眠障碍',
    '正念疗法',
    '人格障碍',
    '成瘾行为',
    '创伤后应激障碍',
    '认知行为疗法',
    '精神分析',
  ];
  
  // 当前选中的督导ID
  String? _selectedSupervisorId;
  
  // 获取筛选后的督导列表
  List<Map<String, dynamic>> get _filteredSupervisors {
    return _supervisors.where((supervisor) {
      // 搜索关键词筛选
      if (_searchKeyword.isNotEmpty) {
        final keyword = _searchKeyword.toLowerCase();
        final name = supervisor['name'].toLowerCase();
        final title = supervisor['title'].toLowerCase();
        final email = supervisor['email'].toLowerCase();
        
        if (!name.contains(keyword) && 
            !title.contains(keyword) && 
            !email.contains(keyword)) {
          return false;
        }
      }
      
      // 状态筛选
      if (_filterStatus != null && _filterStatus != '全部') {
        if (supervisor['status'] != _filterStatus) {
          return false;
        }
      }
      
      // 专长筛选
      if (_filterSpecialty != null && _filterSpecialty != '全部') {
        final specialties = List<String>.from(supervisor['specialties']);
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
          
          // 督导列表和详情
          Expanded(
            child: _filteredSupervisors.isEmpty
                ? _buildEmptyState(colorScheme)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 督导列表
                      Expanded(
                        flex: 3,
                        child: _buildSupervisorList(colorScheme),
                      ),
                      
                      // 分隔线
                      const SizedBox(width: 16),
                      const VerticalDivider(),
                      const SizedBox(width: 16),
                      
                      // 督导详情
                      Expanded(
                        flex: 2,
                        child: _selectedSupervisorId != null
                            ? _buildSupervisorDetail(colorScheme)
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      size: 48,
                                      color: colorScheme.onBackground.withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '选择一位督导查看详情',
                                      style: TextStyle(
                                        color: colorScheme.onBackground.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
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
                  hintText: '搜索督导...',
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
            
            // 添加新督导按钮
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('添加督导'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
              ),
              onPressed: () {
                // TODO: 添加督导逻辑
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
            Icons.support_agent_outlined,
            size: 64,
            color: colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到符合条件的督导',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorList(ColorScheme colorScheme) {
    return ListView.builder(
      itemCount: _filteredSupervisors.length,
      itemBuilder: (context, index) {
        final supervisor = _filteredSupervisors[index];
        final isSelected = supervisor['id'] == _selectedSupervisorId;
        
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
                _selectedSupervisorId = supervisor['id'];
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.7),
                    child: Text(
                      supervisor['avatar'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 基本信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              supervisor['name'],
                              style: const TextStyle(
                                fontSize: 16,
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
                                color: supervisor['status'] == '在职'
                                    ? Colors.green.withOpacity(0.1)
                                    : supervisor['status'] == '休假'
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                supervisor['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: supervisor['status'] == '在职'
                                      ? Colors.green
                                      : supervisor['status'] == '休假'
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          supervisor['title'],
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${supervisor['counselorCount']} 位咨询师',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${supervisor['rating']}',
                              style: const TextStyle(fontSize: 12),
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
                          // TODO: 编辑督导逻辑
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.people_alt_outlined),
                        tooltip: '分配咨询师',
                        onPressed: () {
                          // TODO: 分配咨询师逻辑
                        },
                      ),
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

  Widget _buildSupervisorDetail(ColorScheme colorScheme) {
    // 获取当前选中的督导信息
    final supervisor = _supervisors.firstWhere(
      (s) => s['id'] == _selectedSupervisorId,
      orElse: () => _supervisors.first,
    );
    
    // 获取当前督导管理的咨询师
    final counselors = _supervisorCounselors[supervisor['id']] ?? [];
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Text(
                '督导详情',
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
                    _selectedSupervisorId = null;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 个人信息卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 督导信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          supervisor['avatar'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supervisor['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            supervisor['title'],
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${supervisor['experience']} 年经验',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                supervisor['availability'],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // 联系信息
                  Text(
                    '联系信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(supervisor['email']),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(supervisor['phone']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 资质认证
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '资质认证',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Column(
                    children: List.generate(
                      supervisor['qualifications'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(supervisor['qualifications'][index]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 专长领域
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '专长领域',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      supervisor['specialties'].length,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          supervisor['specialties'][index],
                          style: TextStyle(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 管理的咨询师
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '管理的咨询师',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '共 ${counselors.length} 人',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  counselors.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              '暂无管理的咨询师',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(
                            counselors.length,
                            (index) => Chip(
                              avatar: CircleAvatar(
                                backgroundColor: colorScheme.primary.withOpacity(0.8),
                                child: Text(
                                  counselors[index]['name'][0],
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              label: Text(counselors[index]['name']),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                // TODO: 移除咨询师逻辑
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
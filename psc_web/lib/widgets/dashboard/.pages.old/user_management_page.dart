import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psc_web/models/user/user.dart';
import 'package:psc_web/providers/user/user_provider.dart';
import 'package:psc_web/theme/app_colors.dart';

/// 用户管理页面
class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> with SingleTickerProviderStateMixin {
  // 搜索关键词
  String _searchKeyword = '';

  // 筛选选项
  String? _filterRole;
  String? _filterStatus;

  // 选中的用户ID
  String? _selectedUserId;

  // Tab控制器
  late TabController _tabController;

  // 角色选项
  final List<String> _roleOptions = [
    '全部',
    'admin',
    'client',
    'counselor',
    'supervisor',
  ];

  // 状态选项
  final List<String> _statusOptions = [
    '全部',
    '激活',
    '停用',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // 加载用户数据
    Future.microtask(() {
      context.read<UserProvider>().loadAllUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 获取Tab对应的用户角色
  UserRole _getRoleForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return UserRole.client;
      case 1:
        return UserRole.counselor;
      case 2:
        return UserRole.supervisor;
      case 3:
        return UserRole.admin;
      default:
        return UserRole.client;
    }
  }

  // 获取筛选后的用户列表
  List<User> _getFilteredUsers(List<User> users, int tabIndex) {
    return users.where((user) {
      // 首先按角色分组到不同Tab页
      final userRole = user.role;
      final tabRole = _getRoleForTab(tabIndex);
      if (userRole != tabRole) {
        return false;
      }

      // 搜索关键词筛选
      if (_searchKeyword.isNotEmpty) {
        final keyword = _searchKeyword.toLowerCase();
        final username = user.username.toLowerCase();
        final name = user.name.toLowerCase();
        final email = user.email.toLowerCase();
        final phone = user.phone?.toLowerCase() ?? '';

        if (!username.contains(keyword) &&
            !name.contains(keyword) &&
            !email.contains(keyword) &&
            !phone.contains(keyword)) {
          return false;
        }
      }

      // 状态筛选
      if (_filterStatus != null && _filterStatus != '全部') {
        final isActive = user.status == UserStatus.active;
        final statusFilter = _filterStatus == '激活';
        if (isActive != statusFilter) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // 判断用户是否处于激活状态
  bool _isUserActive(User user) {
    return user.status == UserStatus.active;
  }

  // 获取角色中文名称
  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '管理员';
      case UserRole.client:
        return '来访者';
      case UserRole.counselor:
        return '咨询师';
      case UserRole.supervisor:
        return '督导';
      default:
        return '未知角色';
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
              Tab(text: '来访者'),
              Tab(text: '咨询师'),
              Tab(text: '督导'),
              Tab(text: '管理员'),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
          ),

          const SizedBox(height: 16),

          // 用户数据
          Expanded(
            child: Consumer<UserProvider>(
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
                          onPressed: () => provider.loadAllUsers(),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  );
                }

                final allUsers = provider.users ?? [];

                if (allUsers.isEmpty) {
                  return _buildEmptyState(colorScheme);
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户列表
                    Expanded(
                      flex: 3,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // 来访者
                          _buildUserList(_getFilteredUsers(allUsers, 0), colorScheme),
                          // 咨询师
                          _buildUserList(_getFilteredUsers(allUsers, 1), colorScheme),
                          // 督导
                          _buildUserList(_getFilteredUsers(allUsers, 2), colorScheme),
                          // 管理员
                          _buildUserList(_getFilteredUsers(allUsers, 3), colorScheme),
                        ],
                      ),
                    ),

                    // 分隔线和用户详情
                    if (_selectedUserId != null) ...[
                      const SizedBox(width: 16),
                      const VerticalDivider(),
                      const SizedBox(width: 16),

                      // 用户详情
                      Expanded(
                        flex: 2,
                        child: _buildUserDetail(
                          _getUserById(allUsers, _selectedUserId!),
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

  // 根据ID获取用户
  User? _getUserById(List<User> users, String id) {
    for (final user in users) {
      if (user.id == id) {
        return user;
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
                  hintText: '搜索用户...',
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

            // 创建用户按钮
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('创建用户'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
              ),
              onPressed: () {
                // TODO: 创建用户逻辑
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

            const Spacer(),

            // 清除筛选按钮
            TextButton.icon(
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('清除筛选'),
              onPressed: () {
                setState(() {
                  _searchKeyword = '';
                  _filterRole = null;
                  _filterStatus = null;
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
            '没有找到符合条件的用户',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<User> users, ColorScheme colorScheme) {
    if (users.isEmpty) {
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
              '没有找到符合条件的用户',
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
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = _selectedUserId == user.id;
        final isActive = _isUserActive(user);

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
                _selectedUserId = user.id;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 用户头像
                  CircleAvatar(
                    backgroundColor: isActive
                        ? colorScheme.primary.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                    radius: 24,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : '?',
                      style: TextStyle(
                        color: isActive ? colorScheme.primary : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 用户信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 用户名和状态
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive ? '激活' : '停用',
                                style: TextStyle(
                                  color: isActive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // 用户名和角色
                        Row(
                          children: [
                            Text(
                              '用户名: ${user.username}',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '角色: ${_getRoleName(user.role)}',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // 联系方式
                        if (user.email != null || user.phone != null)
                          Row(
                            children: [
                              if (user.email.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    '邮箱: ${user.email}',
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              if (user.phone != null)
                                Text(
                                  '电话: ${user.phone}',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // 操作按钮
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    tooltip: '更多操作',
                    onPressed: () {
                      _showUserActionMenu(context, user, colorScheme);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUserActionMenu(BuildContext context, User user, ColorScheme colorScheme) {
    final userProvider = context.read<UserProvider>();
    final isActive = _isUserActive(user);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 100, 0, 0), // 位置需要根据实际情况调整
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 18,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              const Text('编辑用户'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: isActive ? 'deactivate' : 'activate',
          child: Row(
            children: [
              Icon(
                isActive ? Icons.block : Icons.check_circle,
                size: 18,
                color: isActive ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(isActive ? '停用用户' : '激活用户'),
            ],
          ),
        ),
        if (user.role == UserRole.counselor) ...[
          PopupMenuItem<String>(
            value: 'assign_supervisor',
            child: Row(
              children: [
                Icon(
                  Icons.supervisor_account,
                  size: 18,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                const Text('分配督导'),
              ],
            ),
          ),
        ],
        PopupMenuItem<String>(
          value: 'reset_password',
          child: Row(
            children: [
              Icon(
                Icons.password,
                size: 18,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              const Text('重置密码'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'edit':
          // TODO: 编辑用户
          break;
        case 'deactivate':
          _deactivateUser(user);
          break;
        case 'activate':
          _activateUser(user);
          break;
        case 'assign_supervisor':
          // TODO: 分配督导
          break;
        case 'reset_password':
          _showResetPasswordDialog(user);
          break;
      }
    });
  }

  void _deactivateUser(User user) {
    final updatedUser = user.copyWith(status: UserStatus.suspended);
    context.read<UserProvider>().updateUser(updatedUser);
  }

  void _activateUser(User user) {
    final updatedUser = user.copyWith(status: UserStatus.active);
    context.read<UserProvider>().updateUser(updatedUser);
  }

  void _showResetPasswordDialog(User user) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('重置${user.name}的密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请输入新密码:'),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '新密码',
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
              if (passwordController.text.isNotEmpty) {
                Navigator.of(context).pop();
                _resetPassword(user, passwordController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认重置'),
          ),
        ],
      ),
    );
  }

  void _resetPassword(User user, String newPassword) {
    context.read<UserProvider>().resetPassword(user.id, newPassword);
  }

  Widget _buildUserDetail(User? user, ColorScheme colorScheme) {
    if (user == null) {
      return Center(
        child: Text(
          '未找到用户详情',
          style: TextStyle(
            color: colorScheme.error,
          ),
        ),
      );
    }

    final isActive = _isUserActive(user);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和关闭按钮
          Row(
            children: [
              Text(
                '用户详情',
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
                    _selectedUserId = null;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 用户基本信息卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户头像和状态
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: isActive
                              ? colorScheme.primary.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                          radius: 40,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0] : '?',
                            style: TextStyle(
                              color: isActive ? colorScheme.primary : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            isActive ? '激活' : '停用',
                            style: TextStyle(
                              color: isActive ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 基本信息标题
                  const Text(
                    '基本信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 账号信息
                  _buildDetailItem(
                    icon: Icons.person,
                    title: '用户名',
                    content: user.username,
                  ),

                  _buildDetailItem(
                    icon: Icons.verified_user,
                    title: '角色',
                    content: _getRoleName(user.role),
                  ),

                  _buildDetailItem(
                    icon: Icons.perm_identity,
                    title: '用户ID',
                    content: user.id,
                  ),

                  // 联系方式
                  _buildDetailItem(
                    icon: Icons.email,
                    title: '电子邮箱',
                    content: user.email,
                  ),

                  if (user.phone != null)
                    _buildDetailItem(
                      icon: Icons.phone,
                      title: '联系电话',
                      content: user.phone!,
                    ),

                  // 账号信息
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: '创建时间',
                    content: _formatDateTime(user.createdAt),
                  ),

                  if (user.lastLoginAt != null)
                    _buildDetailItem(
                      icon: Icons.login,
                      title: '上次登录',
                      content: _formatDateTime(user.lastLoginAt!),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 角色特有信息
          if (user.role == UserRole.counselor) _buildCounselorDetail(user, colorScheme),
          if (user.role == UserRole.supervisor) _buildSupervisorDetail(user, colorScheme),
          if (user.role == UserRole.client) _buildClientDetail(user, colorScheme),
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

  // 咨询师特有信息
  Widget _buildCounselorDetail(User user, ColorScheme colorScheme) {
    // 从profile中提取咨询师特有信息
    final profile = user.profile;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '咨询师信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 督导信息
            _buildDetailItem(
              icon: Icons.supervisor_account,
              title: '所属督导',
              content: profile['supervisor_name'] ?? '未分配',
            ),

            // 专业方向
            _buildDetailItem(
              icon: Icons.psychology,
              title: '专业方向',
              content: (profile['expertise'] as List<dynamic>?)?.join(', ') ?? '未设置',
            ),

            // 咨询数量
            _buildDetailItem(
              icon: Icons.history,
              title: '咨询次数',
              content: profile['consultation_count']?.toString() ?? '0',
            ),

            // 评分
            _buildDetailItem(
              icon: Icons.star,
              title: '平均评分',
              content: profile['rating'] != null ? '${profile['rating']}/5' : '暂无评分',
            ),

            // 简介
            if (profile['introduction'] != null)
              _buildDetailItem(
                icon: Icons.info,
                title: '个人简介',
                content: profile['introduction'],
                isMultiLine: true,
              ),
          ],
        ),
      ),
    );
  }

  // 督导特有信息
  Widget _buildSupervisorDetail(User user, ColorScheme colorScheme) {
    // 从profile中提取督导特有信息
    final profile = user.profile;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '督导信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 专业方向
            _buildDetailItem(
              icon: Icons.psychology,
              title: '专业方向',
              content: (profile['expertise'] as List<dynamic>?)?.join(', ') ?? '未设置',
            ),

            // 资质
            _buildDetailItem(
              icon: Icons.verified,
              title: '专业资质',
              content: profile['qualification'] ?? '未设置',
            ),

            // 工作经验
            _buildDetailItem(
              icon: Icons.work,
              title: '工作经验',
              content: profile['experience_years'] != null ? '${profile['experience_years']}年' : '未设置',
            ),

            // 督导的咨询师
            _buildDetailItem(
              icon: Icons.people,
              title: '督导咨询师',
              content: '${(profile['supervisees'] as List<dynamic>?)?.length ?? 0}人',
            ),

            // 简介
            if (profile['introduction'] != null)
              _buildDetailItem(
                icon: Icons.info,
                title: '个人简介',
                content: profile['introduction'],
                isMultiLine: true,
              ),
          ],
        ),
      ),
    );
  }

  // 来访者特有信息
  Widget _buildClientDetail(User user, ColorScheme colorScheme) {
    // 从profile中提取来访者特有信息
    final profile = user.profile;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '来访者信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 年龄
            if (profile['age'] != null)
              _buildDetailItem(
                icon: Icons.cake,
                title: '年龄',
                content: '${profile['age']}岁',
              ),

            // 性别
            if (profile['gender'] != null)
              _buildDetailItem(
                icon: Icons.people,
                title: '性别',
                content: profile['gender'] == 'male' ? '男' : '女',
              ),

            // 来访次数
            _buildDetailItem(
              icon: Icons.history,
              title: '来访次数',
              content: profile['consultation_count']?.toString() ?? '0',
            ),

            // 备注
            if (profile['notes'] != null)
              _buildDetailItem(
                icon: Icons.note,
                title: '备注',
                content: profile['notes'],
                isMultiLine: true,
              ),
          ],
        ),
      ),
    );
  }
} 
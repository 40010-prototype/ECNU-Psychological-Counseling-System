import 'package:psc_web/models/user/user.dart';

/// 用户服务接口
abstract class UserService {
  /// 获取所有用户
  Future<List<User>> getAllUsers();
  
  /// 获取指定ID的用户
  Future<User> getUserById(String id);
  
  /// 根据角色获取用户列表
  Future<List<User>> getUsersByRole(UserRole role);
  
  /// 根据用户名或姓名搜索用户
  Future<List<User>> searchUsers(String keyword);
  
  /// 创建新用户
  Future<User> createUser(User user);
  
  /// 更新用户信息
  Future<User> updateUser(User user);
  
  /// 更新用户状态
  Future<bool> updateUserStatus(String id, UserStatus status);
  
  /// 删除用户
  Future<bool> deleteUser(String id);
  
  /// 获取所有咨询师
  Future<List<User>> getAllCounselors();
  
  /// 获取所有督导
  Future<List<User>> getAllSupervisors();
  
  /// 获取咨询师的督导
  Future<User?> getCounselorSupervisor(String counselorId);
  
  /// 获取督导的咨询师列表
  Future<List<User>> getSupervisorCounselors(String supervisorId);
  
  /// 分配督导给咨询师
  Future<bool> assignSupervisorToCounselor(String counselorId, String supervisorId);
  
  /// 更新用户密码
  Future<bool> updatePassword(String id, String newPassword);
  
  /// 验证用户密码
  Future<bool> verifyPassword(String id, String password);
  
  /// 记录用户登录
  Future<bool> recordUserLogin(String id, String ip);
}

/// Mock用户服务实现
class MockUserService implements UserService {
  final List<User> _users = [];
  
  MockUserService() {
    _initMockData();
  }
  
  void _initMockData() {
    // 添加模拟数据
    _users.addAll([
      User(
        id: '1',
        username: 'admin',
        name: '系统管理员',
        email: 'admin@ecnu.edu.cn',
        role: UserRole.admin,
        status: UserStatus.active,
        profile: {},
        createdAt: DateTime.now(),
      ),
      User(
        id: '2',
        username: 'counselor1',
        name: '张三',
        email: 'counselor1@ecnu.edu.cn',
        role: UserRole.counselor,
        status: UserStatus.active,
        profile: CounselorProfile(
          title: '心理咨询师',
          qualification: '国家二级心理咨询师',
          expertise: ['情感问题', '学业压力', '职业规划'],
          introduction: '从事心理咨询工作5年，擅长处理青年学生的心理问题。',
        ).toJson(),
        createdAt: DateTime.now(),
      ),
      User(
        id: '3',
        username: 'supervisor1',
        name: '李四',
        email: 'supervisor1@ecnu.edu.cn',
        role: UserRole.supervisor,
        status: UserStatus.active,
        profile: SupervisorProfile(
          title: '心理学教授',
          qualification: '国家一级心理咨询师',
          expertise: ['认知行为疗法', '精神分析', '团体咨询'],
          introduction: '心理学博士，从事心理咨询和督导工作15年。',
          supervisees: ['2'],
        ).toJson(),
        createdAt: DateTime.now(),
      ),
      User(
        id: '4',
        username: '10001',
        name: '王五',
        email: '10001@ecnu.edu.cn',
        role: UserRole.client,
        status: UserStatus.active,
        profile: ClientProfile(
          studentId: '10001',
          department: '心理与认知科学学院',
          major: '应用心理学',
          grade: 2023,
        ).toJson(),
        createdAt: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _users;
  }

  @override
  Future<User> getUserById(String id) async {
    final user = _users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('User not found'),
    );
    return user;
  }

  @override
  Future<List<User>> getUsersByRole(UserRole role) async {
    return _users.where((u) => u.role == role).toList();
  }

  @override
  Future<List<User>> searchUsers(String keyword) async {
    final lowercaseKeyword = keyword.toLowerCase();
    return _users.where((u) =>
      u.username.toLowerCase().contains(lowercaseKeyword) ||
      u.name.toLowerCase().contains(lowercaseKeyword)
    ).toList();
  }

  @override
  Future<User> createUser(User user) async {
    if (_users.any((u) => u.username == user.username)) {
      throw Exception('Username already exists');
    }
    _users.add(user);
    return user;
  }

  @override
  Future<User> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index == -1) {
      throw Exception('User not found');
    }
    _users[index] = user;
    return user;
  }

  @override
  Future<bool> updateUserStatus(String id, UserStatus status) async {
    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) {
      return false;
    }
    _users[index] = _users[index].copyWith(status: status);
    return true;
  }

  @override
  Future<bool> deleteUser(String id) async {
    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) {
      return false;
    }
    _users.removeAt(index);
    return true;
  }

  @override
  Future<List<User>> getAllCounselors() async {
    return _users.where((u) => u.role == UserRole.counselor).toList();
  }

  @override
  Future<List<User>> getAllSupervisors() async {
    return _users.where((u) => u.role == UserRole.supervisor).toList();
  }

  @override
  Future<User?> getCounselorSupervisor(String counselorId) async {
    final counselor = await getUserById(counselorId);
    if (counselor.role != UserRole.counselor) {
      throw Exception('User is not a counselor');
    }
    
    final counselorProfile = CounselorProfile.fromJson(counselor.profile ?? {});
    if (counselorProfile.supervisor == null) {
      return null;
    }
    
    return getUserById(counselorProfile.supervisor!);
  }

  @override
  Future<List<User>> getSupervisorCounselors(String supervisorId) async {
    final supervisor = await getUserById(supervisorId);
    if (supervisor.role != UserRole.supervisor) {
      throw Exception('User is not a supervisor');
    }
    
    final supervisorProfile = SupervisorProfile.fromJson(supervisor.profile ?? {}); 
    final counselors = <User>[];
    for (final counselorId in supervisorProfile.supervisees) {
      try {
        final counselor = await getUserById(counselorId);
        counselors.add(counselor);
      } catch (e) {
        // Skip if counselor not found
      }
    }
    return counselors;
  }

  @override
  Future<bool> assignSupervisorToCounselor(String counselorId, String supervisorId) async {
    try {
      final counselor = await getUserById(counselorId);
      final supervisor = await getUserById(supervisorId);
      
      if (counselor.role != UserRole.counselor) {
        throw Exception('User is not a counselor');
      }
      if (supervisor.role != UserRole.supervisor) {
        throw Exception('User is not a supervisor');
      }
      
      // 更新咨询师的督导
      final counselorProfile = CounselorProfile.fromJson(counselor.profile ?? {});
      final updatedCounselor = counselor.copyWith(
        profile: CounselorProfile(
          title: counselorProfile.title,
          qualification: counselorProfile.qualification,
          expertise: counselorProfile.expertise,
          introduction: counselorProfile.introduction,
          supervisor: supervisorId,
        ).toJson(),
      );
      
      // 更新督导的咨询师列表
      final supervisorProfile = SupervisorProfile.fromJson(supervisor.profile ?? {});
      if (!supervisorProfile.supervisees.contains(counselorId)) {
        final updatedSupervisor = supervisor.copyWith(
          profile: SupervisorProfile(
            title: supervisorProfile.title,
            qualification: supervisorProfile.qualification,
            expertise: supervisorProfile.expertise,
            introduction: supervisorProfile.introduction,
            supervisees: [...supervisorProfile.supervisees, counselorId],
          ).toJson(),
        );
        await updateUser(updatedSupervisor);
      }
      
      await updateUser(updatedCounselor);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updatePassword(String id, String newPassword) async {
    // 在实际应用中，这里需要对密码进行加密处理
    return true;
  }

  @override
  Future<bool> verifyPassword(String id, String password) async {
    // 在实际应用中，这里需要对密码进行验证
    return true;
  }

  @override
  Future<bool> recordUserLogin(String id, String ip) async {
    try {
      final user = await getUserById(id);
      final updatedUser = user.copyWith(
        lastLoginIp: ip,
        lastLoginAt: DateTime.now(),
      );
      await updateUser(updatedUser);
      return true;
    } catch (e) {
      return false;
    }
  }
} 
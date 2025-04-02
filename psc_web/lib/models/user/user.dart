/// 用户角色枚举
enum UserRole {
  admin,         // 管理员
  counselor,     // 咨询师
  supervisor,    // 督导
  client,        // 来访者
}

/// 用户状态枚举
enum UserStatus {
  active,        // 正常
  inactive,      // 未激活
  suspended,     // 已停用
  deleted,       // 已删除
}

/// 用户模型
class User {
  final String id;
  final String username;      // 用户名
  final String name;          // 姓名
  final String? avatar;       // 头像URL
  final String email;         // 邮箱
  final String? phone;        // 电话
  final UserRole role;        // 角色
  final UserStatus status;    // 状态
  final Map<String, dynamic> profile;  // 用户详细信息
  final DateTime createdAt;   // 创建时间
  final DateTime? updatedAt;  // 更新时间
  final String? lastLoginIp;  // 最后登录IP
  final DateTime? lastLoginAt;  // 最后登录时间

  User({
    required this.id,
    required this.username,
    required this.name,
    this.avatar,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    required this.profile,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginIp,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == 'UserStatus.${json['status']}',
      ),
      profile: json['profile'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLoginIp: json['lastLoginIp'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'profile': profile,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginIp': lastLoginIp,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// 创建一个新的User实例，可以选择性地更新某些字段
  User copyWith({
    String? id,
    String? username,
    String? name,
    String? avatar,
    String? email,
    String? phone,
    UserRole? role,
    UserStatus? status,
    Map<String, dynamic>? profile,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastLoginIp,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

/// 用户详细信息 - 来访者
class ClientProfile {
  final String studentId;     // 学号
  final String department;    // 院系
  final String major;         // 专业
  final int grade;           // 年级
  final String? emergencyContact;  // 紧急联系人
  final String? emergencyPhone;    // 紧急联系电话

  ClientProfile({
    required this.studentId,
    required this.department,
    required this.major,
    required this.grade,
    this.emergencyContact,
    this.emergencyPhone,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(
      studentId: json['studentId'] as String,
      department: json['department'] as String,
      major: json['major'] as String,
      grade: json['grade'] as int,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'department': department,
      'major': major,
      'grade': grade,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
    };
  }
}

/// 用户详细信息 - 咨询师
class CounselorProfile {
  final String title;         // 职称
  final String qualification; // 资质
  final List<String> expertise;  // 专长领域
  final String introduction;  // 个人简介
  final String? supervisor;   // 督导ID

  CounselorProfile({
    required this.title,
    required this.qualification,
    required this.expertise,
    required this.introduction,
    this.supervisor,
  });

  factory CounselorProfile.fromJson(Map<String, dynamic> json) {
    return CounselorProfile(
      title: json['title'] as String,
      qualification: json['qualification'] as String,
      expertise: List<String>.from(json['expertise']),
      introduction: json['introduction'] as String,
      supervisor: json['supervisor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'qualification': qualification,
      'expertise': expertise,
      'introduction': introduction,
      'supervisor': supervisor,
    };
  }
}

/// 用户详细信息 - 督导
class SupervisorProfile {
  final String title;         // 职称
  final String qualification; // 资质
  final List<String> expertise;  // 专长领域
  final String introduction;  // 个人简介
  final List<String> supervisees;  // 被督导的咨询师ID列表

  SupervisorProfile({
    required this.title,
    required this.qualification,
    required this.expertise,
    required this.introduction,
    required this.supervisees,
  });

  factory SupervisorProfile.fromJson(Map<String, dynamic> json) {
    return SupervisorProfile(
      title: json['title'] as String,
      qualification: json['qualification'] as String,
      expertise: List<String>.from(json['expertise']),
      introduction: json['introduction'] as String,
      supervisees: List<String>.from(json['supervisees']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'qualification': qualification,
      'expertise': expertise,
      'introduction': introduction,
      'supervisees': supervisees,
    };
  }
} 
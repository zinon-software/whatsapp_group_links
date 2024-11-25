

class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String phoneNumber;
  final PermissionModel permissions;
  final int score;
  final double coins;
  final String? country;
  final bool isStopAds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.phoneNumber,
    required this.permissions,
    this.score = 0,
    this.coins = 0,
    this.country,
    this.isStopAds = false,
  });

  // إنشاء كائن UserModel من مستند Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel user = UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
      photoUrl: json['photo_url'] ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      lastLoginAt:
          DateTime.tryParse(json['last_login_at'].toString()) ?? DateTime.now(),
      phoneNumber: json['phone_number'] ?? '',
      permissions: PermissionModel.fromJson(
        json['permissions'] as Map<String, dynamic>,
      ),
      score: json['score'] ?? 0,
      coins: json['coins'] ?? 0,
      country: json['country'],
      isStopAds: json['is_stop_ads'] ?? false,
    );

    return user;
  }

  // تحويل الكائن إلى Map لتخزينه في Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt.toIso8601String(),
      'phone_number': phoneNumber,
      "permissions": permissions.toJson(),
      'score': score,
      'coins': coins,
      'country': country,
      'is_stop_ads': isStopAds
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? phoneNumber,
    PermissionModel? permissions,
    int? score,
    double? coins,
    String? country,
    bool? isStopAds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      permissions: permissions ?? this.permissions,
      score: score ?? this.score,
      coins: coins ?? this.coins,
      country: country ?? this.country,
      isStopAds: isStopAds ?? this.isStopAds,
    );
  }

  static UserModel isEmpty() {
    return UserModel(
      id: '',
      name: '====== ===',
      email: '==================',
      photoUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      phoneNumber: '',
      permissions: PermissionModel(),
    );
  }
}

class PermissionModel {
  final bool isAdmin;
  final bool isActive;
  final bool canAdd;
  final bool canEdit;
  final bool canDelete;
  final bool canView;
  final bool canViewAccounts;

  PermissionModel({
    this.isAdmin = false,
    this.isActive = true,
    this.canAdd = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canView = false,
    this.canViewAccounts = false,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        isAdmin: json['is_admin'] ?? false,
        isActive: json['is_active'] ?? true,
        canAdd: json['can_add'] ?? false,
        canEdit: json['can_edit'] ?? false,
        canDelete: json['can_delete'] ?? false,
        canView: json['can_view'] ?? false,
        canViewAccounts: json['can_view_accounts'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'is_admin': isAdmin,
        'is_active': isActive,
        'can_add': canAdd,
        'can_edit': canEdit,
        'can_delete': canDelete,
        'can_view': canView,
        'can_view_accounts': canViewAccounts,
      };
}

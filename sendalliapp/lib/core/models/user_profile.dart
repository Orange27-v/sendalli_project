import 'user_role.dart';

/// Strongly typed profile data model for authenticated Sendalli users.
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final UserRole role;
  final String pin;
  final int trustScore;

  // Role-specific progressive fields
  final String? email;
  final String? shopName;
  final String? vehiclePlate;
  final String? corridor;
  final String? unionPark;
  final String? landmark;
  final bool isVerified;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.pin,
    this.trustScore = 80,
    this.email,
    this.shopName,
    this.vehiclePlate,
    this.corridor,
    this.unionPark,
    this.landmark,
    this.isVerified = false,
  });

  /// Factory constructor for unauthenticated roadside guest receivers
  factory UserProfile.guestReceiver({String? corridor, String? landmark}) {
    return UserProfile(
      id: 'GUEST-RECEIVER',
      firstName: 'Roadside',
      lastName: 'Receiver',
      phone: '',
      role: UserRole.receiver,
      pin: '',
      corridor: corridor ?? 'Refinery Road — Jakpa',
      landmark: landmark ?? 'Roadside Handoff',
      isVerified: false,
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    UserRole? role,
    String? pin,
    int? trustScore,
    String? email,
    String? shopName,
    String? vehiclePlate,
    String? corridor,
    String? unionPark,
    String? landmark,
    bool? isVerified,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      pin: pin ?? this.pin,
      trustScore: trustScore ?? this.trustScore,
      email: email ?? this.email,
      shopName: shopName ?? this.shopName,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      corridor: corridor ?? this.corridor,
      unionPark: unionPark ?? this.unionPark,
      landmark: landmark ?? this.landmark,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role.name,
      'pin': pin,
      'trustScore': trustScore,
      'email': email,
      'shopName': shopName,
      'vehiclePlate': vehiclePlate,
      'corridor': corridor,
      'unionPark': unionPark,
      'landmark': landmark,
      'isVerified': isVerified,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      role: UserRole.values.byName(json['role'] as String),
      pin: json['pin'] as String,
      trustScore: (json['trustScore'] as int?) ?? 80,
      email: json['email'] as String?,
      shopName: json['shopName'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      corridor: json['corridor'] as String?,
      unionPark: json['unionPark'] as String?,
      landmark: json['landmark'] as String?,
      isVerified: (json['isVerified'] as bool?) ?? false,
    );
  }
}

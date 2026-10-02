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
  final bool? _isVerified;

  // Business Sender verification fields (CAC registration certificate)
  final String? cacNumber;
  final String? businessCertificateName;
  final String? tinNumber;
  final String? bankName;
  final String? accountNumber;
  final bool? _isBusinessVerified;

  bool get isVerified => _isVerified ?? false;
  bool get isBusinessVerified => _isBusinessVerified ?? false;

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
    bool isVerified = false,
    this.cacNumber,
    this.businessCertificateName,
    this.tinNumber,
    this.bankName,
    this.accountNumber,
    bool isBusinessVerified = false,
  })  : _isVerified = isVerified,
        _isBusinessVerified = isBusinessVerified;

  /// Factory constructor for unauthenticated roadside guest receivers
  factory UserProfile.guestReceiver({String? corridor, String? landmark}) {
    return const UserProfile(
      id: 'GUEST-RECEIVER',
      firstName: 'Roadside',
      lastName: 'Receiver',
      phone: '',
      role: UserRole.receiver,
      pin: '',
      corridor: 'Refinery Road — Jakpa',
      landmark: 'Roadside Handoff',
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
    String? cacNumber,
    String? businessCertificateName,
    String? tinNumber,
    String? bankName,
    String? accountNumber,
    bool? isBusinessVerified,
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
      cacNumber: cacNumber ?? this.cacNumber,
      businessCertificateName: businessCertificateName ?? this.businessCertificateName,
      tinNumber: tinNumber ?? this.tinNumber,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
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
      'cacNumber': cacNumber,
      'businessCertificateName': businessCertificateName,
      'tinNumber': tinNumber,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'isBusinessVerified': isBusinessVerified,
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
      cacNumber: json['cacNumber'] as String?,
      businessCertificateName: json['businessCertificateName'] as String?,
      tinNumber: json['tinNumber'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      isBusinessVerified: (json['isBusinessVerified'] as bool?) ?? false,
    );
  }
}

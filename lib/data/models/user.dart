import 'package:objectbox/objectbox.dart';

// part 'user.g.dart';

@Entity()
class User {
  @Id()
  int storageID = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  final String userID; // Mapped from 'id'

  final String? fullName;
  final String? email;
  final String? phone;
  final bool? isVerified;
  final String? termsVersion;

  @Property(type: PropertyType.date)
  final DateTime? createdAt;

  @Property(type: PropertyType.date)
  final DateTime? termsAcceptedAt;

  User({
    required this.userID,
    this.fullName,
    this.email,
    this.phone,
    this.isVerified,
    this.termsVersion,
    this.createdAt,
    this.termsAcceptedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json['user'] ?? json;

    return User(
      userID: data['id']?.toString() ?? '',
      fullName: data['full_name'],
      email: data['email'],
      phone: data['phone'],
      isVerified: data['is_verified'],
      termsVersion: data['terms_version'],
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'])
          : null,
      termsAcceptedAt: data['terms_accepted_at'] != null
          ? DateTime.tryParse(data['terms_accepted_at'])
          : null,
    );
  }

  User copyWith({
    String? userID,
    String? fullName,
    String? email,
    String? phone,
    bool? isVerified,
    String? termsVersion,
    DateTime? createdAt,
    DateTime? termsAcceptedAt,
  }) {
    return User(
      userID: userID ?? this.userID,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      termsVersion: termsVersion ?? this.termsVersion,
      createdAt: createdAt ?? this.createdAt,
      termsAcceptedAt: termsAcceptedAt ?? this.termsAcceptedAt,
    );
  }

  @override
  String toString() {
    return 'User('
        'userID: $userID, '
        'fullName: $fullName, '
        'email: $email, '
        'phone: $phone, '
        'isVerified: $isVerified, '
        'termsVersion: $termsVersion, '
        'createdAt: $createdAt, '
        'termsAcceptedAt: $termsAcceptedAt'
        ')';
  }
}

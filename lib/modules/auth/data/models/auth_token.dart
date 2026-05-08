import 'package:objectbox/objectbox.dart';

@Entity()
class AuthToken {
  @Id()
  int storageID = 0;
  final String token;
  final String? refreshToken;
  @Property(type: PropertyType.date)
  final DateTime createAt;
  final int expiresIn;

  AuthToken({
    required this.token,
    this.refreshToken,
    required this.createAt,
    required this.expiresIn,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['accessToken'] ?? json['access_token'] ?? '',
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      createAt: DateTime.now(),
      // Parse the expires_in value (default to 0 if missing as a fallback)
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  AuthToken copyWith({String? token, String? refreshToken, int? expiresIn}) {
    return AuthToken(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      createAt: this
          .createAt, // Usually, you want to keep the original creation time on copy
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  // Calculates the exact moment of expiration by adding 1800 seconds to createAt
  bool get isExpired {
    final expirationDate = createAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expirationDate);
  }

  // Assuming refresh tokens still have a hardcoded 29-day lifespan.
  // If your API returns a "refresh_expires_in", you should handle it similarly to expiresIn!
  bool get canRefresh => DateTime.now().difference(createAt).inDays < 29;
}

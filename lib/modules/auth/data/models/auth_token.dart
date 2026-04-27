import 'package:objectbox/objectbox.dart';

@Entity()
class AuthToken {
  @Id()
  int storageID = 0;
  final String token;
  final String? refreshToken;

  AuthToken({
    required this.token,
    this.refreshToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['accessToken'],
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  AuthToken copyWith({
    String? token,
    String? refreshToken,
  }) {
    return AuthToken(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class LiveTokenResponse {
  final String token;
  final String url;
  final String roomName;
  final String participantName;
  final DateTime expiresAt;

  LiveTokenResponse({
    required this.token,
    required this.url,
    required this.roomName,
    required this.participantName,
    required this.expiresAt,
  });

  factory LiveTokenResponse.fromJson(Map<String, dynamic> json) {
    return LiveTokenResponse(
      token: json['token'].toString(),
      url: json['url'].toString(),
      roomName: json['room_name'].toString(),
      participantName: json['participant_name'].toString(),
      expiresAt: DateTime.parse(json['expires_at'].toString()),
    );
  }
}
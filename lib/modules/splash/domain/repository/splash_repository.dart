
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/splash/data/data_source/splash_remote_data_source.dart';

import '../../../../data/models/user.dart';

/// Response model for avatar upload
class AvatarUploadResponse {
  final String avatar;
  final String key;
  final String message;

  AvatarUploadResponse(
      {required this.avatar, required this.key, required this.message});

  factory AvatarUploadResponse.fromJson(Map<String, dynamic> json) {
    return AvatarUploadResponse(
      avatar: json['data']['avatar'] ?? '',
      key: json['data']['key'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

abstract class SplachRepo {
  const SplachRepo(this.remoteDataSource, this.localDataSource);

  final SpalshRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  void init();
  Future<Option<Failure, User>> getMe();

}

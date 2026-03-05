import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/presentation/components/loading_indicator.dart';

class ProfileAvatar extends StatefulWidget {
  final String? imageurl;
  final bool? isActive;
  final double size;
  final bool isUrl;
  final bool isDriver;
  const ProfileAvatar({
    super.key,
    this.imageurl,
    this.isActive,
    this.size = 60,
    this.isUrl = true,
    this.isDriver = false,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late final localdata = (di.get<UserLocalDataSource>());

  bool get isUrl => widget.imageurl?.startsWith('http') ?? false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? imageUrl = widget.imageurl;

    // Fallback chain: passed imageurl → user.avatar → providerData.personalImage
    if (imageUrl == null) {
      // First try user.avatar from the backend
      final user = localdata.returnUser();
      if (user?.avatar != null && user!.avatar!.isNotEmpty) {
        imageUrl = user.avatar;
      }
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: (widget.isUrl && imageUrl != null)
                ? CachedNetworkImage(
                    httpHeaders: {
                      if (localdata.isAuthTokenExists())
                        'Authorization':
                            'Bearer ${localdata.returnAuthToken()!.token}',
                    },
                    imageUrl: isUrl
                        ? imageUrl
                        : '${EndPoints.baseURL}${EndPoints.uploads}?id=$imageUrl',
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => const LoadingIndicator(),
                    errorWidget: (context, _, __) => Image.asset(
                      widget.isDriver ? Assets.doctor : Assets.grandFather,
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    widget.isDriver ? Assets.doctor : Assets.logo,
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        if (widget.isActive != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: widget.isActive! ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

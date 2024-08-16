import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProfileIcon extends StatefulWidget {
  const UserProfileIcon({super.key});

  @override
  State<UserProfileIcon> createState() => _UserProfileIconState();
}

class _UserProfileIconState extends State<UserProfileIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.tealColor,
        ),
        child: ValueListenableBuilder<Object>(
          valueListenable:
              Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
                  .listenable(),
          builder: (context, _, __) {
            final profile = getIt<HiveRepository>().retrieveUser();
            if (profile != null) {
              return ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profile.avatar,
                  height: 100,
                  width: 100,
                ),
              );
            }
            return const Icon(
              Icons.person,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/app_bar/logout_dialog.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class UserProfileIcon extends StatefulWidget {
  const UserProfileIcon({super.key});

  @override
  State<UserProfileIcon> createState() => _UserProfileIconState();
}

class _UserProfileIconState extends State<UserProfileIcon> {
  @override
  Widget build(BuildContext context) {
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    final l10n = context.l10n;
    return InkWell(
      onTap: () {
        WoltModalSheet.show<dynamic>(
          context: context,
          barrierDismissible: true,
          pageListBuilder: (context) => [
            WoltModalSheetPage(
              backgroundColor: colorScheme.secondaryContainer,
              trailingNavBarWidget: GestureDetector(
                onTap: () {
                  GoRouter.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AutoSizeText(
                    l10n.cancel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              child: const LogOutDialog(),
            ),
          ],
          modalTypeBuilder: (_) => WoltModalType.dialog(),
        );
      },
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
                  placeholder: (_, __) => const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
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

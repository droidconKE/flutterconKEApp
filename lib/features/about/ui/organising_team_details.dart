import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/social_handle.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class OranisingTeamMemberDetailsPage extends StatelessWidget {
  const OranisingTeamMemberDetailsPage({
    required this.organiser,
    super.key,
  });

  final LocalIndividualOrganiser organiser;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            surfaceTintColor: colorScheme.surface,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                AppAssets.speakerBackground,
                fit: BoxFit.fitWidth,
              ),
            ),
            expandedHeight: 100,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => GoRouter.of(context).pop(),
                        color: Colors.white,
                      ),
                      AutoSizeText(
                        l10n.organisingTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: organiser.photo,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 60),
              AutoSizeText(
                organiser.designation,
                style: const TextStyle(
                  color: ThemeColors.orangeColor,
                ),
              ),
              AutoSizeText(
                organiser.name,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              AutoSizeText(
                organiser.tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  l10n.bio,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  organiser.bio,
                  style: TextStyle(
                    fontSize: 16,
                    color: isLightMode
                        ? colorScheme.onSurface
                        : ThemeColors.lightGrayBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.withOpacity(.5)),
              const SizedBox(height: 32),
              SocialHandleBody(
                name: organiser.name,
                linkedinUrl: organiser.link,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

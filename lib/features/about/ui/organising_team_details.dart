import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:go_router/go_router.dart';

class OranisingTeamMemberDetailsPage extends StatelessWidget {
  const OranisingTeamMemberDetailsPage({
    required this.organiser,
    super.key,
  });

  final LocalIndividualOrganiser organiser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            surfaceTintColor: Colors.white,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                AppAssets.speakerBackground,
                fit: BoxFit.fitHeight,
              ),
            ),
            expandedHeight: 100,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
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
                      const Text(
                        'Team',
                        style: TextStyle(
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
              Text(
                organiser.designation,
                style: const TextStyle(
                  color: ThemeColors.orangeColor,
                ),
              ),
              Text(
                organiser.name,
                style: const TextStyle(
                  color: ThemeColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                organiser.tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bio',
                  style: TextStyle(
                    color: ThemeColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  organiser.bio,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey.withOpacity(.5)),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Text(
                    'Twitter Handle',
                    style: TextStyle(
                      color: ThemeColors.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Misc.launchURL(
                      Uri(
                        scheme: 'https',
                        host: 'twitter.com',
                        path: organiser.twitterHandle,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: ThemeColors.blueColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Add a Twitter Icon here
                        Text(organiser.name),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

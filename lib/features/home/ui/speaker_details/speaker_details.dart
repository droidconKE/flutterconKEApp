import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:go_router/go_router.dart';

class SpeakerDetailsPage extends StatelessWidget {
  const SpeakerDetailsPage({
    required this.speaker,
    super.key,
  });

  final Speaker speaker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.white,
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => GoRouter.of(context).pop(),
              color: Colors.white,
            ),
            title: const Text(
              'Speaker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    AppAssets.speakerBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 110,
                    width: 110,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: speaker.avatar,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            expandedHeight: 160,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.android_outlined,
                            color: ThemeColors.orangeColor,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Speaker:',
                          style: TextStyle(
                            color: ThemeColors.orangeColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      speaker.name,
                      style: const TextStyle(
                        color: ThemeColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      speaker.tagline ?? '',
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
                        speaker.biography,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Divider(color: Colors.grey.withOpacity(.5)),
                    const SizedBox(height: 32),
                    if (speaker.twitter != null)
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
                          OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                // Add a Twitter Icon here
                                Text(speaker.name),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

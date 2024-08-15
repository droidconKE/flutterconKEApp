import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/organising_team.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/about/cubit/fetch_organising_team_cubit.dart';

class OrganisingTeamCard extends StatefulWidget {
  const OrganisingTeamCard({super.key});

  @override
  State<OrganisingTeamCard> createState() => _OrganisingTeamCardState();
}

class _OrganisingTeamCardState extends State<OrganisingTeamCard> {
  @override
  void initState() {
    context.read<FetchOrganisingTeamCubit>().fetchOrganisers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocBuilder<FetchOrganisingTeamCubit, FetchOrganisingTeamState>(
      builder: (context, state) => state.maybeWhen(
        loaded: (organisers) => Wrap(
          spacing: 10,
          children: [
            for (final OrganisingTeam organiser in organisers)
              SizedBox(
                width: size.width / 4,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeColors.tealColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: resolveImage(organiser),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      organiser.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.blueColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organiser.tagline,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
          ],
        ),
        error: (message) => Text(
          message,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ThemeColors.blueColor,
                fontSize: 18,
              ),
        ),
        orElse: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget resolveImage(OrganisingTeam organiser) {
    return organiser.photo.contains('.jpg')
        ? CachedNetworkImage(imageUrl: organiser.photo)
        : SvgPicture.network(organiser.photo);
  }
}

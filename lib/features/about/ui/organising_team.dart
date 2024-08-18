import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/about/cubit/fetch_individual_organisers_cubit.dart';
import 'package:go_router/go_router.dart';

class OrganisingTeamView extends StatefulWidget {
  const OrganisingTeamView({super.key});

  @override
  State<OrganisingTeamView> createState() => _OrganisingTeamViewState();
}

class _OrganisingTeamViewState extends State<OrganisingTeamView> {
  @override
  void initState() {
    context.read<FetchIndividualOrganisersCubit>().fetchIndividualOrganisers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final (_, colorScheme) = Misc.getTheme(context);
    return BlocBuilder<FetchIndividualOrganisersCubit,
        FetchIndividualOrganisersState>(
      builder: (context, state) => state.maybeWhen(
        loaded: (individualOrganisers) => SliverGrid.builder(
          itemCount: individualOrganisers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => GoRouter.of(context).push(
              FlutterConRouter.organiserDetailsRoute,
              extra: individualOrganisers[index],
            ),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width / 4.5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeColors.tealColor,
                      width: 2,
                    ),
                    borderRadius: Corners.s12Border,
                  ),
                  child: ClipRRect(
                    borderRadius: Corners.s10Border,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: individualOrganisers[index].photo,
                    ),
                  ),
                ),
                Text(
                  individualOrganisers[index].name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  individualOrganisers[index].designation,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        orElse: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

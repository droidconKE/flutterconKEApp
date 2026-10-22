import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/personnel_widget.dart';
import 'package:fluttercon/common/widgets/status_view.dart';
import 'package:fluttercon/features/about/cubit/fetch_individual_organisers_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class OrganisingTeamView extends StatefulWidget {
  const OrganisingTeamView({super.key});

  @override
  State<OrganisingTeamView> createState() => _OrganisingTeamViewState();
}

class _OrganisingTeamViewState extends State<OrganisingTeamView> {
  @override
  void initState() {
    super.initState();

    context.read<FetchIndividualOrganisersCubit>().fetchIndividualOrganisers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;
    return BlocBuilder<
      FetchIndividualOrganisersCubit,
      FetchIndividualOrganisersState
    >(
      builder: (context, state) => state.maybeWhen(
        error: (message) => SliverToBoxAdapter(
          child: StatusView(
            icon: Icons.wifi_off_rounded,
            title: l10n.organisersErrorTitle,
            message: message,
            onRetry: () => context
                .read<FetchIndividualOrganisersCubit>()
                .fetchIndividualOrganisers(forceRefresh: true),
          ),
        ),
        loaded: (individualOrganisers) {
          const crossAxisCount = 3;
          const crossAxisSpacing = 8.0;
          const horizontalPadding = 16.0;
          final cellWidth =
              (size.width -
                  horizontalPadding * 2 -
                  crossAxisSpacing * (crossAxisCount - 1)) /
              crossAxisCount;
          // Square avatar (cellWidth tall) + the 8px gap below it + the name
          // line + up to two wrapped lines of tagline underneath it.
          final mainAxisExtent = cellWidth + 64;

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverGrid.builder(
              itemCount: individualOrganisers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: 8,
                mainAxisExtent: mainAxisExtent,
              ),
              itemBuilder: (context, index) => PersonnelWidget(
                imageUrl: individualOrganisers[index].logo,
                name: individualOrganisers[index].name,
                designation: individualOrganisers[index].tagline,
                maxWidth: cellWidth,
                onTap: () => GoRouter.of(context).push(
                  FlutterConRouter.organiserDetailsRoute,
                  extra: individualOrganisers[index],
                ),
              ),
            ),
          );
        },
        orElse: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

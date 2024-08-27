import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/personnel_widget.dart';
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
    super.initState();

    context.read<FetchIndividualOrganisersCubit>().fetchIndividualOrganisers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<FetchIndividualOrganisersCubit,
        FetchIndividualOrganisersState>(
      builder: (context, state) => state.maybeWhen(
        loaded: (individualOrganisers) => SliverGrid.builder(
          itemCount: individualOrganisers.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: size.width > 600 ? 200 : 140,
          ),
          itemBuilder: (context, index) => PersonnelWidget(
            imageUrl: individualOrganisers[index].photo,
            name: individualOrganisers[index].name,
            designation: individualOrganisers[index].designation,
            onTap: () => GoRouter.of(context).push(
              FlutterConRouter.organiserDetailsRoute,
              extra: individualOrganisers[index],
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

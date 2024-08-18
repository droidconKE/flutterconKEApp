import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_speakers_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class SpeakerCard extends StatefulWidget {
  const SpeakerCard({super.key});

  @override
  State<SpeakerCard> createState() => _SpeakerCardState();
}

class _SpeakerCardState extends State<SpeakerCard> {
  @override
  void initState() {
    context.read<FetchSpeakersCubit>().fetchSpeakers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.speakers,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: ThemeColors.blueDroidconColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton.icon(
              label:  Text(
                l10n.viewAll,
                style: TextStyle(color: ThemeColors.blueColor),
              ),
              iconAlignment: IconAlignment.end,
              icon: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.blueColor.withOpacity(.11),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
                  builder: (context, state) => state.maybeWhen(
                    loaded: (_, extras) => Text('+ $extras'),
                    orElse: () => const SizedBox(
                      height: 16,
                      width: 16,
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              ),
              onPressed: () => context.push(
                '${FlutterConRouter.dashboardRoute}/${FlutterConRouter.speakerListRoute}',
              ),
            ),
          ],
        ),
        BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
          builder: (context, state) => state.maybeWhen(
            loaded: (speakers, _) {
              return SizedBox(
                height: 150,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                  itemCount: speakers.take(5).length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => GoRouter.of(context).push(
                      FlutterConRouter.speakerDetailsRoute,
                      extra: speakers[index],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 4.5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeColors.tealColor,
                                width: 2,
                              ),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: speakers[index].avatar,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 5,
                          child: Text(
                            speakers[index].name,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        ),
      ],
    );
  }
}

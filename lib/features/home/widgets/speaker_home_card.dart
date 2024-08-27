import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/personnel_widget.dart';
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
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              l10n.speakers,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: isLightMode
                        ? ThemeColors.blueDroidconColor
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton.icon(
              label: AutoSizeText(
                l10n.viewAll,
                style: TextStyle(
                  color:
                      isLightMode ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: Container(
                decoration: BoxDecoration(
                  color: (isLightMode
                          ? ThemeColors.blueColor
                          : ThemeColors.lightGrayColor)
                      .withOpacity(.11),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
                  builder: (context, state) => state.maybeWhen(
                    loaded: (_, extras) => AutoSizeText(
                      '+ $extras',
                      style: TextStyle(
                        color: isLightMode
                            ? colorScheme.primary
                            : ThemeColors.lightGrayColor,
                      ),
                    ),
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxWidth > 500 ? 250 : 150,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 4),
                      itemCount: speakers.take(5).length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PersonnelWidget(
                        imageUrl: speakers[index].avatar,
                        name: speakers[index].name,
                        onTap: () => GoRouter.of(context).push(
                          FlutterConRouter.speakerDetailsRoute,
                          extra: speakers[index],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (message) => AutoSizeText(
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

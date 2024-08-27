import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/features/home/cubit/fetch_speakers_cubit.dart';
import 'package:fluttercon/features/home/widgets/speaker_grid_tile.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class SpeakerListScreen extends StatelessWidget {
  const SpeakerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
          color: colorScheme.onSurface,
        ),
        title: AutoSizeText(
          l10n.speakers,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
        builder: (context, state) => state.maybeWhen(
          loaded: (speakers, _) => Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: speakers.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 316,
                maxCrossAxisExtent: 240,
              ),
              itemBuilder: (context, index) =>
                  SpeakerGridTile(speaker: speakers[index]),
            ),
          ),
          error: (message) => AutoSizeText(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  fontSize: 18,
                ),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

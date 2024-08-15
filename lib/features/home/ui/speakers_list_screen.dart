import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_speakers_cubit.dart';
import 'package:fluttercon/features/home/widgets/speaker_grid_tile.dart';
import 'package:go_router/go_router.dart';

class SpeakerListScreen extends StatelessWidget {
  const SpeakerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
          color: Colors.black,
        ),
        title: const Text(
          'Speakers',
          style: TextStyle(color: Colors.black),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
        builder: (context, state) => state.maybeWhen(
          loaded: (speakers, _) => Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: speakers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 9 / 14,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) =>
                  SpeakerGridTile(speaker: speakers[index]),
            ),
          ),
          error: (message) => Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.blueColor,
                  fontSize: 18,
                ),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

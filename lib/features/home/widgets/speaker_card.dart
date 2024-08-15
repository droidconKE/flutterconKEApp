import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_speakers_cubit.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Speakers',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: ThemeColors.blueDroidconColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push(FlutterConRouter.speakerListRoute),
              child: Row(
                children: [
                  const Text('View All'),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: ThemeColors.chipBackground,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text('+45'),
                  ),
                ],
              ),
            ),
          ],
        ),
        BlocBuilder<FetchSpeakersCubit, FetchSpeakersState>(
          builder: (context, state) => state.maybeWhen(
            loaded: (speakers) {
              return SizedBox(
                height: 150,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 4,
                  ),
                  itemCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Column(
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

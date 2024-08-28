import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SessionsCard extends StatefulWidget {
  const SessionsCard({
    super.key,
    this.switchTab,
  });

  final void Function()? switchTab;
  @override
  State<SessionsCard> createState() => _SessionsCardState();
}

class _SessionsCardState extends State<SessionsCard> {
  @override
  void initState() {
    super.initState();

    context.read<FetchSessionsCubit>().fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Column(
      children: [
        Row(
          children: [
            AutoSizeText(
              l10n.sessions,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: isLightMode
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: widget.switchTab,
              child: Row(
                children: [
                  AutoSizeText(
                    l10n.viewAll,
                    style: TextStyle(
                      color: isLightMode
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: (isLightMode
                              ? ThemeColors.blueColor
                              : ThemeColors.lightGrayColor)
                          .withOpacity(.11),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: BlocBuilder<FetchSessionsCubit, FetchSessionsState>(
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: size.height * .33,
          child: BlocBuilder<FetchSessionsCubit, FetchSessionsState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (sessions, _) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sessions.take(10).length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return GestureDetector(
                    onTap: () => GoRouter.of(context).push(
                      FlutterConRouter.sessionDetailsRoute,
                      extra: sessions[index],
                    ),
                    child: Container(
                      width: size.width * .7,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorScheme.secondaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: session.sessionImage,
                              height: size.width > 600
                                  ? size.height * .225
                                  : size.height * .2,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (_, __, ___) => const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              session.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AutoSizeText(
                              l10n.sessionTimeAndVenue(
                                DateFormat.Hm().format(
                                  session.startDateTime,
                                ),
                                session.rooms
                                    .map((room) => room.title)
                                    .join(', '),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              orElse: () => const Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

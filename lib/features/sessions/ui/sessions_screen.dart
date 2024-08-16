import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';

import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  int _viewIndex = 0;
  int _currentTab = 0;
  int _availableTabs = 3;

  bool _isBookmarked = false;

  @override
  void initState() {
    context.read<FetchGroupedSessionsCubit>().fetchGroupedSessions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: 2,
        selectedScheduleIndex: _viewIndex,
        onCompactTapped: () => setState(() {
          _viewIndex = 0;
        }),
        onScheduleTapped: () => setState(() {
          _viewIndex = 1;
        }),
      ),
      body: DefaultTabController(
        length: _availableTabs,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    BlocConsumer<FetchGroupedSessionsCubit,
                        FetchGroupedSessionsState>(
                      listener: (context, state) {
                        state.mapOrNull(
                          loaded: (loaded) {
                            setState(() {
                              _availableTabs = loaded.groupedSessions.length;
                            });
                          },
                        );
                      },
                      builder: (context, state) => state.maybeWhen(
                        orElse: () => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: CircularProgressIndicator(),
                        ),
                        loaded: (groupedSessions) => TabBar(
                          onTap: (value) => setState(() {
                            Logger().d(value);
                            _currentTab = value;
                          }),
                          dividerColor: Colors.white,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: Colors.white,
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          tabs: [
                            ...groupedSessions.keys.map(
                              (date) => DayTabView(
                                date: DateFormat.d().format(
                                  DateFormat('MM/dd/yyyy').parse(date),
                                ),
                                day: groupedSessions.keys
                                        .toList()
                                        .indexOf(date) +
                                    1,
                                isActive: _currentTab ==
                                    groupedSessions.keys.toList().indexOf(date),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Switch(
                            value: _isBookmarked,
                            onChanged: (newValue) {
                              setState(() {
                                _isBookmarked = newValue;
                              });

                              if (_isBookmarked) {
                                context
                                    .read<FetchGroupedSessionsCubit>()
                                    .fetchGroupedSessions(
                                      bookmarkStatus: BookmarkStatus.bookmarked,
                                    );
                              }

                              if (!_isBookmarked) {
                                context
                                    .read<FetchGroupedSessionsCubit>()
                                    .fetchGroupedSessions();
                              }
                            },
                            trackOutlineWidth: WidgetStateProperty.all(1),
                            trackColor: WidgetStateProperty.all(Colors.black),
                            activeTrackColor: ThemeColors.orangeColor,
                            activeColor: ThemeColors.orangeColor,
                            thumbColor: WidgetStateProperty.all(Colors.white),
                            thumbIcon: WidgetStateProperty.all(
                              const Icon(Icons.star_border_rounded),
                            ),
                          ),
                          const Text(
                            'My Sessions',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.grey),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _isBookmarked ? 'My Sessions' : 'All Sessions',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.blueColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
            body: BlocBuilder<FetchGroupedSessionsCubit,
                FetchGroupedSessionsState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const Center(child: CircularProgressIndicator()),
                loaded: (groupedSessions) => TabBarView(
                  children: groupedSessions.values
                      .map(
                        (dailySessions) => DaySessionsView(
                          sessions: dailySessions,
                          isScheduleView: _viewIndex == 1,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayTabView extends StatelessWidget {
  const DayTabView({
    required this.day,
    required this.date,
    required this.isActive,
    super.key,
  });

  final int day;
  final String date;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? ThemeColors.orangeDroidconColor
              : ThemeColors.blueGreenDroidconColor.withOpacity(.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Day $day',
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DaySessionsView extends StatelessWidget {
  const DaySessionsView({
    required this.sessions,
    super.key,
    required this.isScheduleView,
  });

  final List<Session> sessions;
  final bool isScheduleView;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sessions.length,
      separatorBuilder: (context, index) {
        final randomizeColor = Random().nextBool();

        return Padding(
          padding: const EdgeInsets.only(left: 32) +
              const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            height: 25,
            child: TimelineTile(
              afterLineStyle: LineStyle(
                thickness: 2,
                color: randomizeColor
                    ? ThemeColors.orangeColor
                    : ThemeColors.blueGreenDroidconColor,
              ),
              beforeLineStyle: LineStyle(
                thickness: 2,
                color: randomizeColor
                    ? ThemeColors.orangeColor
                    : ThemeColors.blueGreenDroidconColor,
              ),
              indicatorStyle: IndicatorStyle(
                width: 8,
                color: randomizeColor
                    ? ThemeColors.orangeColor
                    : ThemeColors.blueGreenDroidconColor,
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => GoRouter.of(context).push(
          FlutterConRouter.sessionDetailsRoute,
          extra: sessions[index],
        ),
        child: CompactViewCard(
          session: sessions[index],
          listIndex: index,
        ),
      ),
    );
  }
}

class CompactViewCard extends StatelessWidget {
  const CompactViewCard({
    super.key,
    required this.session,
    required this.listIndex,
  });

  final Session session;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Column(
          children: [
            Text(
              DateFormat.Hm().format(
                DateTime.parse('2022-01-01 ${session.startTime}'),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              DateTime.parse('2022-01-01 ${session.startTime}').hour > 11
                  ? 'PM'
                  : 'AM',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        title: Text(
          session.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              session.description,
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
            ),
            if (session.rooms.isNotEmpty) const SizedBox(height: 8),
            if (session.rooms.isNotEmpty)
              Text(
                l10n.sessionFullTimeAndVenue(
                  DateFormat.Hm().format(
                    session.startDateTime,
                  ),
                  DateFormat.Hm().format(
                    session.endDateTime,
                  ),
                  session.rooms
                      .map((room) => room.title)
                      .join(', ')
                      .toUpperCase(),
                ),
              ),
            if (session.speakers.isNotEmpty) const SizedBox(height: 8),
            if (session.speakers.isNotEmpty)
              Row(
                children: [
                  const Flexible(
                    child: Icon(
                      Icons.android_outlined,
                      color: ThemeColors.blueColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 8,
                    child: Text(
                      session.speakers
                          .map((speaker) => speaker.name)
                          .join(', '),
                      style: const TextStyle(
                        color: ThemeColors.blueColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: BlocConsumer<BookmarkSessionCubit, BookmarkSessionState>(
          listener: (context, state) {
            state.mapOrNull(
              loaded: (loaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loaded.message),
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: (loadingIndex) => loadingIndex == listIndex
                  ? const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      onPressed: () => context
                          .read<BookmarkSessionCubit>()
                          .bookmarkSession(
                            sessionId: session.id,
                            index: listIndex,
                          )
                          .then((_) {
                        if (context.mounted) {
                          context
                              .read<FetchGroupedSessionsCubit>()
                              .fetchGroupedSessions();
                        }
                      }),
                      icon: Icon(
                        session.isBookmarked
                            ? Icons.star_rate_rounded
                            : Icons.star_border_outlined,
                        color: session.isBookmarked
                            ? ThemeColors.orangeColor
                            : ThemeColors.blueColor,
                        size: 32,
                      ),
                    ),
              orElse: () => IconButton(
                onPressed: () => context
                    .read<BookmarkSessionCubit>()
                    .bookmarkSession(
                      sessionId: session.id,
                      index: listIndex,
                    )
                    .then((_) {
                  if (context.mounted) {
                    context
                        .read<FetchGroupedSessionsCubit>()
                        .fetchGroupedSessions();
                  }
                }),
                icon: Icon(
                  session.isBookmarked
                      ? Icons.star_rate_rounded
                      : Icons.star_border_outlined,
                  color: session.isBookmarked
                      ? ThemeColors.orangeColor
                      : ThemeColors.blueColor,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

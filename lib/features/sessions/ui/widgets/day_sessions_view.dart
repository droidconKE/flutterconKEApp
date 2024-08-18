import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/sessions/ui/widgets/compact_view_card.dart';
import 'package:fluttercon/features/sessions/ui/widgets/schedule_view_card.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DaySessionsView extends StatelessWidget {
  const DaySessionsView({
    required this.sessions,
    required this.isCompactView,
    super.key,
  });

  final List<LocalSession> sessions;
  final bool isCompactView;

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
        child: isCompactView
            ? CompactViewCard(
                session: sessions[index],
                listIndex: index,
              )
            : ScheduleViewCard(
                session: sessions[index],
                listIndex: index,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/session_level.dart';
import 'package:fluttercon/common/data/enums/session_type.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';

class SessionFilter extends StatefulWidget {
  const SessionFilter({super.key});

  @override
  State<SessionFilter> createState() => _SessionFilterState();
}

class _SessionFilterState extends State<SessionFilter> {
  SessionLevel _level = SessionLevel.beginner;
  SessionType _type = SessionType.session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16) +
          const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.level,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SessionLevel>(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              segments: [
                ButtonSegment<SessionLevel>(
                  icon: const SizedBox.shrink(),
                  label: Text(
                    l10n.beginner,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionLevel.beginner,
                ),
                ButtonSegment<SessionLevel>(
                  icon: const SizedBox.shrink(),
                  label: Text(
                    l10n.intermediate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionLevel.intermediate,
                ),
                ButtonSegment<SessionLevel>(
                  icon: const SizedBox.shrink(),
                  label: Text(
                    l10n.expert,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionLevel.advanced,
                ),
              ],
              selected: <SessionLevel>{_level},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _level = newSelection.first;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.sessionType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SessionType>(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              segments: [
                ButtonSegment<SessionType>(
                  label: Text(
                    l10n.session,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionType.session,
                ),
                ButtonSegment<SessionType>(
                  label: Text(
                    l10n.keynote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionType.keynote,
                ),
                ButtonSegment<SessionType>(
                  label: Text(
                    l10n.codeLab,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionType.codelab,
                ),
              ],
              selected: <SessionType>{_type},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _type = newSelection.first;
                });
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SessionType>(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              segments: [
                ButtonSegment<SessionType>(
                  label: Text(
                    l10n.lightningTalk,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionType.lightningTalk,
                ),
                ButtonSegment<SessionType>(
                  label: Text(
                    l10n.workshop,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  value: SessionType.workshop,
                ),
              ],
              selected: <SessionType>{_type},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _type = newSelection.first;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context
                  .read<FetchGroupedSessionsCubit>()
                  .fetchGroupedSessions(
                    sessionLevel: _level.name,
                    sessionType: _type.name,
                  )
                  .then((_) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.filter.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context
                  .read<FetchGroupedSessionsCubit>()
                  .fetchGroupedSessions()
                  .then((_) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.reset.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

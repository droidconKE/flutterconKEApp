import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/button_styles.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/home/widgets/speaker_duotone_avatar.dart';
import 'package:fluttercon/features/sessions/ui/widgets/compact_view_card.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class SpeakerDetailsPage extends StatelessWidget {
  const SpeakerDetailsPage({required this.speaker, super.key});

  final LocalSpeaker speaker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
          color: colorScheme.onSurface,
        ),
        surfaceTintColor: colorScheme.surface,
        title: AutoSizeText(
          l10n.speaker,
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            _SpeakerCard(speaker: speaker),
            const SizedBox(height: 24),
            _SpeakerSessionsButton(speakerName: speaker.name),
          ],
        ),
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard({required this.speaker});

  final LocalSpeaker speaker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tagline = speaker.tagline?.trim() ?? '';
    final biography = speaker.biography.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Tailwind `bg-gradient-to-b from-accent to-primary`.
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.flutterconMagenta, ThemeColors.flutterconBlue],
        ),
        borderRadius: Corners.s32Border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // `rounded-2xl border-4 border-accent`, `aspect-[3/4]`, `w-40`.
          Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: Corners.s16Border,
              border: Border.all(
                color: ThemeColors.flutterconMagenta,
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: SpeakerDuotoneAvatar(imageUrl: speaker.avatar),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '( ${l10n.speaker.toUpperCase()} )',
            style: const TextStyle(
              color: ThemeColors.flutterconBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            speaker.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          if (tagline.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              tagline,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
          const SizedBox(height: 12),
          _SocialHandle(speaker: speaker),
          if (biography.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              l10n.bio,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              biography,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Twitter link (shown as `@handle`) falling back to LinkedIn (shown as the
/// speaker's name). With neither, nothing renders — never a link without a
/// destination, as on the web.
class _SocialHandle extends StatelessWidget {
  const _SocialHandle({required this.speaker});

  final LocalSpeaker speaker;

  static String? _nonEmpty(String? s) =>
      (s == null || s.trim().isEmpty) ? null : s.trim();

  /// Mirrors the web's `getTwitterUsername`: the last non-empty path segment
  /// of a twitter.com/x.com URL, or the value itself if it's a bare handle.
  static String? _twitterHandle(String? twitter) {
    final value = _nonEmpty(twitter);
    if (value == null) return null;
    final uri = Uri.tryParse(value);
    final segments =
        uri?.pathSegments.where((s) => s.isNotEmpty).toList() ?? const [];
    final raw = (uri != null && uri.hasScheme)
        ? (segments.isEmpty ? null : segments.last)
        : value;
    final handle = raw?.replaceFirst('@', '');
    return (handle == null || handle.isEmpty) ? null : handle;
  }

  @override
  Widget build(BuildContext context) {
    final twitter = _nonEmpty(speaker.twitter);
    final href = twitter ?? _nonEmpty(speaker.linkedin);
    final handle = _twitterHandle(twitter);
    // No destination: render nothing rather than repeating the name just
    // above it as dead text.
    if (href == null) return const SizedBox.shrink();

    final uri = href.startsWith('http')
        ? Uri.tryParse(href)
        : (twitter != null && handle != null)
        ? Uri.tryParse('https://x.com/$handle')
        : null;

    // A white pill, not bare blue text: the web's `text-primary` handle sits
    // mid-gradient where blue-on-blue/purple is close to invisible.
    return Material(
      color: Colors.white,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: uri == null ? null : () => Misc.launchURL(uri),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (twitter != null)
                SvgPicture.asset(
                  AppAssets.iconTwitter,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                )
              else
                const Icon(Icons.open_in_new, size: 16, color: Colors.black),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  handle != null ? '@$handle' : speaker.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "View session" (one session — opens it directly) or "View sessions (n)"
/// (several — lists them in a bottom sheet). Reads from the Isar session
/// cache only, so it's hidden until sessions have been fetched at least once.
class _SpeakerSessionsButton extends StatefulWidget {
  const _SpeakerSessionsButton({required this.speakerName});

  final String speakerName;

  @override
  State<_SpeakerSessionsButton> createState() => _SpeakerSessionsButtonState();
}

class _SpeakerSessionsButtonState extends State<_SpeakerSessionsButton> {
  late final Future<List<LocalSession>> _sessions = getIt<DBRepository>()
      .fetchSessionsBySpeaker(widget.speakerName);

  void _openSession(LocalSession session) => GoRouter.of(
    context,
  ).push(FlutterConRouter.sessionDetailsRoute, extra: session);

  Future<void> _showSessions(List<LocalSession> sessions) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  l10n.speakerSessionsTitle(widget.speakerName),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _openSession(sessions[index]);
                    },
                    child: CompactViewCard(
                      session: sessions[index],
                      listIndex: index,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<List<LocalSession>>(
      future: _sessions,
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? const <LocalSession>[];
        if (sessions.isEmpty) return const SizedBox.shrink();

        final single = sessions.length == 1;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: AppButtonStyles.primary(context),
            onPressed: () =>
                single ? _openSession(sessions.first) : _showSessions(sessions),
            icon: const Icon(Icons.event_note_outlined),
            label: Text(
              single ? l10n.viewSession : l10n.viewSessions(sessions.length),
            ),
          ),
        );
      },
    );
  }
}

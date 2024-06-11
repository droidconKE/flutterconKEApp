import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/repository/local_storage.dart';
import '../../di/injectable.dart';
import '../utils/constants/pref_constants.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.selectedPageIndex, required this.onPageChange});

  final int selectedPageIndex;
  final Function(int) onPageChange;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  /// This is used for the swipe drag gesture on the bottom nav bar
  var localStorage = getIt<LocalStorage>();
  bool bottomNavBarSwipeGestures = false, bottomNavBarDoubleTapGestures = false;

  double _dragStartX = 0.0;
  double _dragEndX = 0.0;

  // Handles drag on bottom nav bar to open the drawer
  void _handleDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  // Handles drag on bottom nav bar to open the drawer
  void _handleDragUpdate(DragUpdateDetails details) async {
    _dragEndX = details.globalPosition.dx;
  }

  // Handles drag on bottom nav bar to open the drawer
  void _handleDragEnd(DragEndDetails details, BuildContext context) async {
    if (widget.selectedPageIndex != 0) return;

    if (bottomNavBarSwipeGestures == false) return;

    double delta = _dragEndX - _dragStartX;

    // Set some threshold to also allow for swipe up to reveal FAB
    if (delta > 20) {
      if (context.mounted) Scaffold.of(context).openDrawer();
    } else if (delta < 0) {
      if (context.mounted) Scaffold.of(context).closeDrawer();
    }

    _dragStartX = 0.0;
  }

  // Handles double-tap to open the drawer
  void _handleDoubleTap(BuildContext context) async {
    if (widget.selectedPageIndex != 0) return;

    if (bottomNavBarDoubleTapGestures == false) return;

    bool isDrawerOpen =
        context.mounted ? Scaffold.of(context).isDrawerOpen : false;

    if (isDrawerOpen) {
      if (context.mounted) Scaffold.of(context).closeDrawer();
    } else {
      if (context.mounted) Scaffold.of(context).openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    bottomNavBarSwipeGestures =
        localStorage.getPrefBool(PrefConstants.bottomNavBarSwipeGesturesKey);
    bottomNavBarDoubleTapGestures = localStorage
        .getPrefBool(PrefConstants.bottomNavBarDoubleTapGesturesKey);

    return Theme(
      data: ThemeData.from(colorScheme: theme.colorScheme).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) =>
            _handleDragEnd(dragEndDetails, context),
        onDoubleTap: bottomNavBarDoubleTapGestures == true
            ? () => _handleDoubleTap(context)
            : null,
        child: NavigationBar(
          selectedIndex: widget.selectedPageIndex,
          backgroundColor: theme.colorScheme.surface,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          elevation: 1,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined),
              selectedIcon: const Icon(Icons.notifications_rounded),
              label: l10n.feed,
            ),
            NavigationDestination(
              icon: const Icon(Icons.timer_outlined),
              selectedIcon: const Icon(Icons.timer_rounded),
              label: l10n.sessions,
            ),
            NavigationDestination(
              icon: const Icon(Icons.info_outlined),
              selectedIcon: const Icon(Icons.info_rounded),
              label: l10n.about,
            ),
          ],
          onDestinationSelected: (index) {
            if (widget.selectedPageIndex != index) {
              widget.onPageChange(index);
            }
          },
        ),
      ),
    );
  }
}

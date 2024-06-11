import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../about/ui/about_screen.dart';
import '../../common/theme/bloc/theme_bloc.dart';
import '../../common/widgets/bottom_nav_bar.dart';
import '../../feed/ui/feed_screen.dart';
import '../../home/ui/home_screen.dart';
import '../../sessions/ui/sessions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController(initialPage: 0);
  int selectedPageIndex = 0;

  void _showExitWarning() {
    /*showSnackbar(
      AppLocalizations.of(context)!.tapToExit,
      duration: const Duration(milliseconds: 3500),
    );*/
  }

  FutureOr<bool> _handleBackButtonPress(bool stopDefaultButtonEvent) async {
    final bool topOfNavigationStack =
        ModalRoute.of(context)?.isCurrent ?? false;

    if (!topOfNavigationStack) return false;
    if (stopDefaultButtonEvent) return false;

    if (selectedPageIndex != 0) {
      setState(() {
        selectedPageIndex = 0;
        pageController.jumpToPage(selectedPageIndex);
      });
      return true;
    }

    // If any modal is open (i.e., community drawer) close it now
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return true;
    }

    /*if (appExitCounter == 0) {
      appExitCounter++;
      _showExitWarning();
      Timer(const Duration(milliseconds: 3500), () {
        appExitCounter = 0;
      });
      return true;
    } else {
      return false;
    }*/
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _bloc = BlocProvider.of<ThemeBloc>(context);
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedPageIndex: selectedPageIndex,
          onPageChange: (int index) {
            setState(() {
              selectedPageIndex = index;
              pageController.jumpToPage(index);
            });
          },
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) => setState(() => selectedPageIndex = index),
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            HomeScreen(),
            FeedScreen(),
            SessionsScreen(),
            AboutScreen(),
          ],
        ));
  }
}

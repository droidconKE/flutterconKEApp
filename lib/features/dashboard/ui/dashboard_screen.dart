import 'package:flutter/material.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/common/widgets/bottom_nav/bottom_nav_bar.dart';
import 'package:fluttercon/common/widgets/page_item.dart';
import 'package:fluttercon/features/about/ui/about_screen.dart';
import 'package:fluttercon/features/feed/ui/feed_screen.dart';
import 'package:fluttercon/features/home/ui/home_screen.dart';
import 'package:fluttercon/features/sessions/ui/sessions_screen.dart';

/// Default Screen to handle all the UIs after the Splash Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  int selectedPageIndex = 0;

  final List<PageItem> pages = [
    const PageItem(title: 'Home', icon: 'home', screen: HomeScreen()),
    const PageItem(title: 'Feed', icon: 'bell', screen: FeedScreen()),
    const PageItem(title: 'Sessions', icon: 'time', screen: SessionsScreen()),
    const PageItem(title: 'About', icon: 'flower', screen: AboutScreen()),
  ];

  @override
  void initState() {
    super.initState();
    selectedPageIndex = pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomAppBar(selectedIndex: selectedPageIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedPageIndex,
        onPageChange: (int index) {
          setState(() {
            selectedPageIndex = index;
            pageController.jumpToPage(index);
          });
        },
        pages: pages,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => selectedPageIndex = index),
        physics: const NeverScrollableScrollPhysics(),
        children: pages.map<Widget>((item) => item.screen).toList(),
      ),
    );
  }
}

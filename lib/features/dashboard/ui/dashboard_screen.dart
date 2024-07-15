import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon_2024/core/theme/theme_colors.dart';
import 'package:fluttercon_2024/common/utils/constants/app_assets.dart';

import '../../../common/widgets/page_item.dart';
import '../../about/ui/about_screen.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../feed/ui/feed_screen.dart';
import '../../ui/home_screen.dart';
import '../../sessions/ui/sessions_screen.dart';

/// Default Screen to handle all the UIs after the Splash Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController(initialPage: 0);
  int selectedPageIndex = 0;
  int selectedIndex = 0;

  final List<PageItem> pages = [
    const PageItem(title: 'Home', icon: 'home', screen: HomeScreen()),
    const PageItem(title: 'Feed', icon: 'bell', screen: FeedScreen()),
    const PageItem(title: 'Sessions', icon: 'time', screen: SessionsScreen()),
    const PageItem(title: 'About', icon: 'flower', screen: AboutScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppAssets.iconDroidcon,
          height: 25,
          width: 137,
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  color: ThemeColors.blueGreenDroidconColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: SvgPicture.asset(
                AppAssets.iconLocked,
                height: 25,
                width: 25,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedPageIndex,
        onPageChange: (int index) {
          setState(() {
            selectedPageIndex = index;
            //pageController.jumpToPage(index);
          });
        },
        pages: pages,
      ),
      body: pages[selectedIndex].screen,
      /*body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => selectedPageIndex = index),
        physics: const NeverScrollableScrollPhysics(),
        children: pageItems
            .map<Widget>(
              (item) => item['screen'] as Widget,
            )
            .toList(),
      ),*/
    );
  }
}

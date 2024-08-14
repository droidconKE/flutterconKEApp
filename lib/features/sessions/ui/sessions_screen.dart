import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

import 'package:fluttercon/l10n/l10n.dart';
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
  late TabController _tabController;
  int _currentTab = 0;

  void _changeTab() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_changeTab);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    TabBar(
                      controller: _tabController,
                      onTap: (value) => setState(() {
                        Logger().d(value);
                        _currentTab = value;
                      }),
                      dividerColor: Colors.white,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: Colors.white,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      tabs: [
                        DayTabView(
                          date: '16th',
                          day: '1',
                          isActive: _currentTab == 0,
                        ),
                        DayTabView(
                          date: '17th',
                          day: '2',
                          isActive: _currentTab == 1,
                        ),
                        DayTabView(
                          date: '18th',
                          day: '3',
                          isActive: _currentTab == 2,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Switch(
                            value: false,
                            onChanged: (_) {},
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
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'All Sessions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.blueColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: const [
                DaySessionsView(),
                DaySessionsView(),
                DaySessionsView(),
              ],
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

  final String day;
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
  const DaySessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
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
      itemBuilder: (context, index) => Card(
        elevation: 2,
        color: Colors.white,
        child: ListTile(
          leading: const Column(
            children: [
              Text(
                '8:00',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'AM',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          title: const Text(
            'Keynote',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registration & Breakfast',
                style: TextStyle(fontSize: 18),
                maxLines: 3,
              ),
              if (true)
                Text(
                  l10n.sessionFullTimeAndVenue(
                    DateFormat.Hm().format(
                      DateTime.parse('2022-11-18 19:30:00'),
                    ),
                    DateFormat.Hm().format(
                      DateTime.parse('2022-11-18 19:30:00'),
                    ),
                    'Room 2'.toUpperCase(),
                  ),
                ),
              if (true)
                const Row(
                  children: [
                    Icon(
                      Icons.android_outlined,
                      color: ThemeColors.blueColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Greg Fawson',
                      style: TextStyle(
                        color: ThemeColors.blueColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.star_border_outlined,
              color: ThemeColors.blueColor,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

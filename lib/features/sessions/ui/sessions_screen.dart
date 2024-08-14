import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

import 'package:fluttercon/l10n/l10n.dart';
import 'package:logger/logger.dart';

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
    final l10n = context.l10n;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
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
                      tabs: const [
                        DayTabView(date: '16th', day: '1'),
                        DayTabView(date: '17th', day: '2'),
                        DayTabView(date: '18th', day: '3'),
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
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      DaySessionsView(),
                      DaySessionsView(),
                      DaySessionsView(),
                    ],
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

class DayTabView extends StatelessWidget {
  const DayTabView({
    required this.day,
    required this.date,
    super.key,
  });

  final String day;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        children: [
          Text(date),
          Text('Day $day'),
        ],
      ),
    );
  }
}

class DaySessionsView extends StatelessWidget {
  const DaySessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

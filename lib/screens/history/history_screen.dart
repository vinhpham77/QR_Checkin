import 'package:flutter/material.dart';
import 'package:qr_checkin/screens/history/registration_tab.dart';
import 'package:qr_checkin/screens/history/tickets_tab.dart';

import '../../config/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.pink,
            scrolledUnderElevation: 0,
            pinned: true,
            title: const Text('Lịch sử'),
            titleSpacing: 0,
            toolbarHeight: 40,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Sự kiện đã đăng ký'),
                Tab(text: 'Vé đã mua'),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: const [
          RegistrationTab(),
          TicketsTab()
        ],
      ),
    );
  }
}

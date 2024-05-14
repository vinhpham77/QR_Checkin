import 'package:flutter/material.dart';
import 'package:qr_checkin/screens/history/tickets_tab.dart';

import '../../config/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _registrationController = ScrollController();
  bool isLastRegistrationPage = false;
  int registrationPage = 1;

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
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            controller: _registrationController,
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Sự kiện $index'),
                subtitle: const Text(
                    'Địa chỉ: 123 Điện Biên Phủ, Quận 1, TP.HCM'),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          ),
          const TicketsTab()
        ],
      ),
    );
  }
}

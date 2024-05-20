import 'package:flutter/material.dart';
import 'package:qr_checkin/screens/attendances/attendance_tab.dart';
import 'package:qr_checkin/screens/attendances/pending_tab.dart';
import 'package:qr_checkin/screens/attendances/registration_tab.dart';
import 'package:qr_checkin/screens/attendances/ticket_buyer_tab.dart';
import 'package:qr_checkin/screens/attendances/ticket_check_in_tab.dart';

import '../../config/theme.dart';

class AttendancesScreen extends StatefulWidget {
  final int eventId;
  final bool isTicketSeller;
  final bool approvalRequired;
  final int selectedTabIndex;

  const AttendancesScreen(
      {super.key,
      required this.eventId,
      required this.isTicketSeller,
      required this.approvalRequired,
      required this.selectedTabIndex});

  @override
  State<AttendancesScreen> createState() => _AttendancesScreenState();
}

class _AttendancesScreenState extends State<AttendancesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(widget.selectedTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.pink,
            scrolledUnderElevation: 0,
            pinned: true,
            title: const Text('Danh sách tham dự'),
            titleSpacing: 0,
            toolbarHeight: 40,
            bottom: TabBar(controller: _tabController, tabs: tabs),
          ),
        ];
      },
      body: TabBarView(controller: _tabController, children: tabViews),
    ));
  }

  List<Tab> get tabs {
    if (widget.isTicketSeller) {
      return const [
        Tab(text: 'Đã tham dự'),
        Tab(text: 'Đã mua vé'),
      ];
    }
    return [
      const Tab(text: 'Đã tham dự'),
      const Tab(text: 'Đã đăng ký'),
      if (widget.approvalRequired) const Tab(text: 'Chờ phê duyệt'),
    ];
  }

  List<Widget> get tabViews {
    if (widget.isTicketSeller) {
      return [
        TicketCheckInTab(eventId: widget.eventId),
        TicketBuyerTab(eventId: widget.eventId),
      ];
    }

    return [
      AttendanceTab(eventId: widget.eventId),
      RegistrationTab(eventId: widget.eventId),
      if (widget.approvalRequired) PendingTab(eventId: widget.eventId)
    ];
  }
}

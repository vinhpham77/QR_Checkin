import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/screens/history/ticket_detail_item.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/ticket/bloc/ticket_bloc.dart';
import '../../features/ticket/data/ticket_api_client.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';
import '../../features/ticket/dtos/ticket_detail_dto.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _ticketScrollController = ScrollController();
  final ticketBloc = TicketBloc(
      ticketRepository: TicketRepository(TicketApiClient(dio)),
      ticketTypeRepository: TicketTypeRepository(TicketTypeApiClient(dio)));
  final _ticketDetails = <TicketDetailDto>[];
  bool isLastTicketPage = false;
  bool isLastRegistrationPage = false;
  int ticketPage = 1;
  int registrationPage = 1;
  int size = 8;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ticketScrollController.addListener(_onScroll);
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
            controller: _ticketScrollController,
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Sự kiện $index'),
                subtitle: Text(
                    'Địa chỉ: 123 Điện Biên Phủ, Quận 1, TP.HCM'),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          ),
          BlocProvider(
            create: (context) => ticketBloc..add(TicketDetailFetch(page: ticketPage, size: size)),
            child: BlocListener<TicketBloc, TicketState>(
              listener: (context, state) {
                if (state is TicketDetailFetchFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is TicketDetailFetchSuccess) {
                    _ticketDetails.addAll(state.ticketDetails.items);
                    isLastTicketPage = state.ticketDetails.counter <= size * ticketPage;
                    isLoading = false;
                  } else if (state is TicketDetailFetchFailure) {
                    isLoading = false;
                  } else if (state is TicketDetailFetching) {
                    isLoading = true;
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemCount: _ticketDetails.length,
                            itemBuilder: (context, index) {
                              return TicketDetailItem(ticketDetail: _ticketDetails[index]);
                            },
                          ),
                        ),
                        if (isLoading)
                          Container(
                            color: AppColors.white.withOpacity(0.3),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (_ticketScrollController.position.pixels >
        0.7 * _ticketScrollController.position.maxScrollExtent) {
      log('Load more ticket');
      if (!isLastTicketPage && !isLoading) {
        ticketPage++;
        ticketBloc.add(TicketDetailFetch(page: ticketPage, size: size));
      }
    }
  }
}

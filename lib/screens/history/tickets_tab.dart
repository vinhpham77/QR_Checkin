import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/screens/history/ticket_detail_item.dart';

import '../../config/http_client.dart';
import '../../features/ticket/bloc/ticket_bloc.dart';
import '../../features/ticket/data/ticket_api_client.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';
import '../../features/ticket/dtos/ticket_detail_dto.dart';

class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<TicketsTab> with AutomaticKeepAliveClientMixin {
  final _ticketDetails = <TicketDetailDto>[];
  bool isLoading = false;
  final _scrollController = ScrollController();
  final ticketBloc = TicketBloc(
      ticketRepository: TicketRepository(TicketApiClient(dio)),
      ticketTypeRepository: TicketTypeRepository(TicketTypeApiClient(dio)));
  int size = 8;
  int page = 1;
  bool isLastPage = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ticketBloc.add(TicketDetailFetch(page: page, size: size));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => ticketBloc,
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
                isLastPage = state.ticketDetails.counter <= size * page;
                isLoading = false;
              } else if (state is TicketDetailFetchFailure) {
                isLoading = false;
              } else if (state is TicketDetailFetching) {
                isLoading = true;
              }

              return RefreshIndicator(
                onRefresh: () async {
                  page = 1;
                  isLastPage = false;
                  _ticketDetails.clear();
                  ticketBloc.add(TicketDetailFetch(page: page, size: size));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_ticketDetails.isNotEmpty)
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
                ),
              );
            }
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        0.7 * _scrollController.position.maxScrollExtent) {
      if (!isLastPage && !isLoading) {
        page++;
        ticketBloc.add(TicketDetailFetch(page: page, size: size));
      }
    }
  }
}
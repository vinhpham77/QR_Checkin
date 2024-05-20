import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/ticket/bloc/ticket_bloc.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_user_dto.dart';
import 'package:qr_checkin/screens/attendances/ticket_check_in_item.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/ticket/data/ticket_api_client.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';

class TicketCheckInTab extends StatefulWidget {
  final int eventId;

  const TicketCheckInTab({super.key, required this.eventId});

  @override
  State<TicketCheckInTab> createState() => _TicketCheckInTabState();
}

class _TicketCheckInTabState extends State<TicketCheckInTab>
    with AutomaticKeepAliveClientMixin {
  final _ticketCheckIns = <TicketUserDto>[];
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
    ticketBloc.add(
        TicketCheckInFetch(eventId: widget.eventId, page: page, size: size));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => ticketBloc,
      child: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketCheckInFetchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TicketBloc, TicketState>(builder: (context, state) {
          if (state is TicketCheckInFetchSuccess) {
            _ticketCheckIns.addAll(state.ticketCheckIns.items);
            isLastPage = state.ticketCheckIns.counter <= size * page;
            isLoading = false;
          } else if (state is TicketCheckInFetchFailure) {
            isLoading = false;
          } else if (state is TicketCheckInFetching) {
            isLoading = true;
          }

          return RefreshIndicator(
            onRefresh: () async {
              page = 1;
              isLastPage = false;
              _ticketCheckIns.clear();
              ticketBloc.add(TicketCheckInFetch(
                  eventId: widget.eventId, page: page, size: size));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_ticketCheckIns.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: _ticketCheckIns.length,
                        itemBuilder: (context, index) {
                          return TicketCheckInItem(
                              ticketCheckIns: _ticketCheckIns[index]);
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
        }),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLastPage && !isLoading) {
        isLoading = true;
        page++;
        ticketBloc.add(TicketCheckInFetch(
            eventId: widget.eventId, page: page, size: size));
      }
    }
  }
}

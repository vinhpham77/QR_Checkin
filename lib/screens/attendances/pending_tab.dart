import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/registration/dtos/registration_user_dto.dart';
import 'package:qr_checkin/screens/attendances/pending_registration_item.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/registration/bloc/registration_bloc.dart';
import '../../features/registration/data/registration_api_client.dart';
import '../../features/registration/data/registration_repository.dart';

class PendingTab extends StatefulWidget {
  final int eventId;

  const PendingTab({super.key, required this.eventId});

  @override
  State<PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab>
    with AutomaticKeepAliveClientMixin {
  final _attendanceUsers = <RegistrationUserDto>[];
  bool isLoading = false;
  final _scrollController = ScrollController();
  final registrationBloc = RegistrationBloc(
      registrationRepository:
          RegistrationRepository(RegistrationApiClient(dio)));
  int size = 8;
  int page = 1;
  bool isLastPage = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    registrationBloc.add(PendingRegistrationFetch(
        eventId: widget.eventId, page: page, size: size));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => registrationBloc,
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is AttendanceFetchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is AcceptedRegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is RejectRegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
          if (state is PendingRegistrationFetchSuccess) {
            _attendanceUsers.addAll(state.registrationUsers.items);
            isLastPage = state.registrationUsers.counter <= size * page;
            isLoading = false;
          } else if (state is AttendanceFetchFailure) {
            isLoading = false;
          } else if (state is AttendanceFetching) {
            isLoading = true;
          } else if (state is AcceptedRegistrationSuccess) {
            _attendanceUsers.removeWhere(
                (element) => element.registrationId == state.registrationId);
          } else if (state is RejectRegistrationSuccess) {
            _attendanceUsers.removeWhere(
                (element) => element.registrationId == state.registrationId);
          }

          return RefreshIndicator(
            onRefresh: () async {
              page = 1;
              isLastPage = false;
              _attendanceUsers.clear();
              registrationBloc.add(PendingRegistrationFetch(
                  eventId: widget.eventId, page: page, size: size));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_attendanceUsers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: _attendanceUsers.length,
                        itemBuilder: (context, index) {
                          return PendingRegistrationItem(
                              registrationUser: _attendanceUsers[index]);
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
        registrationBloc.add(PendingRegistrationFetch(
            eventId: widget.eventId, page: page, size: size));
      }
    }
  }
}

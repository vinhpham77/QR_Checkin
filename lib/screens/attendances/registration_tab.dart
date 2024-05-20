import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/registration/dtos/registration_user_dto.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/registration/bloc/registration_bloc.dart';
import '../../features/registration/data/registration_api_client.dart';
import '../../features/registration/data/registration_repository.dart';
import 'accepted_registration_item.dart';

class RegistrationTab extends StatefulWidget {
  final int eventId;

  const RegistrationTab({super.key, required this.eventId});

  @override
  State<RegistrationTab> createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab>
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
    registrationBloc.add(AcceptedRegistrationFetch(
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
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
          if (state is AcceptedRegistrationFetchSuccess) {
            _attendanceUsers.addAll(state.registrationUsers.items);
            isLastPage = state.registrationUsers.counter <= size * page;
            isLoading = false;
          } else if (state is AttendanceFetchFailure) {
            isLoading = false;
          } else if (state is AttendanceFetching) {
            isLoading = true;
          }

          return RefreshIndicator(
            onRefresh: () async {
              page = 1;
              isLastPage = false;
              _attendanceUsers.clear();
              registrationBloc.add(AcceptedRegistrationFetch(
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
                          return AcceptedRegistrationItem(
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
        registrationBloc.add(AcceptedRegistrationFetch(
            eventId: widget.eventId, page: page, size: size));
      }
    }
  }
}

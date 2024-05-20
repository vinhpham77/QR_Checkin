import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/registration/dtos/registration_detail_dto.dart';
import 'package:qr_checkin/screens/history/registration_item.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/registration/bloc/registration_bloc.dart';
import '../../features/registration/data/registration_api_client.dart';
import '../../features/registration/data/registration_repository.dart';

class RegistrationTab extends StatefulWidget {
  const RegistrationTab({super.key});

  @override
  State<RegistrationTab> createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab>
    with AutomaticKeepAliveClientMixin {
  final _registrationDetails = <RegistrationDetailDto>[];
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
    registrationBloc.add(RegistrationDetailFetch(page: page, size: size));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => registrationBloc,
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationDetailFetchFailure) {
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
          if (state is RegistrationDetailFetchSuccess) {
            _registrationDetails.addAll(state.registrationDetails.items);
            isLastPage = state.registrationDetails.counter <= size * page;
            isLoading = false;
          } else if (state is RegistrationDetailFetchFailure) {
            isLoading = false;
          } else if (state is RegistrationDetailFetching) {
            isLoading = true;
          }

          return RefreshIndicator(
            onRefresh: () async {
              page = 1;
              isLastPage = false;
              _registrationDetails.clear();
              registrationBloc
                  .add(RegistrationDetailFetch(page: page, size: size));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_registrationDetails.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: _registrationDetails.length,
                        itemBuilder: (context, index) {
                          return RegistrationItem(
                              registrationDetail: _registrationDetails[index]);
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
        registrationBloc.add(RegistrationDetailFetch(page: page, size: size));
      }
    }
  }
}

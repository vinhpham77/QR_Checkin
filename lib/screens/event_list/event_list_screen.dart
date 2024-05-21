import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/features/event/dtos/search_criteria.dart';

import '../../config/http_client.dart';
import '../../config/theme.dart';
import '../../features/event/bloc/event_bloc.dart';
import '../../features/event/data/event_api_client.dart';
import '../../features/event/data/event_repository.dart';
import '../../features/event/dtos/event_dto.dart';
import '../../widgets/location_provider.dart';
import 'event_item.dart';

class EventListScreen extends StatefulWidget {
  final SearchCriteria searchCriteria;

  const EventListScreen({super.key, required this.searchCriteria});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final _scrollController = ScrollController();
  final _events = <EventDto>[];
  int page = 1;
  late String key;
  int limit = 8;
  bool isLoading = false;
  bool isLastPage = false;
  LatLng? currentLocation;
  EventBloc eventBloc = EventBloc(EventRepository(EventApiClient(dio)));

  @override
  void initState() {
    super.initState();
    key = DateTime.now().millisecondsSinceEpoch.toString();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var newCurrentLocation = LocationProvider.of(context)?.currentLocation;

    if (currentLocation == null) {
      currentLocation = newCurrentLocation;
      eventBloc.add(EventFetch(
            page: page,
            limit: limit,
            keyword: widget.searchCriteria.keyword,
            fields: widget.searchCriteria.fields,
            categoryId: widget.searchCriteria.categoryId,
            sortField: widget.searchCriteria.sortField,
            isAsc: widget.searchCriteria.isAsc,
            longitude: currentLocation?.longitude ?? 0,
            latitude: currentLocation?.latitude ?? 0,
            key: key,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchCriteria.title),
      ),
      body: BlocProvider<EventBloc>(
        create: (context) => eventBloc..add(EventFetch(
          page: page,
          limit: limit,
          keyword: widget.searchCriteria.keyword,
          fields: widget.searchCriteria.fields,
          categoryId: widget.searchCriteria.categoryId,
          sortField: widget.searchCriteria.sortField,
          isAsc: widget.searchCriteria.isAsc,
          longitude: currentLocation?.longitude ?? 0,
          latitude: currentLocation?.latitude ?? 0,
          key: key,
        )),
        child: BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventFetchFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventFetchSuccess && state.key == key) {
                _events.addAll(state.events.items);

                var lastPage = state.events.counter / limit;
                isLastPage = page >= lastPage.ceil();
                isLoading = false;
              } else if (state is EventFetchFailure) {
                isLoading = false;
              } else if (state is EventFetching) {
                isLoading = true;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_events.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          controller: _scrollController,
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            return EventItem(event: _events[index]);
                          },
                        ),
                      ),
                    ),
                  if (isLoading)
                    Container(
                      color: AppColors.white.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
         _scrollController.position.maxScrollExtent) {
      if (!isLastPage) {
        page++;
        eventBloc.add(EventFetch(
              page: page,
              limit: limit,
              keyword: widget.searchCriteria.keyword,
              fields: widget.searchCriteria.fields,
              categoryId: widget.searchCriteria.categoryId,
              sortField: widget.searchCriteria.sortField,
              isAsc: widget.searchCriteria.isAsc,
              longitude: currentLocation?.longitude ?? 0,
              latitude: currentLocation?.latitude ?? 0,
              key: key,
            ));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

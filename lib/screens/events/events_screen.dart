import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/event/bloc/event_bloc.dart';
import 'package:qr_checkin/features/event/dtos/search_criteria.dart';
import 'package:qr_checkin/features/item_counter.dart';

import '../../config/router.dart';
import '../../widgets/location_provider.dart';
import 'event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin {
  final String newestEvent = 'Mới nhất';
  final String latestEvent = 'Vừa cập nhật';
  final String nearestEvent = 'Gần đây';
  var newestEvents = ItemCounterDto(0, []);
  var latestEvents = ItemCounterDto(0, []);
  var nearestEvents = ItemCounterDto(0, []);
  LatLng? currentLocation;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newCurrentLocation = LocationProvider.of(context)?.currentLocation;

    if (currentLocation == null) {
      currentLocation = newCurrentLocation;
      context.read<EventBloc>().add(EventFetch(
          fields: const [],
          sortField: 'distance',
          isAsc: true,
          categoryId: null,
          limit: 8,
          latitude: currentLocation?.latitude ?? 0,
          longitude: currentLocation?.longitude ?? 0,
          key: nearestEvent));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final eventState = context.watch<EventBloc>().state;

    switch (eventState) {
      case EventFetchSuccess(events: final events, key: final key):
        if (key == nearestEvent) {
          nearestEvents = events;
          context.read<EventBloc>().add(EventFetch(
              sortField: 'created_at',
              fields: const [],
              isAsc: false,
              categoryId: null,
              limit: 8,
              latitude: currentLocation?.latitude ?? 0,
              longitude: currentLocation?.longitude ?? 0,
              key: newestEvent));
        } else if (key == newestEvent) {
          newestEvents = events;
          context.read<EventBloc>().add(EventFetch(
              fields: const [],
              sortField: 'updated_at',
              isAsc: false,
              categoryId: null,
              limit: 8,
              latitude: currentLocation?.latitude ?? 0,
              longitude: currentLocation?.longitude ?? 0,
              key: latestEvent));
        } else if (key == latestEvent) {
          latestEvents = events;
        }
        break;
      default:
        break;
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<EventBloc>().add(EventFetch(
            fields: const [],
            sortField: 'distance',
            isAsc: true,
            categoryId: null,
            limit: 8,
            latitude: currentLocation?.latitude ?? 0,
            longitude: currentLocation?.longitude ?? 0,
            key: nearestEvent));
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              alignment: Alignment.topLeft,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 26),
                    height: 170,
                    color: AppColors.pink,
                    alignment: Alignment.centerLeft,
                    child: Text('Danh sách sự kiện',
                        style: themeData.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: AppColors.white,
                          surfaceTintColor: AppColors.lightTurquoise,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tìm kiếm sự kiện phù hợp',
                                style: TextStyle(color: AppColors.lightGray)),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                        onPressed: () {
                          context.push(RouteName.search);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gần đây',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(RouteName.eventList,
                              extra: SearchCriteria(
                                  title: 'Sự kiện gần đây',
                                  keyword: '',
                                  categoryId: null,
                                  sortField: 'distance',
                                  isAsc: true,
                                  fields: []));
                        },
                        child: const Text(
                          'Xem thêm',
                          style: TextStyle(
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 186,
                    transform: Matrix4.translationValues(-4, -2, 0),
                    child: ListView.separated(
                      itemCount: nearestEvents.items.length,
                      addRepaintBoundaries: true,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) => Event(
                        eventId: nearestEvents.items[index].id,
                        imageName: nearestEvents.items[index].backgroundImage,
                        title: nearestEvents.items[index].name,
                        organizer: nearestEvents.items[index].createdBy,
                        isRegistered: false,
                        description:
                            nearestEvents.items[index].description ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mới nhất',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(RouteName.eventList,
                              extra: SearchCriteria(
                                  title: 'Sự kiện mới nhất',
                                  keyword: '',
                                  categoryId: null,
                                  sortField: 'created_at',
                                  isAsc: false,
                                  fields: []));
                        },
                        child: const Text(
                          'Xem thêm',
                          style: TextStyle(
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 186,
                    transform: Matrix4.translationValues(-4, -2, 0),
                    child: ListView.separated(
                      itemCount: newestEvents.items.length,
                      addRepaintBoundaries: true,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) => Event(
                        eventId: newestEvents.items[index].id,
                        imageName: newestEvents.items[index].backgroundImage,
                        title: newestEvents.items[index].name,
                        organizer: newestEvents.items[index].createdBy,
                        isRegistered: false,
                        description:
                            newestEvents.items[index].description ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        latestEvent,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(RouteName.eventList,
                              extra: SearchCriteria(
                                  title: 'Sự kiện vừa cập nhật',
                                  keyword: '',
                                  categoryId: null,
                                  sortField: 'updated_at',
                                  isAsc: false,
                                  fields: []));
                        },
                        child: const Text(
                          'Xem thêm',
                          style: TextStyle(
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 186,
                    transform: Matrix4.translationValues(-4, -2, 0),
                    child: ListView.separated(
                      itemCount: latestEvents.items.length,
                      addRepaintBoundaries: true,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) => Event(
                        eventId: latestEvents.items[index].id,
                        imageName: latestEvents.items[index].backgroundImage,
                        title: latestEvents.items[index].name,
                        organizer: latestEvents.items[index].createdBy,
                        isRegistered: false,
                        description:
                            latestEvents.items[index].description ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

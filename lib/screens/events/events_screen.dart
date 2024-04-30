import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/event/bloc/event_bloc.dart';
import 'package:qr_checkin/features/event/dtos/item_counter.dart';
import 'package:qr_checkin/widgets/event_category.dart';

import '../../widgets/event.dart';
import '../../widgets/location_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final String newestEvent = 'Mới nhất';
  final String latestEvent = 'Vừa cập nhật';
  final String nearestEvent = 'Gần đây';
  var newestEvents = ItemCounterDTO(0, []);
  var latestEvents = ItemCounterDTO(0, []);
  var nearestEvents = ItemCounterDTO(0, []);
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocation = LocationProvider.of(context)?.currentLocation;
    context.read<EventBloc>().add(EventFetch(
        fields: ['distance'],
        category: null,
        limit: 8,
        latitude: currentLocation?.latitude ?? 0,
        longitude: currentLocation?.longitude ?? 0,
        key: nearestEvent));
  }

  @override
  Widget build(BuildContext context) {
    final eventState = context.watch<EventBloc>().state;

    switch (eventState) {
      case EventFetchSuccess(events: final events, key: final key):
        if (key == nearestEvent) {
          setState(() {
            nearestEvents = events;
          });
          context.read<EventBloc>().add(EventFetch(
              fields: ['created_at'],
              category: null,
              limit: 8,
              latitude: currentLocation?.latitude ?? 0,
              longitude: currentLocation?.longitude ?? 0,
              key: newestEvent));
        } else if (key == newestEvent) {
          setState(() {
            newestEvents = events;
          });
          context.read<EventBloc>().add(EventFetch(
              fields: ['updated_at'],
              category: null,
              limit: 8,
              latitude: currentLocation?.latitude ?? 0,
              longitude: currentLocation?.longitude ?? 0,
              key: latestEvent));
        } else if (key == latestEvent) {
          setState(() {
            latestEvents = events;
          });
        }
        break;
      default:
        break;
    }

    return SingleChildScrollView(
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
                      onPressed: () {},
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
                      onTap: () {},
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
                        imageUrl: nearestEvents.items[index].backgroundUrl,
                        title: nearestEvents.items[index].name,
                        organizer: nearestEvents.items[index].createdBy,
                        isRegistered: false,
                        description: nearestEvents.items[index].description ?? '',
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
                      onTap: () {},
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
                        imageUrl: newestEvents.items[index].backgroundUrl,
                        title: newestEvents.items[index].name,
                        organizer: newestEvents.items[index].createdBy,
                        isRegistered: false,
                        description: newestEvents.items[index].description ?? '',
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
                      onTap: () {},
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
                        imageUrl: latestEvents.items[index].backgroundUrl,
                        title: latestEvents.items[index].name,
                        organizer: latestEvents.items[index].createdBy,
                        isRegistered: false,
                        description: latestEvents.items[index].description ?? '',
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
                const Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 184,
                  transform: Matrix4.translationValues(-4, -2, 0),
                  child: ListView.separated(
                    itemCount: 8,
                    addRepaintBoundaries: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) => EventCategory(
                        category: "Thể thao",
                        icon: Icons.sports,
                        onTap: () => {}),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

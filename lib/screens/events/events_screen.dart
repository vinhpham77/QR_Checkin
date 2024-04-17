import 'package:flutter/material.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/widgets/event_category.dart';

import '../../widgets/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
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
                    itemCount: 8,
                    addRepaintBoundaries: true,
                    physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) => const Event(
                      eventId: 1,
                      imageUrl: 'https://picsum.photos/200/300',
                      title: 'Sự kiện 1',
                      organizer: 'Tổ chức 1',
                      isRegistered: false,
                      description: 'Mô tả sự kiện 1',
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
                      'Nổi bật',
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
                    itemCount: 8,
                    addRepaintBoundaries: true,
                    physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                    itemBuilder: (context, index) => const Event(
                      eventId: 1,
                      imageUrl: 'https://picsum.photos/200/300',
                      title: 'Sự kiện 1',
                      organizer: 'Tổ chức 1',
                      description: 'Mô tả sự kiện 1', isRegistered: true,
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

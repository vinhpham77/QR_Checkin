import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/utils/data_utils.dart';
import 'package:qr_checkin/utils/image_utils.dart';

import '../../config/router.dart';
import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';

class EventItem extends StatelessWidget {
  final EventDto event;

  const EventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(RouteName.eventDetail, extra: event.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          color: AppColors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 105,
                    width: double.infinity,
                    child: Image.network(
                      getImageUrl(event.backgroundImage),
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  event.name,
                  overflow: TextOverflow.ellipsis,
                  style: themeData.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: themeData.hintColor,
                        size: 16,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 2, bottom: 1),
                          child: Text(
                            event.createdBy,
                            overflow: TextOverflow.ellipsis,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              color: themeData.hintColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(height: 4),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: themeData.hintColor,
                        size: 16,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            formatDate(event.startAt),
                            overflow: TextOverflow.ellipsis,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              color: themeData.hintColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

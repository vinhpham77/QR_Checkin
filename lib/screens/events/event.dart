import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/config/router.dart';

import '../../config/theme.dart';

class Event extends StatelessWidget {
  final int? eventId;
  final bool isRegistered;
  final String? imageUrl;
  final String title;
  final String? organizer;
  final String? description;

  const Event({
    super.key,
    required this.isRegistered,
    required this.eventId,
    required this.imageUrl,
    required this.title,
    required this.organizer,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(RouteName.eventDetail, extra: eventId);
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
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
                    height: 112,
                    width: 200,
                    child: Image.network(
                      imageUrl ?? '',
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
                  if (isRegistered)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: AppColors.red,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  width: 200,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: themeData.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 200,
                  child: Row(
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
                              organizer!,
                              overflow: TextOverflow.ellipsis,
                              style: themeData.textTheme.bodyMedium?.copyWith(
                                color: themeData.hintColor,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

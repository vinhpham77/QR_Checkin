import 'package:flutter/material.dart';

import '../config/theme.dart';

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
    return Container(
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
                Image.network(
                  imageUrl!,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error),
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
                  width: 200,
                  height: 112,
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
              Text(
                title,
                style: themeData.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(
                      Icons.person,
                      color: themeData.hintColor,
                      size: 16,
                    ),
                    Text(
                      organizer!,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        color: themeData.hintColor,
                      ),
                    ),
                  ]),
                  const SizedBox(width: 16),
                  Text(description!,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        color: themeData.hintColor,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

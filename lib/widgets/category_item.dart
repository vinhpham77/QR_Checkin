import 'package:flutter/material.dart';

import '../config/theme.dart';

class CategoryItem extends StatelessWidget {
  final String category;
  final VoidCallback onDelete;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Transform.scale(scale: 0.95).transform,
      margin: const EdgeInsets.only(right: 4, bottom: 1, top: 1, left: 1),
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('#', style: TextStyle(fontSize: 16)),
          Text(category,
              style: const TextStyle(fontSize: 16, color: AppColors.black),
              maxLines: 1),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
              iconSize: 20,
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(Colors.black54),
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              )),
        ],
      ),
    );
  }
}

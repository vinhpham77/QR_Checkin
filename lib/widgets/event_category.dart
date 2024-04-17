import 'package:flutter/material.dart';

import '../config/theme.dart';

class EventCategory extends StatelessWidget {
  final String category;
  final IconData icon;
  final VoidCallback onTap;

  const EventCategory({
    super.key,
    required this.category,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Icon(icon, color: Colors.black, size: 48),
          ),
        ),
        const SizedBox(height: 6),
        Text(category),
      ],
    );
  }
}

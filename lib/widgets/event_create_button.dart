import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/router.dart';
import '../config/theme.dart';

class EventCreateButton extends StatelessWidget {
  const EventCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.secondary.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Tạo sự kiện',
          onPressed: () {
            context.push(RouteName.eventCreate);
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(themeData.colorScheme.secondary),
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          )),
    );
  }
}

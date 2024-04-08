import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/config/router.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;

  const BottomMenu(this.menuIndex, {super.key});

  BottomNavigationBarItem getItem(IconData iconData, IconData activeIconData,
      String title, ThemeData theme, int index) {
    return BottomNavigationBarItem(
        label: '',
        tooltip: title,
        activeIcon: Icon(
          activeIconData,
        ),
        icon: Icon(
          iconData,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem(Icons.home_outlined, Icons.home, 'Home', theme, 0),
      getItem(Icons.event_seat_outlined, Icons.event_seat, 'Registration', theme, 1),
      getItem(Icons.favorite_outline, Icons.favorite, 'Favorites', theme, 2),
      getItem(Icons.person_outline, Icons.person, 'Profile', theme, 3)
    ];

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 32.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: menuIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                context.push(RouteName.home);
                break;
              case 1:
                context.push(RouteName.registrations);
                break;
              case 2:
                context.push(RouteName.favorites);
                break;
              case 3:
                context.push(RouteName.profile);
                break;
            }
          },
          items: menuItems,
        ),
      ),
    );
  }
}

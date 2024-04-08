import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/utils/theme_ext.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({super.key, required this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late final theme = Theme.of(context);
  final _pageController = PageController();
  late final List<BottomNavigationBarItem> menuItems = [
    _getItem(Icons.home_outlined, Icons.home, 'Trang chủ', theme),
    _getItem(Icons.event_seat_outlined, Icons.event_seat, 'Đã đăng ký', theme),
    BottomNavigationBarItem(icon: Container(), label: ''),
    _getItem(Icons.favorite_outline, Icons.favorite, 'Favorites', theme),
    _getItem(Icons.person_outline, Icons.person, 'Profile', theme)
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Scaffold(
      body: PageView(
        controller: _pageController,
        padEnds: false,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const Center(
            child: Text('Home Screen'),
          ),
          const Center(
            child: Text('Registrations Screen'),
          ),
          Center(
            child: Container(),
          ),
          const Center(
            child: Text('Favorites Screen'),
          ),
          const Center(
            child: Text('Profile Screen'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  iconSize: 32.0,
                  currentIndex: _selectedIndex,
                  items: menuItems,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              _buildQRButton(theme),
            ],
          ),
        ),
      ),
    );

    widget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthLogoutSuccess():
            context.read<AuthBloc>().add(AuthStarted());
            context.pushReplacement(RouteName.login);
            break;
          case AuthLogoutFailure(message: final msg):
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Logout Failure'),
                  content: Text(msg),
                  backgroundColor: context.color.surface,
                );
              },
            );
          default:
        }
      },
      child: widget,
    );

    return widget;
  }

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  BottomNavigationBarItem _getItem(IconData iconData, IconData activeIconData,
      String title, ThemeData theme) {
    return BottomNavigationBarItem(
      label: title,
      tooltip: title,
      activeIcon: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Icon(activeIconData),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Icon(activeIconData),
      ),
    );
  }

  Widget _buildQRButton(ThemeData theme) {
    return Transform.translate(
      offset: const Offset(0, -4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: AppColors.backgroundLight,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

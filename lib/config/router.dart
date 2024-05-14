import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/features/event/dtos/search_criteria.dart';
import 'package:qr_checkin/features/qr_event.dart';
import 'package:qr_checkin/screens/event_list/event_list_screen.dart';
import 'package:qr_checkin/screens/portrait_capture/portrait_capture_screen.dart';
import 'package:qr_checkin/screens/search/search_screen.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../screens/cu_event/cu_event_screen.dart';
import '../screens/event_detail/event_detail_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/qr_scanner/qr_scanner.dart';
import '../screens/register/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String registrations = '/registrations';
  static const String favorites = '/favorites';
  static const String scanner = '/scanner';
  static const String eventCreate = '/event/create';
  static const String eventUpdate = '/event/:id/update';
  static const String search = '/search';
  static const String eventList = '/event/list';
  static const String eventCapture = '/event/capture';
  static const String eventDetail = '/event/:id';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
      return null;
    }
    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => const HomeScreen(selectedIndex: 0),
    ),
    GoRoute(
      path: RouteName.registrations,
      builder: (context, state) => const HomeScreen(selectedIndex: 1),
    ),
    GoRoute(
      path: RouteName.favorites,
      builder: (context, state) => const HomeScreen(selectedIndex: 2),
    ),
    GoRoute(
      path: RouteName.profile,
      builder: (context, state) => const HomeScreen(selectedIndex: 3),
    ),
    GoRoute(
      path: RouteName.scanner,
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
        path: RouteName.eventCreate,
        builder: (context, state) => const CuEventScreen()),
    GoRoute(
        path: RouteName.eventUpdate,
        builder: (context, state) {
          int id = state.extra as int;
          return CuEventScreen(id: id);
        }),
    GoRoute(
      path: RouteName.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
        path: RouteName.eventList,
        builder: (context, state) {
          return EventListScreen(searchCriteria: state.extra as SearchCriteria);
        }),
    GoRoute(
      path: RouteName.eventCapture,
      builder: (context, state) {
        var map = state.extra as Map<String, dynamic>;
        var qrEvent = map['qrEvent'] as QrEvent;
        var qrImage = map['qrImage'] as Uint8List;

        return PortraitCaptureScreen(qrEvent: qrEvent, qrImage: qrImage);
      }
    ),
    GoRoute(
        path: RouteName.eventDetail,
        builder: (context, state) {
          int id = state.extra as int;
          return EventDetailScreen(eventId: id);
        }),
  ],
);

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String registrations = '/registrations';
  static const String favorites = '/favorites';

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
      path: RouteName.home,
      builder: (context, state) => const HomeScreen(selectedIndex: 0),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
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
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/http_client.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_api_client.dart';
import 'features/auth/data/auth_local_data_source.dart';
import 'features/auth/data/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sf));
}

class MyApp extends StatelessWidget {

  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(
        authApiClient: AuthApiClient(dio),
        authLocalDataSource: AuthLocalDataSource(sharedPreferences),
      ),
      child: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepository>(),
        ),
        child: const AppContent(),
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    super.key,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthAuthenticateStarted());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthInitial) {
      return Container();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: router,
    );
  }
}

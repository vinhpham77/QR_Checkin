import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_checkin/features/event/data/event_api_client.dart';
import 'package:qr_checkin/features/event/data/event_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/http_client.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_api_client.dart';
import 'features/auth/data/auth_local_data_source.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/event/bloc/event_bloc.dart';

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
        lazy: false,
        create: (context) {
          var authRepository = context.read<AuthRepository>();
          addAccessTokenInterceptor(dio, authRepository);
          return AuthBloc(authRepository);
        },
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
    return RepositoryProvider(
      create: (context) => EventRepository(
        EventApiClient(dio),
      ),
      child: BlocProvider(
        create: (context) => EventBloc(
          context.read<EventRepository>(),
        ),
        child: MaterialApp.router(
          locale: const Locale('vi', 'VN'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: themeData,
          routerConfig: router,
        ),
      ),
    );
  }
}

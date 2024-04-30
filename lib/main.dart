import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/features/event/data/event_api_client.dart';
import 'package:qr_checkin/features/event/data/event_repository.dart';
import 'package:qr_checkin/widgets/location_provider.dart';
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
  await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  LatLng currentLocation = LatLng(position.latitude, position.longitude);

  runApp(MyApp(sharedPreferences: sf, currentLocation: currentLocation));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final LatLng currentLocation;

  const MyApp({super.key, required this.sharedPreferences, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return LocationProvider(
      currentLocation: currentLocation,
      child: RepositoryProvider(
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
  LatLng? currentLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocation = LocationProvider.of(context)?.currentLocation;
  }

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

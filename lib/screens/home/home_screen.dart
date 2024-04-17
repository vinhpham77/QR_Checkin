import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/screens/events/events_screen.dart';
import 'package:qr_checkin/utils/theme_ext.dart';
import 'package:qr_checkin/widgets/main_qr_button.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../widgets/event_create_button.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({super.key, required this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng? _currentPosition;
  bool serviceEnabled = false;
  late int _selectedIndex;
  late final theme = Theme.of(context);
  final _pageController = PageController();
  late final List<BottomNavigationBarItem> menuItems = [
    _getItem(Icons.home_outlined, Icons.home, 'Trang chủ', theme),
    _getItem(Icons.event_seat_outlined, Icons.event_seat, 'Đã đăng ký', theme),
    BottomNavigationBarItem(icon: Container(), label: ''),
    _getItem(Icons.edit_document, Icons.favorite, 'Yêu thích', theme),
    _getItem(Icons.person_outline, Icons.person, 'Hồ sơ', theme)
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            padEnds: false,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              const EventsScreen(),
              const Center(
                child: Text('Đã đăng ký'),
              ),
              Container(),
              Center(
                child: _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        markers: _markers,
                        onTap: (LatLng latLng) {
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(latLng),
                          );
                          setState(() {
                            _markers.clear();
                            _markers.add(
                              Marker(
                                markerId: MarkerId(latLng.toString()),
                                position: latLng,
                                infoWindow: InfoWindow(
                                  title: 'Địa điểm đã chọn',
                                  snippet:
                                      '(${latLng.latitude}, ${latLng.longitude})',
                                ),
                              ),
                            );
                          });
                        },
                        buildingsEnabled: true,
                        mapToolbarEnabled: true,
                        rotateGesturesEnabled: true,
                        trafficEnabled: true,
                        compassEnabled: true,
                        indoorViewEnabled: true,
                        tiltGesturesEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 18,
                        ),
                      ),
              ),
              const Center(
                child: Text('Profile Screen'),
              ),
            ],
          ),
          floatingActionButton: const EventCreateButton(),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: Offset(0, 28)),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: BottomNavigationBar(
                  selectedItemColor: AppColors.black,
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
            ),
          ),
        ),
        const Positioned(bottom: 8, left: 0, right: 0, child: MainQRButton())
      ],
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
      activeIcon: Icon(activeIconData),
      icon: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Icon(activeIconData),
      ),
    );
  }

  void _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

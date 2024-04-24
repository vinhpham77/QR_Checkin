import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/event/bloc/event_bloc.dart';
import 'package:qr_checkin/screens/create_event/second_screen.dart';
import 'package:qr_checkin/screens/create_event/third_screen.dart';

import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';
import 'first_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _index = 0;
  int count = 3;

  bool isLoading = false;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _firstScreenKey = GlobalKey<FirstScreenState>();
  final _secondScreenKey = GlobalKey<SecondScreenState>();
  final _thirdScreenKey = GlobalKey<ThirdScreenState>();
  late EventDto event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tạo sự kiện'),
        ),
        body: BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventCreated) {
              Navigator.of(context).pop();
            } else if (state is EventCreateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventCreateInitial) {
                event = state.event;
              } else if (state is EventCreating) {
                return Stack(
                  children: [
                    _buildStepper(),
                    Container(
                      color: AppColors.white.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                );
              }

              return _buildStepper();
            },
          ),
        ));
  }

  Stepper _buildStepper() {
    return Stepper(
      controlsBuilder: (context, details) {
        return Container(
          margin: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_index != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundLight,
                    surfaceTintColor: AppColors.black,
                    foregroundColor: AppColors.black,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              if (_index != count - 1)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Icon(Icons.arrow_forward),
                ),
              if (_index == count - 1)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeData.primaryColor,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    _handleCreateEvent(context);
                  },
                  child: const Text('Hoàn tất'),
                ),
            ],
          ),
        );
      },
      type: StepperType.horizontal,
      currentStep: _index,
      onStepTapped: (index) {
        setState(() {
          _index = index;
        });
      },
      onStepContinue: () {
        setState(() {
          _index++;
        });
      },
      onStepCancel: () {
        setState(() {
          _index--;
        });
      },
      steps: [
        Step(
          title: const Text('Mô tả'),
          content: FirstScreen(
              formKey: _formKeys[0], key: _firstScreenKey, event: event),
          isActive: _index == 0,
          state: _index == 0 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('Vị trí'),
          content: SecondScreen(
              formKey: _formKeys[1], key: _secondScreenKey, event: event),
          isActive: _index == 1,
          state: _index == 1 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('Tuỳ chọn'),
          content: ThirdScreen(
              formKey: _formKeys[2], key: _thirdScreenKey, event: event),
          isActive: _index == 2,
          state: _index == 2 ? StepState.editing : StepState.complete,
        ),
      ],
    );
  }

  Future<void> _handleCreateEvent(BuildContext context) async {
    final firstScreen = _firstScreenKey.currentState;
    final secondScreen = _secondScreenKey.currentState;
    final thirdScreen = _thirdScreenKey.currentState;

    if (firstScreen == null || secondScreen == null || thirdScreen == null) {
      return;
    }

    final firstForm = _formKeys[0].currentState;
    final secondForm = _formKeys[1].currentState;
    final thirdForm = _formKeys[2].currentState;

    if (firstForm!.validate() &&
        secondForm!.validate() &&
        thirdForm!.validate()) {
      String description = await firstScreen.description;

      final newEvent = event.copyWith(
        id: firstScreen.id,
        backgroundUrl: firstScreen.backgroundUrl,
        name: firstScreen.name,
        description: description,
        location: secondScreen.location,
        radius: secondScreen.radius,
        latitude: secondScreen.latitude,
        longitude: secondScreen.longitude,
        startAt: secondScreen.startAt,
        endAt: secondScreen.endAt,
        slots: thirdScreen.slots,
        categories: firstScreen.selectedCategories,
        checkinQrCode: thirdScreen.checkinQrCode,
        checkoutQrCode: thirdScreen.checkoutQrCode,
        isRequired: thirdScreen.isRequired,
        isApproved: thirdScreen.isApproved,
      );

      context.read<EventBloc>().add(EventCreateStarted(event: newEvent));
    }
  }
}

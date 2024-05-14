import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/config/router.dart';
import 'package:qr_checkin/features/event/bloc/event_bloc.dart';
import 'package:qr_checkin/screens/cu_event/second_screen.dart';
import 'package:qr_checkin/screens/cu_event/third_screen.dart';

import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';
import '../../widgets/modal.dart';
import 'first_screen.dart';

class CuEventScreen extends StatefulWidget {
  final int id;

  const CuEventScreen({super.key, this.id = 0});

  @override
  State<CuEventScreen> createState() => _CuEventScreenState();
}

class _CuEventScreenState extends State<CuEventScreen> {
  int _index = 0;
  int count = 3;

  bool isLoading = false;
  late final GlobalKey<FirstScreenState> _firstScreenKey;
  late final GlobalKey<SecondScreenState> _secondScreenKey;
  late final GlobalKey<ThirdScreenState> _thirdScreenKey;
  late EventDto event;

  @override
  void initState() {
    super.initState();
    _firstScreenKey = GlobalKey<FirstScreenState>();
    _secondScreenKey = GlobalKey<SecondScreenState>();
    _thirdScreenKey = GlobalKey<ThirdScreenState>();
    if (widget.id != 0) {
      context.read<EventBloc>().add(EventFetchOne(id: widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == 0
            ? const Text('Tạo sự kiện')
            : const Text('Chỉnh sửa sự kiện'),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          switch (state) {
            case EventCreated():
              context.pushReplacement(RouteName.eventDetail,
                  extra: state.event.id);
              break;
            default:
              break;
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          bloc: context.read<EventBloc>(),
          builder: (context, state) {
            return (switch (state) {
              EventInitial() =>
                const Center(child: CircularProgressIndicator()),
              EventFetchOneLoading() =>
                const Center(child: CircularProgressIndicator()),
              EventCreateInitial(event: final eventDto) =>
                _buildStepper(eventDto),
              EventFetchOneSuccess(event: final eventDto) =>
                _buildStepper(eventDto),
              EventFetchOneFailure(message: final msg) =>
                _buildTryAgainModal(msg, context),
              EventCreating() => _buildOperationInProgress(),
              EventUpdating() => _buildOperationInProgress(),
              EventCreateFailure(message: final msg) =>
                _buildFailureStack(context, msg),
              EventUpdateFailure(message: final msg) =>
                _buildFailureStack(context, msg),
              _ => _buildStepper(event),
            });
          },
        ),
      ),
    );
  }

  Stack _buildFailureStack(BuildContext context, String message) {
    return Stack(
      children: [
        _buildStepper(event),
        AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ],
    );
  }

  Stack _buildOperationInProgress() {
    return Stack(
      children: [
        _buildStepper(event),
        AbsorbPointer(
          absorbing: true,
          child: Container(
            color: AppColors.white.withOpacity(0.5),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Modal _buildTryAgainModal(String msg, BuildContext context) {
    return Modal(
      message: msg,
      button: FilledButton.icon(
        onPressed: () {
          context.read<EventBloc>().add(EventFetchOne(id: widget.id));
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Thử lại'),
      ),
    );
  }

  Stepper _buildStepper(EventDto eventDto) {
    event = eventDto;

    return Stepper(
      controlsBuilder: (context, details) {
        return Container(
          margin: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_index != 0)
                ElevatedButton(
                  onPressed: () {
                    details.onStepCancel!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundLight,
                    surfaceTintColor: AppColors.black,
                    foregroundColor: AppColors.black,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              if (_index != count - 1)
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        details.onStepContinue!();
                      },
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              if (_index == count - 1)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeData.primaryColor,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    _handleCuEvent(
                        context: context, isCreating: widget.id == 0);
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
          content: FirstScreen(key: _firstScreenKey, event: event),
          isActive: _index == 0,
          state: _index == 0 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('Vị trí'),
          content: SecondScreen(key: _secondScreenKey, event: event),
          isActive: _index == 1,
          state: _index == 1 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('Tuỳ chọn'),
          content: ThirdScreen(key: _thirdScreenKey, event: event),
          isActive: _index == 2,
          state: _index == 2 ? StepState.editing : StepState.complete,
        ),
      ],
    );
  }

  Future<void> _handleCuEvent(
      {required BuildContext context, required bool isCreating}) async {
    final firstScreen = _firstScreenKey.currentState;
    final secondScreen = _secondScreenKey.currentState;
    final thirdScreen = _thirdScreenKey.currentState;

    if (firstScreen == null || secondScreen == null || thirdScreen == null) {
      return;
    }

    if (!firstScreen.isValidForm) {
      setState(() {
        _index = 0;
      });
      return;
    }

    if (!secondScreen.isValidForm) {
      setState(() {
        _index = 1;
      });
      return;
    }

    if (!thirdScreen.isValidForm) {
      setState(() {
        _index = 2;
      });
      return;
    }

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
      isTicketSeller: thirdScreen.isTicketSeller,
      ticketTypes: thirdScreen.ticketTypes,
      categories: firstScreen.selectedCategories,
      checkinQrCode: thirdScreen.checkinQrCode,
      checkoutQrCode: thirdScreen.checkoutQrCode,
      regisRequired: thirdScreen.regisRequired,
      approvalRequired: thirdScreen.approvalRequired,
      captureRequired: thirdScreen.captureRequired,
    );

    if (isCreating) {
      context.read<EventBloc>().add(EventCreate(event: newEvent));
    } else {
      context
          .read<EventBloc>()
          .add(EventUpdate(eventId: widget.id, event: newEvent));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

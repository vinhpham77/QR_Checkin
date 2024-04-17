import 'package:flutter/material.dart';
import 'package:qr_checkin/screens/create_event/second_screen.dart';
import 'package:qr_checkin/screens/create_event/third_screen.dart';

import '../../config/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tạo sự kiện'),
        ),
        body: Stepper(
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
                      onPressed: () {},
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
              title: const Text('Thông tin'),
              content: FirstScreen(formKey: _formKeys[0]),
              isActive: _index == 0,
              state: _index == 0 ? StepState.editing : StepState.complete,
            ),
            Step(
              title: const Text('Vị trí'),
              content: SecondScreen(formKey: _formKeys[1]),
              isActive: _index == 1,
              state: _index == 1 ? StepState.editing : StepState.complete,
            ),
            Step(
              title: const Text('Đăng ký'),
              content: ThirdScreen(formKey: _formKeys[2]),
              isActive: _index == 2,
              state: _index == 2 ? StepState.editing : StepState.complete,
            ),
          ],
        ));
  }
}

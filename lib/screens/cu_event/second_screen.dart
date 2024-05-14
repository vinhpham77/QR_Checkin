import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/widgets/date_time_picker.dart';

import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';
import '../../widgets/gmap.dart';

class SecondScreen extends StatefulWidget {
  final EventDto event;

  const SecondScreen({super.key, required this.event});

  @override
  State<SecondScreen> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  late final TextEditingController _locationController;
  late final TextEditingController _radiusController;
  late DateTime _startTime;
  late DateTime _endTime;
  late LatLng _latLng;
  final _locationKey = GlobalKey<FormFieldState>();
  final _locationFocusNode = FocusNode();
  final _radiusKey = GlobalKey<FormFieldState>();
  final _radiusFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool get isValidForm => _formKey.currentState!.validate();

  String get location => _locationController.text;
  DateTime get startAt => _startTime;
  DateTime get endAt => _endTime;
  double get latitude => _latLng.latitude;
  double get longitude => _latLng.longitude;
  double get radius => double.tryParse(_radiusController.text) ?? 20;

  @override
  void initState() {
    super.initState();
    _radiusController = TextEditingController(text: widget.event.radius.toString());
    _locationController = TextEditingController(text: widget.event.location);
    _startTime = widget.event.startAt;
    _endTime = widget.event.endAt;
    _latLng = LatLng(widget.event.latitude, widget.event.longitude);

    _locationFocusNode.addListener(() {
      if (!_locationFocusNode.hasFocus) {
        _locationKey.currentState?.validate();
      }
    });

    _radiusFocusNode.addListener(() {
      if (!_radiusFocusNode.hasFocus) {
        _radiusKey.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Thời gian bắt đầu',
            style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 64,
          child: DateTimePicker(
              initialDate: _startTime,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _startTime = dateTime;

                  if (_endTime.isBefore(_startTime)) {
                    _endTime = _startTime.add(const Duration(hours: 2));
                  }
                });
              },
              firstDate: DateTime.now(),
              lastDate: _startTime.add(const Duration(days: 365))),
        ),
        const SizedBox(height: 18),
        Text('Thời gian kết thúc', style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 64,
          child: DateTimePicker(
              initialDate: _startTime.add(const Duration(hours: 2)),
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _endTime = dateTime;

                  if (_endTime.isBefore(_startTime)) {
                    _startTime = _endTime.subtract(const Duration(hours: 2));
                  }
                });
              },
              firstDate: _startTime,
              lastDate: _startTime.add(const Duration(days: 365))),
        ),
        const SizedBox(height: 18),
        Text('Địa điểm tổ chức', style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          key: _locationKey,
          focusNode: _locationFocusNode,
          decoration: const InputDecoration(filled: true),
          onEditingComplete: () {
            _locationKey.currentState?.validate();
            _locationFocusNode.unfocus();
          },
          controller: _locationController,
          autofillHints: const [AutofillHints.addressCityAndState],
          maxLength: 255,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập địa điểm tổ chức';
            }

            return null;
          },
        ),
        const SizedBox(height: 18),
        Text('Bán kính khu vực (m)', style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          key: _radiusKey,
          focusNode: _radiusFocusNode,
          controller: _radiusController,
          decoration: const InputDecoration(filled: true),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập bán kính khu vực';
            }

            var doubleValue = double.tryParse(value);
            if (doubleValue! <= 0.0) {
              return 'Vui lòng nhập số lớn hơn 0';
            }

            return null;
          },
        ),
        const SizedBox(height: 18),
        Text('Vị trí bản đồ', style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            height: 400,
            child: GMap(
              radius: double.tryParse(_radiusController.text) ?? 20,
              latLng: _latLng,
              onLocationChanged: (latLng) {
                setState(() {
                  log('latLng: $latLng');
                  _latLng = latLng;
                });
              },
            )),
      ]),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _radiusController.dispose();
    _locationFocusNode.dispose();
    _radiusFocusNode.dispose();
    _radiusKey.currentState?.dispose();
    _locationKey.currentState?.dispose();
    super.dispose();
  }
}

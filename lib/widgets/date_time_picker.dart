import 'package:flutter/material.dart';

import '../utils/data_utils.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateTimeChanged;

  const DateTimePicker(
      {super.key,
      required this.initialDate,
      required this.onDateTimeChanged,
      required this.firstDate,
      required this.lastDate});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = formatDateTime(widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => _openDatePicker(context),
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _openDatePicker(context),
        ),
      ),
    );
  }

  _openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('vi', 'VN'),
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        cancelText: 'Hủy',
        confirmText: 'Chọn',
        hourLabelText: 'Giờ',
        minuteLabelText: 'Phút',
        errorInvalidText: 'Giờ không hợp lệ',
        helpText: 'Chọn giờ',
        barrierLabel: 'Chọn giờ',
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child!,
          );
        },
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.fromDateTime(widget.initialDate),
      );
      if (time != null) {
        var dateTime = DateTime(
            picked.year, picked.month, picked.day, time.hour, time.minute);
        widget.onDateTimeChanged(dateTime);

        setState(() {
          _controller.text = formatDateTime(dateTime);
        });
      }
    }
  }
}

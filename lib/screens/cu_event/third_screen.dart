import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';

class ThirdScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final EventDto event;

  const ThirdScreen({super.key, required this.formKey, required this.event});

  @override
  State<ThirdScreen> createState() => ThirdScreenState();
}

class ThirdScreenState extends State<ThirdScreen> {

  late bool regisRequired;
  late bool approvalRequired;
  late bool captureRequired;
  late String checkinQrCode;
  late String? checkoutQrCode;
  late int? slots;
  late final TextEditingController _slotsController;

  @override
  void initState() {
    super.initState();

    regisRequired = widget.event.regisRequired;
    approvalRequired = widget.event.approvalRequired;
    captureRequired = widget.event.captureRequired;
    checkinQrCode = widget.event.checkinQrCode;
    checkoutQrCode = widget.event.checkoutQrCode;
    slots = widget.event.slots;
    _slotsController = TextEditingController(text: slots?.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yêu cầu check out', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: checkoutQrCode != null,
              onChanged: (value) {
                setState(() {
                  checkoutQrCode = value ? 'checkout' : null;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yêu cầu chụp ảnh xác minh', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: captureRequired,
              onChanged: (value) {
                setState(() {
                  captureRequired = value;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yêu cầu đăng ký trước', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: regisRequired,
              onChanged: (value) {
                setState(() {
                  regisRequired = value;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phê duyệt lượt đăng ký', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: approvalRequired,
              onChanged: (value) {
                setState(() {
                  approvalRequired = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Số lượng đăng ký', style: themeData.textTheme.bodyMedium!),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _slotsController,
          decoration: const InputDecoration(
              filled: true, hintText: 'Để trống nếu không giới hạn số lượng'),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return null;
            }

            int? number = int.tryParse(value);
            if (number! < 0) {
              return 'Số lượng phải lớn hơn 0';
            }

            slots = number;
            return null;
          },
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _slotsController.dispose();
    super.dispose();
  }
}

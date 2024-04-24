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

  late bool isRequired;
  late bool isApproved;
  late String checkinQrCode;
  late String? checkoutQrCode;
  late int? slots;

  @override
  void initState() {
    super.initState();

    isRequired = widget.event.isRequired;
    isApproved = widget.event.isApproved;
    checkinQrCode = widget.event.checkinQrCode;
    checkoutQrCode = widget.event.checkoutQrCode;
    slots = widget.event.slots;
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
            Text('Yêu cầu đăng ký trước', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: isRequired,
              onChanged: (value) {
                setState(() {
                  isRequired = value;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phê duyệt yêu cầu', style: themeData.textTheme.bodyMedium!),
            // Switch
            Switch(
              value: isApproved,
              onChanged: (value) {
                setState(() {
                  isApproved = value;
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
          decoration: const InputDecoration(
              filled: true, hintText: 'Để trống nếu không giới hạn số lượng'),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          validator: (value) {
            int? number = int.tryParse(value ?? '0');
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
}

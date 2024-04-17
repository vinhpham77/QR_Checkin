import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/theme.dart';

class ThirdScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ThirdScreen({super.key, required this.formKey});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  bool isRequired = false;
  bool isApproved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

          return null;
        },
      ),
    ]);
  }
}

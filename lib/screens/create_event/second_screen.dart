import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../widgets/gmap.dart';

class SecondScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SecondScreen({super.key, required this.formKey});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late final TextEditingController _radiusController;
  double radius = 50;

  @override
  void initState() {
    super.initState();
    _radiusController = TextEditingController(text: radius.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Địa điểm tổ chức', style: themeData.textTheme.bodyMedium!),
      const SizedBox(
        height: 8,
      ),
      TextFormField(
        decoration: const InputDecoration(filled: true),
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
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
        controller: _radiusController,
        decoration: const InputDecoration(filled: true),
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

          // parseInt
          var intValue = int.tryParse(value);
          if (intValue == null || intValue <= 0) {
            return 'Vui lòng nhập số nguyên dương';
          }

          setState(() {
            radius = intValue.toDouble();
          });

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
            radius: radius,
          )),
    ]);
  }
}

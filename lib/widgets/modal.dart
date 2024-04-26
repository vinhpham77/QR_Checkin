import 'package:flutter/material.dart';
import 'package:qr_checkin/utils/theme_ext.dart';

class Modal extends StatelessWidget {
  final String message;
  final FilledButton button;

  const Modal({super.key, required this.message, required this.button});

  @override
Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        button,
      ],
    );
  }
}
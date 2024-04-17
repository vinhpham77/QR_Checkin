import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/router.dart';
import '../config/theme.dart';

class MainQRButton extends StatelessWidget {
  const MainQRButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        child: InkWell(
          onTap: () {
            context.push(RouteName.scanner);
          },
          child: Container(
            padding: const EdgeInsets.all(11.0),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: AppColors.backgroundLight,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

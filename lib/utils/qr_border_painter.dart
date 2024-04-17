import 'package:flutter/material.dart';

class QRBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.1)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.1, 0)
      ..moveTo(size.width, size.height * 0.1)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.9, 0)
      ..moveTo(0, size.height * 0.9)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..moveTo(size.width, size.height * 0.9)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.9, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
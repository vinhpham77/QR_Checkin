import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final IconData fallBackIcon;

  const CustomImage({
    super.key,
    this.imageUrl,
    required this.size,
    required this.fallBackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl ?? '',
      height: size,
      width: size * 16/9,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Icon(fallBackIcon, size: size, color: Colors.black54);
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallBackIcon, size: size, color: Colors.black54);
      },
    );
  }
}

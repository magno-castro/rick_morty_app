import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  final String? image;
  final BorderRadius? borderRadius;

  const CharacterAvatar({super.key, required this.image, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    const height = 250.0;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        image!,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            alignment: Alignment.center,
            color: Colors.grey[200],
            child: const Icon(Icons.person, size: 72.0),
          );
        },
      ),
    );
  }
}

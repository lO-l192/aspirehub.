import 'package:flutter/material.dart';

class DashModel extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;

  const DashModel({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Container(
          width: 125,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RecipeInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const RecipeInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
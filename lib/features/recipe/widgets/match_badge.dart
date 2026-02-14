import 'package:flutter/material.dart';

class MatchBadge extends StatelessWidget {
  final double percent;

  const MatchBadge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF13ec5b),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${percent.toInt()}% Match",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
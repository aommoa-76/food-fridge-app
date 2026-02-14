import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final int step;
  final String text;

  const StepTile({super.key, required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13ec5b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: primaryGreen,
                child: Text(
                  "$step",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 2,
                height: 50,
                color: primaryGreen.withOpacity(0.3),
              )
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
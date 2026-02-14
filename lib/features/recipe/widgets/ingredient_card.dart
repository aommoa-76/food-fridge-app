import 'package:flutter/material.dart';
class IngredientCard extends StatelessWidget {
  final String ingredient;
  final bool inFridge;

  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.inFridge,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13ec5b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4)
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.restaurant, color: primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ingredient,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            // 🔹 ถ้ามี → ✔️ ถ้าไม่มี → ❌
            Icon(
              inFridge ? Icons.check_circle : Icons.cancel,
              color: inFridge ? primaryGreen : Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
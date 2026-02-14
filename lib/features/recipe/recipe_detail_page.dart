import 'package:flutter/material.dart';
import '../../core/models/recipe.dart';

import 'widgets/recipe_hero_image.dart';
import 'widgets/recipe_info_cards.dart';
import 'widgets/ingredient_card.dart';
import 'widgets/step_tile.dart';
import 'utils/launch_youtube.dart';
import '../../core/mock/mock_user_ingredients.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});
  bool isInFridge(String recipeIngredient) {
    final r = recipeIngredient.toLowerCase();

    for (final i in mockUserIngredients) {
      final m = i.name.toLowerCase();

      // ✔️ match แบบ contains ทั้งสองทาง
      if (r.contains(m) || m.contains(r)) {
        return i.inFridge;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),

      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Cooking Guide",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HERO
            RecipeHeroImage(recipe: recipe),

            /// TITLE
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                recipe.title,
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),

            /// INFO CARDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  RecipeInfoCard(
                    title: "YouTube",
                    value: "Watch Video",
                    onTap: () => openYoutube(recipe.youtubeUrl),
                  ),
                  RecipeInfoCard(
                    title: "Area",
                    value: recipe.area,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// INGREDIENTS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // หา ingredient ว่าที่มี ตรงตาม recipe ไหม ถ้ามี → ✔️ ถ้าไม่มี → ❌ 
            // ปัญหาคือ มัน ขึ้นไม่มีหมด
            ...recipe.ingredients.map((e) {
              return IngredientCard(
                ingredient: e,
                inFridge: isInFridge(e),
              );
            }),

            const SizedBox(height: 32),

            /// STEPS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cooking Steps",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            ...recipe.steps.asMap().entries.map(
              (entry) => StepTile(
                step: entry.key + 1,
                text: entry.value,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/mock/mock_recipes.dart';
import '../../core/mock/mock_user_ingredients.dart';
import '../../core/utils/recipe_matcher.dart';
import '../../core/models/recipe.dart';
import '../../core/state/favorites_state.dart';
import '../recipe/recipe_card.dart';
import '../recipe/recipe_detail_page.dart';

class MatchMenuPage extends StatefulWidget {
  const MatchMenuPage({super.key});

  @override
  State<MatchMenuPage> createState() => _MatchMenuPageState();
}

class _MatchMenuPageState extends State<MatchMenuPage> {
  late List<Recipe> matchedRecipes;

  final FavoritesState _favoritesState =
    FavoritesState.instance;

  @override
  void initState() {
    super.initState();

    matchedRecipes =
        matchRecipes(mockRecipeList, mockUserIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Results')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: matchedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = matchedRecipes[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecipeCard(
              title: recipe.title,
              description: recipe.description,
              imageUrl: recipe.imageUrl,
              matchPercent: recipe.matchPercent,

              /// ⭐ ใช้ FavoritesState
              isFavorite:
                  _favoritesState.isFavorite(recipe.idMeal),

              onFavoriteToggle: () {
                setState(() {
                  _favoritesState.toggleFavorite(recipe);
                });
              },

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RecipeDetailPage(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
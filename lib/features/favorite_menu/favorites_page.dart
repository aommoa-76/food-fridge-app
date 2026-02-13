import 'package:flutter/material.dart';
import '../../core/state/favorites_state.dart';
import '../recipe/recipe_card.dart';
import '../recipe/recipe_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}
class _FavoritesPageState extends State<FavoritesPage> {
  static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  /// ⭐ ใช้ instance เดียวกับ MatchMenuPage
  final FavoritesState _favoritesState = FavoritesState.instance;

  @override
  Widget build(BuildContext context) {
    final favorites = _favoritesState.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Favorite Menu"),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite recipes yet ❤️",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RecipeCard(
                    title: recipe.title,
                    description: recipe.description,
                    imageUrl: recipe.imageUrl,
                    matchPercent: recipe.matchPercent,// ⭐ เพิ่ม

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
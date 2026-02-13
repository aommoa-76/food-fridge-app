import 'package:flutter/material.dart';
import '../../core/models/recipe.dart';
import '../../core/state/favorites_state.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() =>
      _RecipeDetailPageState();
}

class _RecipeDetailPageState
    extends State<RecipeDetailPage> {
  final FavoritesState _favoritesState =
      FavoritesState.instance;

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    final isFav =
        _favoritesState.isFavorite(recipe.idMeal);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cooking Guide"),
        actions: [
          IconButton(
            icon: Icon(
              isFav
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _favoritesState
                    .toggleFavorite(recipe);
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /// 🖼️ Hero Image
            Image.network(
              recipe.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding:
                  const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Ingredients
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  ...recipe.ingredients
                      .map(
                        (e) => Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                                  bottom: 8),
                          child: Text("• $e"),
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 24),

                  /// Steps
                  const Text(
                    "Cooking Steps",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  ...recipe.steps
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                                  bottom: 12),
                          child: Text(
                              "${entry.key + 1}. ${entry.value}"),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
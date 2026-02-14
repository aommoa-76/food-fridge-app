import 'package:flutter/material.dart';
import '../../../core/models/recipe.dart';
import '../../../core/state/favorites_state.dart';
import 'match_badge.dart';

class RecipeHeroImage extends StatefulWidget {
  final Recipe recipe;

  const RecipeHeroImage({super.key, required this.recipe});

  @override
  State<RecipeHeroImage> createState() => _RecipeHeroImageState();
}

class _RecipeHeroImageState extends State<RecipeHeroImage> {
  final FavoritesState _favoritesState = FavoritesState.instance;

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final isFav = _favoritesState.isFavorite(recipe.idMeal);

    return Stack(
      children: [
        Image.network(
          recipe.imageUrl,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          bottom: 16,
          left: 16,
          child: MatchBadge(percent: recipe.matchPercent),
        ),

        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _favoritesState.toggleFavorite(recipe);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
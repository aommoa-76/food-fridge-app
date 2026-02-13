import '../models/recipe.dart';

class FavoritesMock {
  static final List<Recipe> favorites = [];

  static void toggleFavorite(Recipe recipe) {
    final index =
        favorites.indexWhere((r) => r.idMeal == recipe.idMeal);

    if (index >= 0) {
      favorites.removeAt(index);

    } else {
      favorites.add(recipe);

    }
  }
}
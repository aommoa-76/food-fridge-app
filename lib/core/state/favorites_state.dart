import '../models/recipe.dart';

class FavoritesState {
  FavoritesState._internal();

  static final FavoritesState instance = FavoritesState._internal();

  final List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  bool isFavorite(String recipeId) {
    return _favorites.any((r) => r.idMeal == recipeId);
  }

  void toggleFavorite(Recipe recipe) {
    final index =
        _favorites.indexWhere((r) => r.idMeal == recipe.idMeal);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(recipe);
    }
  }
}
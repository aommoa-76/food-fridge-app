import '../models/ingredient.dart';

final List<Ingredient> mockUserIngredients = [
  Ingredient(
    name: 'Egg',
    addedDate: DateTime.now().subtract(const Duration(days: 2)),
    expiryDate: DateTime.now().add(const Duration(days: 5)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Milk',
    addedDate: DateTime.now().subtract(const Duration(days: 4)),
    expiryDate: DateTime.now().add(const Duration(days: 2)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Onion',
    addedDate: DateTime.now().subtract(const Duration(days: 7)),
    expiryDate: DateTime.now().add(const Duration(days: 10)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Garlic',
    addedDate: DateTime.now().subtract(const Duration(days: 3)),
    expiryDate: DateTime.now().add(const Duration(days: 20)),
    inFridge: true,
  ),

  /// ❌ อันนี้ไม่อยู่ในตู้เย็น → จะไม่ถูก match
  Ingredient(
    name: 'Flour',
    addedDate: DateTime.now().subtract(const Duration(days: 20)),
    expiryDate: DateTime.now().add(const Duration(days: 200)),
    inFridge: false,
  ),
];

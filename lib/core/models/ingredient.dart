class Ingredient {
  final String name;
  final String category;
  final DateTime addedDate;
  final DateTime expiryDate;
  final bool inFridge; 

  Ingredient({
    required this.name,
    required this.category,
    required this.addedDate,
    required this.expiryDate,
    this.inFridge = false,
  });
}

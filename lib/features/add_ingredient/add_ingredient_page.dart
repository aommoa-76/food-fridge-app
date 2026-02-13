import 'package:flutter/material.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  static const primaryGreen = Color(0xFF60EB73);

  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = "All";

  final categories = ["All", "Drink", "Protein", "Vegetable", "Fruit", "Other"];

  final ingredients = [
    {"name": "Milk", "category": "Drink", "Date": 7},
    {"name": "Juice", "category": "Drink"},
    {"name": "Chicken", "category": "Protein", "Date": 3},
    {"name": "Beef", "category": "Protein"},
    {"name": "Spinach", "category": "Vegetable", "Date": 5},
    {"name": "Carrot", "category": "Vegetable"},
    {"name": "Apple", "category": "Fruit", "Date": 10},
    {"name": "Banana", "category": "Fruit"},
    {"name": "Other", "category": "Other"},
  ];

  List get filteredIngredients {
    return ingredients.where((item) {
      final matchCategory =
          selectedCategory == "All" || item["category"] == selectedCategory;

      final matchSearch = (item["name"] as String)
        .toLowerCase()
        .contains(_searchController.text.toLowerCase());


      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ingredient"),
        backgroundColor: primaryGreen,
      ),
      body: Column(
        children: [
          _buildSearch(),
          _buildCategories(),
          Expanded(child: _buildIngredientList()),
        ],
      ),
    );
  }

  // 🔍 SEARCH
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Search ingredient...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🏷️ CATEGORY CHIPS
  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final selected = cat == selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(cat),
              selected: selected,
              onSelected: (_) {
                setState(() => selectedCategory = cat);
              },
              selectedColor: primaryGreen,
            ),
          );
        },
      ),
    );
  }

  // 🧊 INGREDIENT LIST
  Widget _buildIngredientList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredIngredients.length,
      itemBuilder: (context, i) {
        final item = filteredIngredients[i];

        return Card(
          color: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.kitchen, color: Colors.green),
            title: Text(item["name"]),
            onTap: () => _showIngredientBottomSheet(item),
          ),
        );
      },
    );
  }

  // 🍳 OPEN BOTTOM SHEET
  void _showIngredientBottomSheet(Map item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _IngredientDetailSheet(item: item),
    );
  }
}

class _IngredientDetailSheet extends StatefulWidget {
  final Map item;

  const _IngredientDetailSheet({required this.item});

  @override
  State<_IngredientDetailSheet> createState() =>
      _IngredientDetailSheetState();
}

class _IngredientDetailSheetState extends State<_IngredientDetailSheet> {
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();

    // ⭐ AUTO CALCULATE IF HAS Date
    if (widget.item.containsKey("Date")) {
      final days = widget.item["Date"] as int;
      expiryDate = DateTime.now().add(Duration(days: days));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Wrap(
        children: [
          Text(
            widget.item["name"],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // 📅 Expiry picker
          ListTile(
            title: const Text("Expiry date"),
            subtitle: Text(
              expiryDate == null
                  ? "Select date"
                  : expiryDate.toString().split(" ")[0],
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),

          // ⭐ hint if auto
          if (widget.item.containsKey("Date"))
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Auto calculated from shelf life (editable)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF60EB73),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
            ),
            onPressed: () {
              // TODO: save to fridge database
              Navigator.pop(context);
            },
            child: const Text("Add to Fridge"),
          ),
        ],
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: expiryDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() => expiryDate = picked);
    }
  }
}

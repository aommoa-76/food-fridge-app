import 'package:flutter/material.dart';
import '../add_ingredient/add_ingredient_page.dart';
import '../randomMenu/randomMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 🌿 สีหลักของแอป
  static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("My Fridge"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {},
        //   )
        // ],
      ),

      body: Column(
        children: [
          
          const SizedBox(height: 10),
          
          // เรียกใช้ปุ่มที่เราสร้างไว้
          _buildRouletteButton(context),
          
          // const SizedBox(height: 20),
          _buildSearch(),
          _buildCategories(),
          Expanded(child: _buildGrid()),
        ],
      ),

      // ➕ Floating Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddIngredientPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      
    );
  }

  // 🔍 Search
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search ingredients...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.green.shade50, // 💚 ช่องค้นหาเขียวอ่อน
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🏷️ Categories
  Widget _buildCategories() {
    final categories = [
      "All",
      "Vegetables",
      "Dairy",
      "Proteins",
      "Fruits"
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Chip(
            backgroundColor:
                i == 0 ? primaryGreen : Colors.green.shade100,
            label: Text(
              categories[i],
              style: TextStyle(
                color: i == 0 ? Colors.black : Colors.green.shade900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🧊 Grid Items
  Widget _buildGrid() {
    final items = [
      {"name": "Carrots", "info": "Fresh • 800g"},
      {"name": "Milk", "info": "Use soon • 1L"},
      {"name": "Spinach", "info": "Expiring • 200g"},
      {"name": "Chicken", "info": "Fresh • 500g"},
      {"name": "Eggs", "info": "Fresh • 6 left"},
      {"name": "Yogurt", "info": "Fresh • 1 cup"},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),

          /// ⭐ กดแล้วไปหน้า Add Ingredient
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddIngredientPage(),
              ),
            );
          },

          child: Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Icon(
                      Icons.kitchen,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    items[i]["name"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    items[i]["info"]!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🎢 4. Roulette Button (Original Function) - เพิ่มความพรีเมียมด้วย Gradient
  Widget _buildRouletteButton(BuildContext context) {
    // ดึงขนาดหน้าจอ
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth - 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 103, 240, 122), Color.fromARGB(255, 117, 255, 135)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodRoulettePage())),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mystery Dinner?", 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Let destiny choose your menu", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

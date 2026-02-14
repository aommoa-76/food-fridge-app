import 'package:flutter/material.dart';
import '../add_ingredient/add_ingredient_page.dart';
import '../randomMenu/randomMenu.dart';

import '../../core/models/ingredient.dart';
import "../../core/mock/mock_user_ingredients.dart";  

import '../../app/logout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = "All";

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              // 🔥 เรียกใช้ไฟล์กลาง ง่ายและสะอาด
              onPressed: () => AuthService.logout(context), 
              
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 69, 148, 79),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) => states.contains(WidgetState.pressed) 
                      ? Colors.green.withOpacity(0.2) 
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          
          const SizedBox(height: 10),
          
          // เรียกใช้ปุ่มที่เราสร้างไว้
          _buildRouletteButton(context),
          
          const SizedBox(height: 10),
          _buildSearch(context),

          const SizedBox(height: 5),
          _buildCategories(context),
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
  Widget _buildSearch(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width - 30;

    return Center(
      child: SizedBox(
        width: boxWidth,
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search ingredients...",
            prefixIcon: const Icon(Icons.search, color: Colors.green),
            filled: true,
            fillColor: Colors.green.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // 🏷️ Categories
  Widget _buildCategories(BuildContext context) {
    final categories = [
      "All",
      "Protein",
      "Carbohydrate",
      "Vegetables",
      "Fruit",
      "Drink",
      "Other"
    ];

    double boxWidth = MediaQuery.of(context).size.width - 20;

    return Center(
      child: SizedBox(
        height: 60,
        width: boxWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, i) {
            final categoryName = categories[i];
            final bool isSelected = _selectedCategory == categoryName;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(categoryName),
                selected: isSelected,
                selectedColor: primaryGreen,
                backgroundColor: Colors.green.shade50,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.green.shade900,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                // 4. เมื่อคลิกให้เปลี่ยนค่า _selectedCategory และสั่งวาดหน้าจอใหม่
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategory = categoryName;
                  });
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide(color: isSelected ? Colors.transparent : Colors.green.shade100),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🧊 Grid Items
  Widget _buildGrid() {
    // 5. Logic การกรองข้อมูล
    final List<Ingredient> allItems = mockUserIngredients;
    
    // ถ้าเลือก "All" ให้เอามาหมด แต่ถ้าไม่ใช่ ให้กรองเอาเฉพาะ Category ที่ตรงกัน
    final List<Ingredient> filteredItems = _selectedCategory == "All"
        ? allItems
        : allItems.where((item) => item.category == _selectedCategory).toList();

    // กรณีไม่มีข้อมูลในหมวดหมู่นั้นๆ
    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text("No ingredients in $_selectedCategory", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, i) {
        final item = filteredItems[i];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddIngredientPage())),
          child: Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: Icon(Icons.kitchen, size: 40, color: Colors.green)),
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "Expired: ${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}",
                    style: const TextStyle(fontSize: 11),
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

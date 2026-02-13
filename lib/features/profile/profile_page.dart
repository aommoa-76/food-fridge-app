import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Profile"),
        centerTitle: true,
        // leading: const Icon(Icons.arrow_back_ios),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {},
        //   )
        // ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStats(),
            _sectionTitle("Dietary Type"),
            _buildDietary(),
            _sectionTitle("Allergies"),
            _buildAllergies(),
            const SizedBox(height: 20),
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  // 👤 Profile Header
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: primaryGreen.withOpacity(0.2),
            child: const Icon(Icons.person, size: 60),
          ),
          const SizedBox(height: 12),
          const Text(
            "Alex Johnson",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Passionate about healthy cooking",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 📊 Stats
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(child: _statCard(Icons.restaurant, "54", "Recipes Cooked")),
          const SizedBox(width: 10),
          Expanded(child: _statCard(Icons.inventory_2, "120", "Ingredients")),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String number, String label) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, color: primaryGreen, size: 32),
            const SizedBox(height: 8),
            Text(number,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // 🧾 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Edit", style: TextStyle(color: primaryGreen)),
        ],
      ),
    );
  }

  // 🥗 Dietary
  Widget _buildDietary() {
    final items = ["Vegetarian", "Halal", "Vegan"];

    return Wrap(
      spacing: 8,
      children: items
          .map((e) => Chip(
                backgroundColor: Colors.green.shade100,
                label: Text(e),
              ))
          .toList(),
    );
  }

  // ⚠️ Allergies
  Widget _buildAllergies() {
    final items = ["Peanuts", "Shellfish"];

    return Wrap(
      spacing: 8,
      children: items
          .map((e) => Chip(
                backgroundColor: Colors.red.shade100,
                label: Text(e),
              ))
          .toList(),
    );
  }

  // 📋 Menu
  Widget _buildMenu() {
    return Column(
      children: const [
        ListTile(
          leading: Icon(Icons.kitchen),
          title: Text("My Virtual Fridge"),
          trailing: Icon(Icons.chevron_right),
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Favorite Recipes"),
          trailing: Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

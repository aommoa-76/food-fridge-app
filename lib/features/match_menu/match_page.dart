import 'package:flutter/material.dart';

class MatchMenuPage extends StatelessWidget {
  const MatchMenuPage({super.key});
  static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Match Results"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          MatchCard(
            title: "Creamy Spinach Chicken",
            match: "100% Match",
            time: "20 mins",
            description: "Uses Chicken, Spinach, Onion",
            image:
                "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          ),
          MatchCard(
            title: "Balsamic Onion Chicken",
            match: "90% Match",
            time: "15 mins",
            description: "Missing: Balsamic Vinegar",
            image:
                "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          ),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String title;
  final String match;
  final String time;
  final String description;
  final String image;

  const MatchCard({
    super.key,
    required this.title,
    required this.match,
    required this.time,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(image,
                    height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(match,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

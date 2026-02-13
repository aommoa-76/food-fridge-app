import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
    static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text("Favorite Menu"),
        centerTitle: true,
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 12),
        //     child: Icon(Icons.more_horiz),
        //   )
        // ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FavoriteCard(
            title: "Creamy Avocado Pasta",
            time: "15 mins",
            description:
                "A healthy and quick weeknight dinner option that uses only 5 ingredients.",
            imageUrl:
                "https://images.unsplash.com/photo-1525755662778-989d0524087e",
          ),

          SizedBox(height: 16),

          FavoriteCard(
            title: "Spicy Honey Salmon",
            time: "25 mins",
            description:
                "Perfectly glazed salmon with a spicy kick and caramelised edges.",
            imageUrl:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288",
          ),

          SizedBox(height: 16),

          FavoriteCard(
            title: "Quinoa Rainbow Salad",
            time: "10 mins",
            description:
                "A colorful salad packed with nutrients and a zippy lemon vinaigrette.",
            imageUrl:
                "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
          ),
        ],
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final String imageUrl;

  const FavoriteCard({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // ❤️ Favorite icon
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("View Recipe"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

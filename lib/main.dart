import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodFridge',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 219, 222, 219)),
        useMaterial3: true,
      ),

      home: const HomePage(), // หน้าแรกของแอป
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodFridge'),
      ),
      body: const Center(
        child: Text(
          'Welcome to FoodFridge',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'app/main_navigation.dart';   // ⭐ import ตัว nav

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Fridge',


      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),



      // ⭐⭐ เปลี่ยนตรงนี้ ⭐⭐
      home: const MainNavigation(),
    );
  }
}

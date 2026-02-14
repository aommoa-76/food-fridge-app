import 'package:flutter/material.dart';
import 'package:foodfridge_app/features/auth/login.dart';
import 'app/main_navigation.dart'; 
import 'core/database_helper.dart';

import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';   

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ฟังก์ชันเช็คสถานะจาก SQLite
  Future<bool> _isLoggedIn() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> users = await db.query('users');
    return users.isNotEmpty; // ถ้าไม่ว่างแสดงว่าล็อกอินอยู่
  }

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
      // ⭐ ใช้ FutureBuilder เพื่อเลือกหน้าแรก
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          // ระหว่างที่รอกำลังโหลดข้อมูลจาก SQLite
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          }
          
          // ถ้าเช็คเสร็จแล้ว
          if (snapshot.data == true) {
            return const MainNavigation(); // มีข้อมูลผู้ใช้ -> ไปหน้าหลัก
          } else {
            return const LoginPage(); // ไม่มีข้อมูล -> ไปหน้า Login
          }
        },
      ),
    );
  }
}
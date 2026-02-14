import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../features/auth/login.dart'; // เช็ค Path ให้ตรงกับโปรเจกต์คุณ

class AuthService {
  // สร้างฟังก์ชัน static เพื่อให้เรียกใช้ง่ายโดยไม่ต้องสร้าง Object ใหม่
  static Future<void> logout(BuildContext context) async {
    try {
      // 1. Logout จาก Firebase
      await FirebaseAuth.instance.signOut();

      // 2. Logout จาก Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // 3. นำผู้ใช้กลับไปหน้า Login และล้าง Stack
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );

        // แสดงแจ้งเตือน
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ออกจากระบบสำเร็จ'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("Logout Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }
}
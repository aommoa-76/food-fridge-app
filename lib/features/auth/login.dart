import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/database_helper.dart';         
import '../../core/models/user.dart';             
import 'signup.dart';
import 'package:flutter/foundation.dart';
import '../../app/main_navigation.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  // สำหรับ Web: จำเป็นต้องใส่ clientId ที่ได้จาก Google Cloud Console
  clientId: kIsWeb 
    ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' 
    : null,
  // สำหรับ Android/iOS: ปกติจะอ่านค่าจากไฟล์ google-services.json / GoogleService-Info.plist โดยอัตโนมัติ
);

  // Logic: Login ด้วย Email + SQLite
  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMsg('กรุณากรอกข้อมูลให้ครบ');
      return;
    }

    // ไปถาม SQLite ว่ามี user นี้ไหม
    final user = await DatabaseHelper.instance.getUserByEmail(email);

    if (user != null && user.password == password) {
      _showMsg('เข้าสู่ระบบสำเร็จ!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      _showMsg('Email หรือ Password ไม่ถูกต้อง');
    }
  }

  // Logic: Google Login + SQLite
  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        User newUser = User(
          id: googleUser.id,
          name: googleUser.displayName ?? '',
          email: googleUser.email,
          password: null,
          provider: 'google',
        );

        // เช็คก่อนว่าไม่ใช่ Web ถึงจะบันทึกลง SQLite
        if (!kIsWeb) {
          await DatabaseHelper.instance.saveUser(newUser);
        } else {
          // บน Web อาจจะใช้ LocalStorage แทน หรือแค่ปล่อยผ่านไปหน้า Home เลย
          print('Running on Web: Skip SQLite save');
        }

        _showMsg('เข้าสู่ระบบด้วย Google สำเร็จ!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } catch (e) {
      _showMsg('เกิดข้อผิดพลาด: $e');
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // กันหน้าจอค้างเวลาคีย์บอร์ดเด้ง
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Image.asset('assets/login_food.png', height: 120),
                const SizedBox(height: 40),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60EB73),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 15),

                /// Google Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    icon: const Icon(Icons.login, color: Colors.red), // หรือใส่รูป logo google
                    label: const Text('Sign in with Google'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                      child: const Text("Sign up", style: TextStyle(color: Color(0xFF60EB73), fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
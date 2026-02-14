// features/auth/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import '../../app/main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key}); // ตัด clientId ออก

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: "641139638317-j71upcpeadp7lt7hss9a9hs60ri5401u.apps.googleusercontent.com"), // ปล่อยว่างไว้ หรือใส่ "" 
            ],
            // ... ส่วนหัว UI ตามเดิม ...
          );
        }
        return const MainNavigation();
      },
    );
  }
}
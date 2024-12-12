import 'package:flutter/material.dart';
import 'package:pks_3/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pks_3/pages/login_page.dart';
import 'package:pks_3/api_service.dart'; // Импортируйте ApiService

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session; //  Упрощенное получение session
        if (session != null) {
          final apiService = ApiService(); // Создайте экземпляр ApiService здесь
          return ProfilePage(apiService: apiService); // Передайте apiService в ProfilePage
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
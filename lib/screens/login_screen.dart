import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  Future<void> _loginWithEmailPassword() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wpisz email i hasło.')),
      );
      return;
    }
    try {
      final success = await AuthService.login(email, password);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(currentUser: email),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd logowania: $e')),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final userCredential = await AuthService.signInWithGoogle();
      final user = userCredential.user;
      if (user != null) {
        final userEmail = user.email ?? 'Użytkownik Google';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(currentUser: userEmail),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd logowania przez Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Hasło'),
              obscureText: true,
            ),
            const SizedBox(height: 32),

            // Logowanie email/hasło
            ElevatedButton(
              onPressed: _loginWithEmailPassword,
              child: const Text('Zaloguj przez Email/Hasło'),
            ),

            const SizedBox(height: 16),

            // Logowanie przez Google
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Zaloguj przez Google'),
              onPressed: _loginWithGoogle,
            ),

            const SizedBox(height: 16),

            // Link do rejestracji
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Nie masz konta? Zarejestruj się'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
      backgroundColor: Colors.grey[900],  // Ciemne tło
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Logowanie'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo2.png',
              width: 350,
              height: 350,
              fit: BoxFit.contain,
            ),


            // Pole: Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.yellow),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellow),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pole: Hasło
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _passCtrl,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Hasło',
                  labelStyle: const TextStyle(color: Colors.yellow),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellow),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Przycisk: Logowanie email/hasło
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loginWithEmailPassword,
              child: const Text('Zaloguj przez Email/Hasło'),
            ),

            const SizedBox(height: 16),

            // Przycisk: Logowanie przez Google
            SignInButton(
              Buttons.Google,
              text: "Zaloguj przez Google",
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
              child: const Text(
                'Nie masz konta? Zarejestruj się',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

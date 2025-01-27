import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wprowadź login i hasło.')),
      );
      return;
    }

    try {
      final isLoggedIn = await AuthService.login(login, password);
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(currentUser: login)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Niepoprawny login lub hasło.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd logowania: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Górny pasek nawigacji (można usunąć, jeśli wolisz pełnoekranowe logowanie)
      appBar: AppBar(
        title: Text('Logowanie'),
      ),
      // Dodanie SingleChildScrollView ułatwia przewijanie, gdy ekran się zapełni
      body: SingleChildScrollView(
        child: Container(
          // Gradient w tle
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.shade200,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // Rozciągamy Container na całą wysokość ekranu
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          // Center – karta zostanie wyśrodkowana
          child: Center(
            child: Card(
              // Nadajemy białe tło, zaokrąglone rogi i cień
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8, // cień pod kartą
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                // Kolumna z polami, przyciskiem, itp.
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nagłówek karty
                    Text(
                      'Witaj ponownie!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Zaloguj się, aby kontynuować',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 32),

                    // Pola tekstowe
                    TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        labelText: 'Login',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Hasło',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
                    // Przycisk logowania
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Zaloguj się'),
                      ),
                    ),

                    SizedBox(height: 16),
                    // Link do ekranu rejestracji
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text('Nie masz konta? Zarejestruj się'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

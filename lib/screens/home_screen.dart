import 'package:flutter/material.dart';
import 'package:event_planner/services/auth_service.dart';
import 'add_event_screen.dart';
import 'view_events_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String currentUser;

  const HomeScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ciemne tło, tak jak w login/register
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Strona Główna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Wylogowanie
              await AuthService.signOut();
              // Powrót do ekranu logowania
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      // Układ: wyśrodkowana kolumna
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
             Image.asset(
              'assets/images/logo2.png',
               width: 350,
               height: 350,
               fit: BoxFit.contain,),
             const SizedBox(height: 24),

            Text(
              'Witaj, $currentUser!',
              style: const TextStyle(
                color: Colors.yellow,         // żółty akcent
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wybierz co chcesz zrobić:',
              style: TextStyle(
                color: Colors.white70,       // jasne litery na ciemnym tle
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            // Przycisk: Dodaj Wydarzenie
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Dodaj Wydarzenie'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEventScreen(currentUser: currentUser),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Przycisk: Przeglądaj Wydarzenia
            ElevatedButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Przeglądaj Wydarzenia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewEventsScreen(currentUser: currentUser),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

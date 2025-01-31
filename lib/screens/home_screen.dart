import 'package:flutter/material.dart';
import 'add_event_screen.dart';
import 'view_events_screen.dart';
import 'login_screen.dart';
import 'package:event_planner/services/auth_service.dart';


class HomeScreen extends StatelessWidget {
  final String currentUser;

  const HomeScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strona Główna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Wylogowanie z Firebase
              await AuthService.signOut();
              // Przekierowanie do ekranu logowania
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // Tło – delikatny gradient
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.shade50,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Center(
            // Karta (Card) wyśrodkowana
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8, // cień pod kartą
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nagłówek powitalny (opcjonalnie)
                    Text(
                      'Witaj, $currentUser!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wybierz co chcesz zrobić',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Przycisk: Dodaj Wydarzenie
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Dodaj Wydarzenie'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
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
            ),
          ),
        ),
      ),
    );
  }
}

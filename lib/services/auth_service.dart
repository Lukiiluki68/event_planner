import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'users';

  /// Rejestracja użytkownika
  static Future<void> register(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_usersKey) ?? [];

    // Sprawdź, czy login już istnieje
    for (String user in users) {
      final parts = user.split('|');
      if (parts[0] == login) {
        throw Exception('Użytkownik o podanym loginie już istnieje.');
      }
    }

    // Dodaj nowego użytkownika w formacie "login|password"
    users.add('$login|$password');
    await prefs.setStringList(_usersKey, users);
  }

  /// Logowanie użytkownika
  static Future<bool> login(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_usersKey) ?? [];

    // Sprawdź, czy login i hasło pasują do istniejącego użytkownika
    for (String user in users) {
      final parts = user.split('|');
      if (parts[0] == login && parts[1] == password) {
        return true; // Użytkownik zalogowany
      }
    }
    return false; // Nie znaleziono użytkownika
  }
}

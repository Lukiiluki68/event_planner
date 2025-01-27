import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  static const String _eventsKey = 'events';

  /// Pobranie listy wydarzeń
  static Future<List<Map<String, dynamic>>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];

    return events.map((event) {
      final parts = event.split('|');

      // Obsługa uczestników (lista jest serializowana jako przecinek-rozdzielona lista)
      final participants = parts.length > 5 ? parts[5].split(',') : [];

      return {
        'title': parts.length > 0 ? parts[0] : 'Brak tytułu',
        'description': parts.length > 1 ? parts[1] : 'Brak opisu',
        'location': parts.length > 2 ? parts[2] : 'Brak lokalizacji',
        'dateTime': parts.length > 3 ? parts[3] : DateTime.now().toIso8601String(),
        'createdBy': parts.length > 4 ? parts[4] : 'Nieznany twórca',
        'participants': participants,
      };
    }).toList();
  }

  /// Dodanie nowego wydarzenia
  static Future<void> addEvent(
      String title,
      String description,
      String location,
      String dateTime,
      String createdBy,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];

    // Pole participants jest puste na początku
    String newEvent = '$title|$description|$location|$dateTime|$createdBy|';
    events.add(newEvent);

    await prefs.setStringList(_eventsKey, events);
  }

  /// Aktualizacja istniejącego wydarzenia
  static Future<void> updateEvent(
      int index,
      String title,
      String description,
      String location,
      String dateTime,
      String createdBy,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];

    String updatedEvent = '$title|$description|$location|$dateTime|$createdBy|';
    events[index] = updatedEvent;

    await prefs.setStringList(_eventsKey, events);
  }

  /// Oznaczenie udziału użytkownika w wydarzeniu
  static Future<void> acceptEvent(int index, String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];

    final parts = events[index].split('|');
    List<String> participants = parts.length > 5 ? parts[5].split(',') : [];

    if (!participants.contains(username)) {
      participants.add(username);
    }

    // Aktualizacja wydarzenia
    parts[5] = participants.join(',');
    events[index] = parts.join('|');

    await prefs.setStringList(_eventsKey, events);
  }

  /// Debugowanie danych zapisanych w SharedPreferences
  static Future<void> debugPrintEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];
    print('Zawartość wydarzeń w SharedPreferences:');
    for (var event in events) {
      print(event);
    }
  }

  /// Usunięcie wydarzenia
  static Future<void> deleteEvent(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList(_eventsKey) ?? [];

    events.removeAt(index);

    await prefs.setStringList(_eventsKey, events);
  }
}

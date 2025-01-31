import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  // Referencja do kolekcji 'events'
  static final CollectionReference _eventsCollection =
  FirebaseFirestore.instance.collection('events');

  /// Pobranie listy wydarzeń z Firestore
  static Future<List<Map<String, dynamic>>> getEvents() async {
    final querySnapshot = await _eventsCollection.get();
    // Konwersja dokumentów na listę map
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Dodajemy docId do mapy, żeby łatwo móc aktualizować/usunąć wydarzenie
      data['docId'] = doc.id;
      return data;
    }).toList();
  }

  /// Dodanie nowego wydarzenia do Firestore
  static Future<void> addEvent(
      String title,
      String description,
      String location,
      String dateTime,
      String createdBy,
      ) async {
    await _eventsCollection.add({
      'title': title,
      'description': description,
      'location': location,
      'dateTime': dateTime,
      'createdBy': createdBy,
      'participants': <String>[], // na start pusta tablica
    });
  }

  /// Aktualizacja istniejącego wydarzenia
  /// Teraz przyjmujemy docId, zamiast 'int index'
  static Future<void> updateEvent(
      String docId,
      String title,
      String description,
      String location,
      String dateTime,
      String createdBy,
      ) async {
    await _eventsCollection.doc(docId).update({
      'title': title,
      'description': description,
      'location': location,
      'dateTime': dateTime,
      'createdBy': createdBy,
      // participants nie nadpisujemy, by zachować aktualną listę
    });
  }

  /// Oznaczenie udziału użytkownika w wydarzeniu
  static Future<void> acceptEvent(String docId, String username) async {
    final docRef = _eventsCollection.doc(docId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Event does not exist!");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final participants = List<String>.from(data['participants'] ?? []);

      if (!participants.contains(username)) {
        participants.add(username);
      }

      // Zapisanie zaktualizowanej listy participants
      transaction.update(docRef, {'participants': participants});
    });
  }

  /// Debugowanie danych - wypisuje w konsoli
  static Future<void> debugPrintEvents() async {
    final querySnapshot = await _eventsCollection.get();
    for (var doc in querySnapshot.docs) {
      print('${doc.id} => ${doc.data()}');
    }
  }

  /// Usunięcie wydarzenia
  static Future<void> deleteEvent(String docId) async {
    await _eventsCollection.doc(docId).delete();
  }
}

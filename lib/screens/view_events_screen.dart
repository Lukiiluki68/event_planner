import 'package:flutter/material.dart';
import '../services/event_service.dart';
import 'edit_event_screen.dart';

class ViewEventsScreen extends StatefulWidget {
  final String currentUser;

  ViewEventsScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _ViewEventsScreenState createState() => _ViewEventsScreenState();
}

class _ViewEventsScreenState extends State<ViewEventsScreen> {
  late Future<List<Map<String, dynamic>>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    EventService.debugPrintEvents(); // Debugowanie danych
    setState(() {
      _eventsFuture = EventService.getEvents();
    });
  }

  void _acceptEvent(int index) async {
    try {
      await EventService.acceptEvent(index, widget.currentUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zapisano Twój udział w wydarzeniu!')),
      );
      _loadEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd podczas zapisywania udziału.')),
      );
    }
  }

  void _deleteEvent(int index) async {
    try {
      await EventService.deleteEvent(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wydarzenie zostało usunięte!')),
      );
      _loadEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wystąpił błąd podczas usuwania wydarzenia.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Przeglądaj Wydarzenia'),
      ),
      // Gradient w tle
      body: Container(
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // W trakcie pobierania wydarzeń
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Obsługa błędów
              return const Center(
                child: Text('Błąd podczas ładowania wydarzeń.'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Brak wydarzeń
              return const Center(
                child: Text('Brak wydarzeń do wyświetlenia.'),
              );
            } else {
              final events = snapshot.data!;
              // Lista wydarzeń
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    // Możesz dostosować odstępy i wygląd karty
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        event['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event['description']),
                          const SizedBox(height: 4),
                          Text('Lokalizacja: ${event['location']}'),
                          Text('Data i czas: ${event['dateTime']}'),
                          Text('Twórca: ${event['createdBy']}'),
                          Text(
                            'Uczestnicy: ${event['participants'].join(', ')}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edycja
                          if (event['createdBy'] == widget.currentUser)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditEventScreen(
                                      index: index,
                                      event: event,
                                    ),
                                  ),
                                ).then((_) => _loadEvents());
                              },
                            ),
                          // Usuwanie
                          if (event['createdBy'] == widget.currentUser)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteEvent(index),
                            ),
                          // Uczestniczenie (jeśli nie jesteś twórcą, a nie uczestniczysz)
                          if (event['createdBy'] != widget.currentUser &&
                              !event['participants'].contains(widget.currentUser))
                            TextButton(
                              onPressed: () => _acceptEvent(index),
                              child: const Text('Weź udział'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

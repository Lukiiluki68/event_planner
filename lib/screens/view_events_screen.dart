import 'package:flutter/material.dart';
import '../services/event_service.dart';
import 'edit_event_screen.dart';

class ViewEventsScreen extends StatefulWidget {
  final String currentUser;

  const ViewEventsScreen({Key? key, required this.currentUser}) : super(key: key);

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
    EventService.debugPrintEvents(); // Debugowanie danych w konsoli
    setState(() {
      _eventsFuture = EventService.getEvents();
    });
  }

  void _acceptEvent(String docId) async {
    try {
      await EventService.acceptEvent(docId, widget.currentUser);
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

  void _deleteEvent(String docId) async {
    try {
      await EventService.deleteEvent(docId);
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
      // Ciemne tło
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Przeglądaj Wydarzenia'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Błąd podczas ładowania wydarzeń.',
                style: TextStyle(color: Colors.yellow),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Brak wydarzeń do wyświetlenia.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final docId = event['docId']; // klucz Firestore
                final participants = List<String>.from(event['participants']);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // ciemna karta
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      event['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow, // żółty akcent w tytule
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          event['description'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lokalizacja: ${event['location']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Data i czas: ${event['dateTime']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Twórca: ${event['createdBy']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Uczestnicy: ${participants.join(', ')}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edycja i usuwanie tylko dla twórcy
                        if (event['createdBy'] == widget.currentUser) ...[
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.yellow),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditEventScreen(
                                    docId: docId,
                                    event: event,
                                  ),
                                ),
                              ).then((_) => _loadEvents());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteEvent(docId),
                          ),
                        ],
                        // Weź udział
                        if (event['createdBy'] != widget.currentUser &&
                            !participants.contains(widget.currentUser))
                          TextButton(
                            onPressed: () => _acceptEvent(docId),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.yellow,
                            ),
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
    );
  }
}

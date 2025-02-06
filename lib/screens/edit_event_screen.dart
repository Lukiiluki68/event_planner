import 'package:flutter/material.dart';
import '../services/event_service.dart';

class EditEventScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> event;

  const EditEventScreen({
    Key? key,
    required this.docId,
    required this.event,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event['title']);
    _descriptionController =
        TextEditingController(text: widget.event['description']);
    _locationController =
        TextEditingController(text: widget.event['location']);
    _selectedDate = DateTime.parse(widget.event['dateTime']);
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
  }

  void _updateEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wypełnij wszystkie pola.')),
      );
      return;
    }

    final updatedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    try {
      await EventService.updateEvent(
        widget.docId,
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _locationController.text.trim(),
        updatedDateTime.toIso8601String(),
        widget.event['createdBy'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wydarzenie zostało zaktualizowane.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd aktualizacji wydarzenia: ${e.toString()}')),
      );
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ciemne tło
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Edytuj Wydarzenie'),
      ),
      // Center + Column, spójny styl z resztą aplikacji
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nagłówek
            const Text(
              'Edytuj Wydarzenie',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Tytuł
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tytuł',
                  labelStyle: const TextStyle(color: Colors.yellow),
                  prefixIcon: const Icon(Icons.title, color: Colors.yellow),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Opis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Opis',
                  labelStyle: const TextStyle(color: Colors.yellow),
                  prefixIcon: const Icon(Icons.description, color: Colors.yellow),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lokalizacja
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Lokalizacja',
                  labelStyle: const TextStyle(color: Colors.yellow),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.yellow),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Zmiana daty
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${_selectedDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _pickDate,
                    child: const Text('Zmień datę'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Zmiana czasu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Czas: ${_selectedTime.format(context)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _pickTime,
                    child: const Text('Zmień czas'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Przycisk aktualizacji wydarzenia
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _updateEvent,
              child: const Text('Zaktualizuj Wydarzenie'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/event_service.dart';

class EditEventScreen extends StatefulWidget {
  final String docId;                // Zamiast int index
  final Map<String, dynamic> event;  // Dane wydarzenia

  EditEventScreen({
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
        widget.docId, // kluczowa zmiana – docId zamiast index
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
      appBar: AppBar(
        title: const Text('Edytuj Wydarzenie'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edytuj Wydarzenie',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Tytuł',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Opis',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Lokalizacja',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Data: ${_selectedDate.toLocal()}'.split(' ')[0],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickDate,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Zmień datę'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Czas: ${_selectedTime.format(context)}',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickTime,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Zmień czas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _updateEvent,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Zaktualizuj Wydarzenie'),
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

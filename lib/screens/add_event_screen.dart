// add event
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _selectedDate = DateTime.now();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      print("🛑 Validation failed");
      return;
    }
    _formKey.currentState!.save();

    print("📤 Sending event: $_title, $_description, $_selectedDate");

    final newEvent = EventModel(
      id: '', // Firestore generates this
      title: _title,
      description: _description,
      date: _selectedDate,
    );

    await EventService().addEvent(newEvent);
    print("✅ Event added");

    Navigator.of(context).pop(); // Go back to previous screen
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              Text(
                "Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

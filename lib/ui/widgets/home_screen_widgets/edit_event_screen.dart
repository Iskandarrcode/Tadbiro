import 'package:exam4/data/models/events_models.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatelessWidget {
  final EventsModels event;

  EditEventScreen({super.key, required this.event});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final eventServices = EventFirebaseServices();

  @override
  Widget build(BuildContext context) {
    _nameController.text = event.name;
    _descriptionController.text = event.description;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style:
                    const ButtonStyle(backgroundColor: WidgetStateColor.transparent),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await eventServices.updateEvent(
                      event.id,
                      _nameController.text,
                      event.time,
                      event.geoPoint,
                      _descriptionController.text,
                      event.imageUrl,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Edit event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

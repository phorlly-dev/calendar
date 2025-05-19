// import 'package:calendar/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:calendar/components/index.dart';
import 'package:calendar/core/dialogs/index.dart';
import 'package:calendar/core/functions/index.dart';
import 'package:calendar/core/models/event.dart';
// import 'package:calendar/core/services/notification_service.dart';
import 'package:calendar/core/services/service.dart';
import 'package:calendar/components/even_form.dart';

class EventService extends Service {
  // final notification = NotificationService();

  // Add a new event
  Future<void> store(Event object) async {
    await create<Event>(
      model: object,
      collection: 'events',
      toMap: (event) => event.toMap(),
    );
  }

  // Update an existing data
  Future<void> update(Event object) async {
    // Update the data in Firestore
    await modify(collection: 'events', docId: object.id, toMap: object.toMap());
  }

  // Get all events
  Future<List<Event>> index() async {
    // Get all events from Firestore
    final snapshot = await readAll<Event>(
      collection: 'events',
      fromMap: (data, docId) => Event.fromMap(data, docId),
    );

    return snapshot;
  }

  // Delete an User by its ID
  Future<void> remove(String id) async {
    await delete(collection: 'events', docId: id);
  }

  //Stream builder for reuseable widget
  stream(BuildContext context) {
    return streamBuilder<Event>(
      collection: 'events',
      fromMap: (data, docId) => Event.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            // if (Funcs.isSameMinute(item.date.toLocal(), DateTime.now())) {
            //   NotisService().show(
            //     id: item.id.hashCode,
            //     title: item.title,
            //     body: 'Scheduled: ${Funcs.dateTimeFormat(item.date)}',
            //   );
            // }

            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                '${Funcs.dateTimeFormat(item.date)}\n ${item.description ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: ActionButtons(
                pressedOnDelete: () {
                  Popup.confirmDelete(
                    context,
                    message: item.title,
                    confirmed: () {
                      Navigator.of(context).pop();
                      remove(item.id);

                      // Optionally refresh the UI or show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted successfully')),
                      );
                    },
                  );
                },
                pressedOnEdit: () {
                  EvenForm.showForm(context, item);
                },
              ),
            );
          },
        );
      },
    );
  }
}

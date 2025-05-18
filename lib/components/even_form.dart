import 'package:calendar/components/index.dart';
import 'package:calendar/core/dialogs/index.dart';
import 'package:calendar/core/messages/index.dart';
import 'package:calendar/core/models/event.dart';
import 'package:calendar/core/services/event_service.dart';
import 'package:flutter/material.dart';

class EvenForm {
  // Function to show the form dialog for adding/editing a user
  static void showForm(BuildContext context, Event? item) {
    final title = TextEditingController(text: item?.title ?? '');
    final description = TextEditingController(text: item?.description ?? '');
    DateTime selectedDate = item?.date ?? DateTime.now();

    // Show the dialog
    Popup.showModal(
      context: context,
      builder: (context, setState) {
        return Controls.form(
          model: item,
          context,
          title: 'Event',
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            Common.showDateTimePicker(
              context,
              label: 'Datetime',
              selected: selectedDate,
              changed: (value) => setState(() => selectedDate = value),
            ),
            TextField(
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
                helperMaxLines: 5,
              ),
            ),
          ],

          // Save button
          onSave: () async {
            if (title.text.isEmpty) {
              Msg.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              final event = Event(
                title: title.text,
                date: selectedDate,
                description: description.text,
                id: '',
              );
              await EventService().store(event);

              // Schedule the notification
              // NotificationService.scheduleNotification(
              //   id: event.title.hashCode,
              //   title: event.title,
              //   body: event.description ?? '',
              //   scheduledDate: event.date,
              // );

              title.clear();
              description.clear();

              if (context.mounted) {
                Navigator.pop(context);
                Msg.message(context, message: 'Created successfully!');
              }
            }
          },

          // Update button
          onUpdate: () async {
            if (title.text.isEmpty) {
              Msg.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              await EventService().update(
                Event(
                  id: item!.id, // assuming Event has an id field
                  title: title.text,
                  date: selectedDate,
                  description: description.text,
                ),
              );

              if (context.mounted) {
                Navigator.pop(context);
                Msg.message(
                  context,
                  message: 'Updated successfully!',
                  bgColor: Colors.green,
                );
              }
            }
          },
        );
      },
    );
  }
}

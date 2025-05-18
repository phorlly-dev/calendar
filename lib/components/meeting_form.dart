import 'package:calendar/components/index.dart';
import 'package:calendar/core/dialogs/index.dart';
import 'package:calendar/core/messages/index.dart';
import 'package:calendar/core/models/meeting.dart';
import 'package:calendar/core/services/meeting_service.dart';
import 'package:flutter/material.dart';

class MeetingForm {
  // Show a form to create or update a meeting
  static void showForm(BuildContext context, {Meeting? model}) {
    final title = TextEditingController(text: model?.eventName);
    DateTime start = model?.from ?? DateTime.now();
    DateTime end = model?.to ?? DateTime.now().add(const Duration(hours: 1));
    bool isAllDay = model?.isAllDay ?? false;
    bool alertNotification =
        model?.alertNotification ?? false; // Get alertNotification state
    DateTime? alertTime = model?.alertTime; // Get alertTime

    // Show the dialog
    Popup.showModal(
      context: context,
      builder: (context, setState) {
        return Controls.form(
          model: model,
          context,
          title: 'Meeting',
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            Common.showDateTimePicker(
              context,
              label: 'From',
              selected: start,
              changed: (value) => setState(() => start = value),
            ),

            Common.showDateTimePicker(
              context,
              label: 'To',
              selected: end,
              changed: (value) => setState(() => end = value),
            ),

            CheckboxListTile(
              value: isAllDay,
              onChanged: (value) => setState(() => isAllDay = value ?? false),
              title: const Text('All Day'),
            ),
            CheckboxListTile(
              // Add checkbox for alert notification
              value: alertNotification,
              onChanged: (value) => setState(() {
                alertNotification = value ?? false;
                if (!alertNotification) {
                  alertTime =
                      null; // Clear alertTime if alertNotification is false
                }
              }),
              title: const Text('Enable Notification'),
            ),
            if (alertNotification) // Show time picker only if alertNotification is true
              Common.showDateTimePicker(
                context,
                label: 'Alert Time',
                selected:
                    alertTime ??
                    DateTime.now(), // Use current time if alertTime is null
                changed: (value) => setState(() => alertTime = value),
              ),
          ],

          // Delete button
          onDelete: () {
            Popup.confirmDelete(
              context,
              message: model!.eventName,
              confirmed: () async {
                await MeetingService().remove(model.id);

                if (context.mounted) {
                  Navigator.pop(context);
                  Msg.message(
                    context,
                    message: 'Deleted successfully!',
                    bgColor: Colors.red,
                  );

                  Navigator.pop(context);
                }
              },
            );
          },

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
              await MeetingService().store(
                Meeting(
                  id: '',
                  eventName: title.text,
                  from: start,
                  to: end,
                  background: Colors.green,
                  isAllDay: isAllDay,
                  alertNotification:
                      alertNotification, // Save alertNotification state
                  alertTime: alertTime, // Save alertTime
                ),
              );

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
              await MeetingService().update(
                Meeting(
                  id: model!.id,
                  eventName: title.text,
                  from: start,
                  to: end,
                  background: Colors.green,
                  isAllDay: isAllDay,
                  alertNotification:
                      alertNotification, // Save alertNotification state
                  alertTime: alertTime, // Save alertTime
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

import 'package:flutter/material.dart';
import 'package:calendar/common/meeting_data_source.dart';
import 'package:calendar/core/models/meeting.dart';
import 'package:calendar/core/services/notification_service.dart';
import 'package:calendar/core/services/service.dart';
import 'package:calendar/components/meeting_form.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingService extends Service {
  late final NotificationService notification;

  MeetingService() {
    NotificationService.init().then((service) {
      notification = service;
    });
  }

  // Fetch all meetings from Firestore
  Future<List<Meeting>> index() async {
    final snapshot = await readAll<Meeting>(
      collection: 'meetings',
      fromMap: (data, docId) => Meeting.fromMap(data, docId),
    );

    return snapshot;
  }

  // Fetch a single meeting by its ID
  Future<void> store(Meeting object) async {
    await create<Meeting>(
      model: object,
      collection: 'meetings',
      toMap: (value) => value.toMap(),
    );

    // Schedule notification if alertNotification is true and alertTime is not null
    if (object.alertNotification && object.alertTime != null) {
      await notification.scheduleNotification(
        id: object.id,
        title: object.eventName,
        scheduledTime: object.alertTime!,
      );
    }
  }

  // Fetch a single meeting by its ID
  Future<void> update(Meeting object) async {
    // Update the data in Firestore
    await modify(
      collection: 'meetings',
      docId: object.id,
      toMap: object.toMap(),
    );

    // Schedule notification if alertNotification is true and alertTime is not null
    if (object.alertNotification && object.alertTime != null) {
      await notification.scheduleNotification(
        id: object.id,
        title: object.eventName,
        scheduledTime: object.alertTime!,
      );
    } else {
      // If alertNotification is false or alertTime is null, cancel any existing notification for this meeting
      await notification.cancelNotification(object.id);
    }
  }

  // Delete a meeting by its ID
  Future<void> remove(String id) async {
    await delete(collection: 'meetings', docId: id);

    // Cancel notification when a meeting is deleted
    await notification.cancelNotification(id);
  }

  // Stream builder for reusable widget
  stream(BuildContext context) {
    return streamBuilder<Meeting>(
      collection: 'meetings',
      fromMap: (data, docId) => Meeting.fromMap(data, docId),
      builder: (context, data) {
        return SfCalendar(
          view: CalendarView.month,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
            CalendarView.schedule,
          ],
          firstDayOfWeek: 1,
          showTodayButton: true,
          allowViewNavigation: true,
          // showWeekNumber: true,
          dataSource: MeetingDataSource(data),
          monthViewSettings: MonthViewSettings(showAgenda: true),
          onTap: (details) {
            if (details.appointments != null &&
                details.appointments!.isNotEmpty) {
              final item = details.appointments!.first as Meeting;
              MeetingForm.showForm(context, model: item);
            }
          },
        );
      },
    );
  }
}

import 'package:calendar/common/event_data_source.dart';
// ignore: unused_import
import 'package:calendar/components/topbar.dart';
import 'package:calendar/core/functions/index.dart';
import 'package:calendar/core/models/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FullCalendar extends StatelessWidget {
  final List<Event> events;

  const FullCalendar({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text("Calendar View"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          child: SfCalendar(
            view: CalendarView.month,
            monthViewSettings: MonthViewSettings(
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            firstDayOfWeek: 1,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
              CalendarView.schedule,
            ],
            dataSource: EventDataSource(events),
            initialSelectedDate: DateTime.now(),
            showDatePickerButton: true,
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null &&
                  details.appointments!.isNotEmpty) {
                final event = details.appointments!.first;

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Event: ${event.title}',
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      event.description!.isEmpty
                          ? 'Date Time: ${Funcs.dateTimeFormat(event.date)}'
                          : 'Date Time: ${Funcs.dateTimeFormat(event.date)} \n Details: ${event.description}',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

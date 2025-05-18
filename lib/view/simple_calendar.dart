import 'package:flutter/material.dart';
import 'package:calendar/core/links/nav_link.dart';
import 'package:calendar/core/services/event_service.dart';
import 'package:calendar/components/even_form.dart';
import 'package:calendar/components/topbar.dart';
import 'package:calendar/components/full_calendar.dart';

class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({super.key});

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  final service = EventService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: service.stream(context)),
            ],
          ),
        ),

        button: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'add_event',
              onPressed: () => EvenForm.showForm(context, null),
              tooltip: 'Add Event',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'view_calendar',
              onPressed: () async {
                final events = await service.index();
                if (context.mounted) {
                  NavLink.next(context, widget: FullCalendar(events: events));
                }
              },
              tooltip: 'View Calendar',
              child: const Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }
}

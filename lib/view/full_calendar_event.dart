import 'package:flutter/material.dart';
import 'package:calendar/core/services/meeting_service.dart';
import 'package:calendar/components/meeting_form.dart';
import 'package:calendar/components/topbar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        content: MeetingService().stream(context),
        button: FloatingActionButton(
          onPressed: () => MeetingForm.showForm(context, model: null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

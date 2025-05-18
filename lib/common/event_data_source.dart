import 'package:calendar/core/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].date;

  @override
  DateTime getEndTime(int index) =>
      appointments![index].date.add(const Duration(hours: 1));

  @override
  String getSubject(int index) => appointments![index].title;

  @override
  String? getNotes(int index) => appointments![index].description;

  @override
  bool isAllDay(int index) => false;
}

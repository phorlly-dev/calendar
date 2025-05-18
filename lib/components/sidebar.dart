import 'package:calendar/components/item.dart';
import 'package:calendar/core/links/nav_link.dart';
import 'package:calendar/view/full_calendar_event.dart';
import 'package:calendar/view/simple_calendar.dart';
import 'package:flutter/material.dart';

class Siderbar extends StatefulWidget {
  final String title;
  final Widget content;
  final Widget? button;

  const Siderbar({
    super.key,
    required this.title,
    required this.content,
    this.button,
  });

  @override
  State<Siderbar> createState() => _SiderbarState();
}

class _SiderbarState extends State<Siderbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('All Features', textAlign: TextAlign.center),
            ),

            Item(
              title: "Simple Calendar",
              icon: Icons.calendar_month,
              tap: () {
                NavLink.next(context, widget: SimpleCalendar());
              },
            ),
            Item(
              title: "Full Calendar",
              icon: Icons.perm_contact_calendar_rounded,
              tap: () {
                NavLink.next(context, widget: CalendarViewPage());
              },
            ),
          ],
        ),
      ),
      body: widget.content,
      floatingActionButton: widget.button,
    );
  }
}

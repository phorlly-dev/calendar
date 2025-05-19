import 'package:calendar/core/functions/notioficatioin.dart';
import 'package:calendar/core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:calendar/components/tabbar.dart';
import 'package:calendar/view/full_calendar_event.dart';
import 'package:calendar/view/simple_calendar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotisService().init();
  Notioficatioin().startEventPolling();

  // Initialize timezone
  // tz.initializeTimeZones();
  // final String localTimeZone = tz.local.name;
  // tz.setLocalLocation(tz.getLocation(localTimeZone));

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // NOTE: Replace with your own app ID from https://www.onesignal.com
  OneSignal.initialize("554a089c-a5ad-4ec6-9741-1063bb2e07e5");
  OneSignal.Notifications.requestPermission(true);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Tabbar(
          title: "Calendar",
          tabs: [
            Tab(text: 'Simple Calendar'),
            Tab(text: 'Full Calendar'),
          ],
          tabViews: [SimpleCalendar(), CalendarViewPage()],
        ),
      ),
    );
  }
}

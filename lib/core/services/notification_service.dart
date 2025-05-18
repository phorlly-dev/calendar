import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:calendar/core/functions/index.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Private named constructor
  NotificationService._();

  // Factory method to initialize and return an instance
  static Future<NotificationService> init() async {
    final service = NotificationService._();
    service.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Request permission (Android)
    await service.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Initialize the plugin
    await service._initializeNotifications();

    return service;
  }

  // Private initialization function
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (payload) { /* Handle taps if needed */ }
    );
  }

  // Schedule or show notification
  Future<void> scheduleNotification({
    required String id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Optional: Show immediately if current time matches
    if (Funcs.isSameMinute(scheduledTime.toLocal(), DateTime.now())) {
      await flutterLocalNotificationsPlugin.show(
        id.hashCode,
        title,
        'Scheduled: ${Funcs.dateTimeFormat(scheduledTime)}',
        notificationDetails,
        payload: 'item x',
      );
    }

    // You can later replace this with zonedSchedule or other time logic
    // await flutterLocalNotificationsPlugin.zonedSchedule(...)
  }

  // Cancel a notification
  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }
}

class NotiSeervice {
  final notisPlugin = FlutterLocalNotificationsPlugin();

  bool isInitialized = false;

  bool get isInited => isInitialized;

  //Init
  Future<void> initNoti() async {
    if (isInitialized) return; //prevent re-init

    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //init android
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //init iOS
    const DarwinInitializationSettings initSettingiOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    //init settings
    const InitializationSettings initSettins = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingiOS,
    );

    //init
    await notisPlugin.initialize(initSettins);

    isInitialized = true;
  }

  //noti detials setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Noti',
        channelDescription: 'Daily Noti channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //show an immadiate noti
  Future<void> showNoti({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) {
    return notisPlugin.show(id, title, body, notificationDetails());
  }

  /*
    Shedule a noti at a specified time (e.g. 11pm)
    - hour (0-23)
    - minute (0-59)
   */

  Future<void> scheduleNoti({
    int id = 0,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    //Get the current date/time in device's local timezone
    final now = tz.TZDateTime.now(tz.local);

    //create a date/time for today at the spicifieed hour/minute
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    //Schedule the noti
    await notisPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(),
      //Android
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancel a notification
  Future<void> cancelAllNoti() async {
    await notisPlugin.cancelAll();
  }
}

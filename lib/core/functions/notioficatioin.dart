import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:calendar/core/functions/index.dart';
import 'package:calendar/core/services/event_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class Notioficatioin {
  final appId = '554a089c-a5ad-4ec6-9741-1063bb2e07e5';
  final apiKey =
      'os_v2_app_kvfarhffvvhmnf2bcbr3wlqh4vujx65i7vkezgupf3glpeaao36jdntexnxppqz4gxu75rnzmxd2mhr3vlufg6dxzy7py64kkatkvzy';

  Future<void> scheduleNotification({
    required String appId,
    required String apiKey,
    required String title,
    required String message,
    required tz.TZDateTime sendTime,
    required String playerId,
  }) async {
    final url = Uri.parse('https://api.onesignal.com/notifications');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $apiKey',
    };

    final body = {
      'app_id': appId,
      'include_player_ids': [playerId], // Target device’s Player ID
      'contents': {'en': message},
      'headings': {'en': title},
      'send_after': sendTime
          .toUtc()
          .toIso8601String(), // UTC time for scheduling
      'delayed_option': 'timezone', // Deliver in user’s local timezone
      'delivery_time_of_day': sendTime.toIso8601String().substring(
        11,
        19,
      ), // e.g., "14:30:00"
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      log('Notification scheduled for $title at $sendTime');
    } else {
      log('Error scheduling notification: ${response.body}');
    }
  }

  Future<void> scheduleEventNotifications() async {
    final playerId = await Funcs().getPlayerId();
    if (playerId == null) {
      log('No Player ID found');
      return;
    }

    final events = await EventService().index();
    final now = DateTime.now();

    for (var event in events) {
      final localEventTime = Funcs().convertToLocalTimezone(event.date);

      if (localEventTime.isAfter(now)) {
        await scheduleNotification(
          appId: appId,
          apiKey: apiKey,
          title: event.title,
          message: event.description ?? '',
          sendTime: localEventTime,
          playerId: playerId,
        );
      }
    }
  }

  void setupNotificationHandlers() {
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = event.notification;
      log('Foreground notification: ${notification.title}');

      // Optionally prevent default display and show custom UI
      // event.preventDefault();
      // Example: Show a dialog
      // showDialog(...);
    });
  }

  void startEventPolling() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final now = tz.TZDateTime.now(tz.local);
      final events = await EventService().index();
      final playerId = await Funcs().getPlayerId();
      if (playerId == null) return;

      for (var event in events) {
        final eventTime = Funcs().convertToLocalTimezone(event.date);
        // Check if current time is within 1 minute of event time
        if (now.difference(eventTime).inMinutes.abs() < 1) {
          await sendImmediateNotification(
            appId: appId,
            apiKey: apiKey,
            title: event.title,
            message: event.description ?? '',
            playerId: playerId,
          );
        }
      }
    });
  }

  Future<void> sendImmediateNotification({
    required String appId,
    required String apiKey,
    required String title,
    required String message,
    required String playerId,
  }) async {
    final url = Uri.parse('https://api.onesignal.com/notifications');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $apiKey',
    };

    final body = {
      'app_id': appId,
      'include_player_ids': [playerId],
      'contents': {'en': message},
      'headings': {'en': title},
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      log('Immediate notification sent: $title');
    } else {
      log('Error sending notification: ${response.body}');
    }
  }
}

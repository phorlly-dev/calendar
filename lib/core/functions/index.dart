import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

class Funcs {
  static final formKey = GlobalKey<FormState>();

  static dateTimeFormat(DateTime value) {
    return DateFormat('dd/MM/yyyy, hh:mm a').format(value);
  }

  static bool isSameMinute(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }

  static String numToStr(int key) {
    return key.toString().padLeft(2, '0');
  }

  Future<String?> getPlayerId() async {
    final status = await OneSignal.User.getOnesignalId();

    return status;
  }

  tz.TZDateTime convertToLocalTimezone(DateTime eventDateTime) {
    final userTimezone = tz.local;

    return tz.TZDateTime.from(eventDateTime, userTimezone);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meeting {
  String id, eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  bool alertNotification;
  DateTime? alertTime;

  Meeting({
    required this.id,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    this.isAllDay = false,
    this.alertNotification = false,
    this.alertTime,
  });

  factory Meeting.fromMap(Map<String, dynamic> data, String docId) {
    return Meeting(
      id: docId,
      eventName: data['eventName'] ?? 'No Title',
      from: (data['from'] as Timestamp).toDate(),
      to: (data['to'] as Timestamp).toDate(),
      background: Color(data['background']),
      isAllDay: data['isAllDay'] ?? false,
      alertNotification: data['alertNotification'] ?? false,
      alertTime: (data['alertTime'] as Timestamp?)?.toDate(),
    );
  }

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meeting(
      id: doc.id,
      eventName: data['eventName'] ?? 'No Title',
      from: (data['from'] as Timestamp).toDate(),
      to: (data['to'] as Timestamp).toDate(),
      background: Color(data['background']),
      isAllDay: data['isAllDay'] ?? false,
      alertNotification: data['alertNotification'] ?? false,
      alertTime: (data['alertTime'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': from,
      'to': to,
      'background': background.toARGB32(),
      'isAllDay': isAllDay,
      'alertNotification': alertNotification,
      'alertTime': alertTime,
    };
  }
}

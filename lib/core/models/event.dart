import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id, title;
  String? description;
  DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.date,
    this.description,
  });

  // Add a factory constructor to create an Event from a Firestore document
  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
    );
  }

  // Add a method to convert an Event to a Firestore document
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'date': date, 'description': description};
  }
}

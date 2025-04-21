import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date), // ✅ Converts DateTime to Firestore Timestamp
    };
  }

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      title: map['title'],
      description: map['description'],
      date: (map['date'] as Timestamp).toDate(), // ✅ Converts back to DateTime
    );
  }
}

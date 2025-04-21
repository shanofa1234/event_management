// event service
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final _eventsRef = FirebaseFirestore.instance.collection('events');

  // 🔁 Fetch all events sorted by date
  Stream<List<EventModel>> getEvents() {
    return _eventsRef.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // 🔁 Add event to Firestore
  Future<void> addEvent(EventModel event) async {
    try {
      await _eventsRef.add(event.toMap());
      print("✅ Event added to Firestore");
    } catch (e) {
      print("❌ Failed to add event: $e");
    }
  }

  // ❌ Delete event by document ID
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsRef.doc(eventId).delete();
      print("🗑️ Event deleted: $eventId");
    } catch (e) {
      print("❌ Failed to delete event: $e");
    }
  }
}

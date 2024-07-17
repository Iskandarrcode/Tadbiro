import 'package:cloud_firestore/cloud_firestore.dart';

class EventFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getEvents() async* {
    yield* _firestore.collection("events").snapshots();
  }

  Future<void> addEvent(
    String eventCreatorId,
    String eventName,
    Timestamp eventTime,
    GeoPoint eventGeoPoint,
    String eventDescription,
    String eventImageUrl,
  ) async {
    print("-------------");
    print(eventName);
    print(eventTime);
    Map<String, dynamic> data = {
      "event-creatorId": eventCreatorId,
      "event-name": eventName,
      "event-time": eventTime,
      "event-geoPoint": eventGeoPoint,
      "event-description": eventDescription,
      "event-imageUrl": eventImageUrl,
    };
    _firestore.collection("events").add(data);
  }
}

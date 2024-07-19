import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class EventFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getEvents() {
    return _firestore.collection("events").snapshots();
  }

  Future<void> addEvent(
    String eventCreatorId,
    String eventName,
    Timestamp eventTime,
    GeoPoint eventGeoPoint,
    String eventDescription,
    String eventImageUrl,
  ) async {
    Map<String, dynamic> data = {
      "event-creatorId": eventCreatorId,
      "event-name": eventName,
      "event-time": eventTime,
      "event-geoPoint": eventGeoPoint,
      "event-description": eventDescription,
      "event-imageUrl": eventImageUrl,
    };
    await _firestore.collection("events").add(data);
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placeMarks[0];
      return "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      print("xxxxxxxxxxxxxxxx");
      print('Error: $e');
      return 'Addres mavjud emas';
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection("events").doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> updateEvent(
    String eventId,
    String eventName,
    Timestamp eventTime,
    GeoPoint eventGeoPoint,
    String eventDescription,
    String eventImageUrl,
  ) async {
    Map<String, dynamic> data = {
      "event-name": eventName,
      "event-time": eventTime,
      "event-geoPoint": eventGeoPoint,
      "event-description": eventDescription,
      "event-imageUrl": eventImageUrl,
    };

    try {
      await _firestore.collection("events").doc(eventId).update(data);
    } catch (e) {
      print('Eventni Edit qilishda Xatolik: $e');
    }
  }
}

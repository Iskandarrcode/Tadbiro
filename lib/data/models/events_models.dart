// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventsModels {
//   final String id;
//   final String creatorId;
//   final String name;
//   final Timestamp time;
//   final GeoPoint geoPoint;
//   final String description;
//   final String imageUrl;

//   EventsModels({
//     required this.id,
//     required this.creatorId,
//     required this.name,
//     required this.time,
//     required this.geoPoint,
//     required this.description,
//     required this.imageUrl,
//   });

//   factory EventsModels.fromQuerySnapshot(QueryDocumentSnapshot query) {
//     return EventsModels(
//       id: query.id,
//       creatorId: query["event-creatorid"],
//       name: query["event-name"],
//       time: query["event-time"],
//       geoPoint: query["event-geoPoint"],
//       description: query["event-description"],
//       imageUrl: query["event-imageUrl"],
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class EventsModels {
  final String id;
  final String creatorId;
  final String name;
  final Timestamp time;
  final GeoPoint geoPoint;
  final String description;
  final String imageUrl;

  EventsModels({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.time,
    required this.geoPoint,
    required this.description,
    required this.imageUrl,
  });

  factory EventsModels.fromQuerySnapshot(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return EventsModels(
      id: query.id,
      creatorId: data['event-creatorid'] ?? '',
      name: data['event-name'] ?? '',
      time: data['event-time'] ?? Timestamp.now(),
      geoPoint: data['event-geoPoint'] ?? const GeoPoint(0, 0),
      description: data['event-description'] ?? '',
      imageUrl: data['event-imageUrl'] ?? '',
    );
  }
}

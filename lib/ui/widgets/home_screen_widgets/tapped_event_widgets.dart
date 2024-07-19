import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/data/models/events_models.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/edit_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class EventTapped extends StatefulWidget {
  final EventsModels events;
  final int index;

  const EventTapped({
    super.key,
    required this.index,
    required this.events,
  });

  @override
  State<EventTapped> createState() => _EventTappedState();
}

class _EventTappedState extends State<EventTapped> {
  final eventServices = EventFirebaseServices();

  late YandexMapController mapController;

  List<MapObject>? polylines;
  Point? myLocation;
  Point? location;

  List<PlacemarkMapObject> makers = [];

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    mapController = controller;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: najotTalim,
          zoom: 20,
        ),
      ),
    );
    setState(() {});
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finished,
  ) async {
    myCurrentLocation = position.target;
  }

  void _goToMyLocation() async {
    if (myLocation != null) {
      await mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLocation!,
            zoom: 20,
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, EventsModels event) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Events'),
          content: const Text("Rostanham manashu Event ni o'chrmoqchimisiz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await eventServices.deleteEvent(widget.events.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.events.name}')),
      );
    }
  }

  void _editEvent(BuildContext context, EventsModels event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(45, 6, 31, 144),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  _editEvent(context, widget.events);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await _confirmDelete(context, widget.events);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventServices.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          if (widget.index >= snapshot.data!.docs.length) {
            return const Center(child: Text('Event not found'));
          }

          var eventDoc = snapshot.data!.docs[widget.index];
          var eventData = EventsModels.fromQuerySnapshot(eventDoc);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(eventData.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    eventData.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 280,
                        child: Text(
                          eventData.time.toDate().toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8),
                      Text(
                        'Participants',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(eventData.imageUrl),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventData.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Tashkilotchi',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tadbir haqida',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventData.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Manzil',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300, // Set a fixed height for the map
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Stack(
                        children: [
                          YandexMap(
                            onMapLongTap: (argument) async {
                              location = argument;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(163, 0, 0, 0),
                                    title: Padding(
                                      padding: const EdgeInsets.all(50),
                                      child: Container(
                                        width: 150,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: const Color.fromARGB(
                                              138, 27, 35, 191),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            onMapCreated: onMapCreated,
                            onCameraPositionChanged: onCameraPositionChanged,
                            nightModeEnabled: true,
                            mapObjects: [
                              PlacemarkMapObject(
                                mapId: const MapObjectId("najotTalim"),
                                point: najotTalim,
                                onTap: (mapObject, point) {
                                  // Handle tap
                                },
                                icon: PlacemarkIcon.single(
                                  PlacemarkIconStyle(
                                    image: BitmapDescriptor.fromAssetImage(
                                      "assets/route_start.png",
                                    ),
                                  ),
                                ),
                              ),
                              ...makers,
                              ...?polylines,
                            ],
                          ),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: ZoomTapAnimation(
                              onTap: _goToMyLocation,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromARGB(132, 0, 0, 0),
                                ),
                                child: const Icon(
                                  Icons.my_location_rounded,
                                  size: 35,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ZoomTapAnimation(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(220, 71, 181, 244),
            ),
            child: const Center(
              child: Text(
                "Ro'yxatdan o'tish",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/data/models/events_models.dart';
import 'package:exam4/logic/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:exam4/logic/blocs/favorite_bloc/favorite_state.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsWidgets extends StatefulWidget {
  const EventsWidgets({super.key});

  @override
  State<EventsWidgets> createState() => _EventsWidgetsState();
}

class _EventsWidgetsState extends State<EventsWidgets> {
  final eventServices = EventFirebaseServices();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteBloc(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: eventServices.getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No events found'),
              );
            }

            // Assuming you want to display the first event for now
            var eventDoc = snapshot.data!.docs.first;
            var eventData = EventsModels.fromQuerySnapshot(eventDoc);

            return Container(
              padding: const EdgeInsets.all(5),
              height: 85,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(eventData.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${eventData.time.toDate()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          Text(
                            eventData.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          context.read<FavoriteBloc>().add(FavoriteEvent.toggle);
                        },
                        icon: Icon(
                          state.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: state.isFavorite ? Colors.red : Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

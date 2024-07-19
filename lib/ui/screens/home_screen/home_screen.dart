import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/data/models/events_models.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/carusel_widgets.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/drawer_widget.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/events_widgets.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/tapped_event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final eventServices = EventFirebaseServices();
  final searchText = TextEditingController();
  List<EventsModels> eventsList = [];
  List<EventsModels> filteredEventsList = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final snapshot = await eventServices.getEvents().first;
    final events = snapshot.docs
        .map((doc) => EventsModels.fromQuerySnapshot(doc))
        .toList();
    setState(() {
      eventsList = events;
      filteredEventsList = events;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      filteredEventsList = eventsList.where((event) {
        return event.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 25,
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: _updateSearchQuery,
              controller: searchText,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset('assets/images/search-300.svg'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                hintText: 'Search event',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Yaqin 7 kun ichida",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           CaruselWidgets(),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: eventServices.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Hozircha Eventlar mavjud emas"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final event = EventsModels.fromQuerySnapshot(
                        snapshot.data!.docs[index]);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EventTapped(
                              index: index,
                              events: event, // Pass the event object
                            );
                          },
                        ));
                      },
                      child: EventsWidgets(
                        index: index,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

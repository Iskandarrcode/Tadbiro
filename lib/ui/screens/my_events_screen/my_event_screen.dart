import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:exam4/ui/screens/my_events_screen/add_event_screen.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/events_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyEventScreen extends StatefulWidget {
  const MyEventScreen({super.key});

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  final eventServices = EventFirebaseServices();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Events'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Events'),
              Tab(text: 'Near Events'),
              Tab(text: 'Participated'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: eventServices.getEvents(),
                  builder: (context, snapshot) {
                     if (snapshot.hasError) {
                      return Text("Error: ${snapshot.hasError}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Hozircha Eventlar mavjud emas"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: EventsWidgets(index: index),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (ctx) => const AddEventScreen()),
            );
          },
        ),
      ),
    );
  }
}

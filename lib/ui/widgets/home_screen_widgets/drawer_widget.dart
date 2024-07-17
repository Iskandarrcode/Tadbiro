import 'package:exam4/data/models/user_model.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_events.dart';
import 'package:exam4/services/user_firebase_services.dart';
import 'package:exam4/ui/screens/my_events_screen/my_event_screen.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/menu_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.read<AuthBloc>();
    final userFirebaseServices = UserFirebaseServices();
    Users userData = Users(id: "", name: "", email: "", imageUrl: "");

    return StreamBuilder(
        stream: userFirebaseServices.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text('error: ${snapshot.error}'),
            );
          } else {
            for (var each in snapshot.data!.docs) {
              if (each['user-email'] ==
                  FirebaseAuth.instance.currentUser!.email) {
                userData = Users.fromJson(each);
              }
            }
            return Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                userData.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userData.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 310,
                    height: 3,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 20),
                  ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyEventScreen(),
                        ),
                      );
                    },
                    child: const ProfileInfoWidget(
                      icons: Icons.event_available_outlined,
                      text1: "Mening tadbirlarim",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ZoomTapAnimation(
                    onTap: () {},
                    child: const ProfileInfoWidget(
                      icons: Icons.manage_accounts_outlined,
                      text1: "Profil Ma'lumotlari",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ZoomTapAnimation(
                    onTap: () {},
                    child: const ProfileInfoWidget(
                      icons: Icons.language,
                      text1: "Tilini o'zgartrish",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ZoomTapAnimation(
                    onTap: () {},
                    child: const ProfileInfoWidget(
                      icons: Icons.wb_sunny_outlined,
                      text1: "Tungi/kunduzgi holat",
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 25),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            tasks.add(LogoutUserEvents());
                          },
                          child: const Text(
                            "Chiqish",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}

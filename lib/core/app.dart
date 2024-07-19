import 'package:exam4/logic/blocs/theme_bloc/theme_bloc.dart';
import 'package:exam4/logic/blocs/theme_bloc/theme_state.dart';
import 'package:exam4/ui/screens/home_screen/home_screen.dart';
import 'package:exam4/ui/screens/login_register_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => ThemeBloc(),
    ),
  ],
  child: BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, themeState) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeState is DarkThemeState
            ? ThemeMode.dark
            : ThemeMode.light,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      );
    },
  ),
);

  }
}

import 'package:exam4/core/app.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:exam4/logic/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:exam4/services/firebase_auth_http_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            firebaseAuthService: AuthHttpServices(),
          ),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

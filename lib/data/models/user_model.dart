// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String name;
  String email;
  String imageUrl;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory Users.fromJson(QueryDocumentSnapshot json) {
    return Users(
      id: json.id,
      name: json["user-name"],
      email: json["user-email"],
      imageUrl: json["user-imageUrl"],

    );
  }
}

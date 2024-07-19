// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class UserFirebaseServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<QuerySnapshot> getUsers() async* {
//     yield* _firestore.collection('users').snapshots();
//   }

//   Future<void> addUser(String name, String imageUrl) async {

//     Map<String, dynamic> data = {
//       "user-uid": FirebaseAuth.instance.currentUser!.uid,
//       "user-name": name,
//       "user-imageUrl": imageUrl,
//       'user-email': FirebaseAuth.instance.currentUser!.email,
//       'user-token': await FirebaseMessaging.instance.getToken(),
//     };
//     _firestore.collection('users').add(data);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* _firestore.collection('users').snapshots();
  }

  Future<void> addUser(String name, String imageUrl) async {
    Map<String, dynamic> data = {
      "user-uid": FirebaseAuth.instance.currentUser!.uid,
      "user-name": name,
      "user-imageUrl": imageUrl,
      'user-email': FirebaseAuth.instance.currentUser!.email,
      'user-token': await FirebaseMessaging.instance.getToken(),
    };
    await _firestore.collection('users').add(data);
  }

  Future<void> updateUser(
      { required String uid,required String name,required String email,required String imageUrl}) async {
    await _firestore.collection('users').doc(uid).update({
      "user-name": name,
      "user-email": email,
      "user-imageUrl": imageUrl,
    });
  }
}

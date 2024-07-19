// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exam4/data/models/user_model.dart';
// import 'package:exam4/logic/blocs/auth_bloc/auth_bloc.dart';
// import 'package:exam4/services/user_firebase_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gap/gap.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? dateOfBirth;
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController imageUrlController = TextEditingController();

//   final userFirebaseServices = UserFirebaseServices();
//   File? _imageFile;

//   Future<void> pickImage(ImageSource source) async {
//     final imagePicker = ImagePicker();
//     final XFile? pickedImage = await imagePicker.pickImage(
//       source: source,
//       imageQuality: 30,
//       requestFullMetadata: false,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> uploadImage() async {
//     if (_imageFile == null) return;

//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('user_images/${DateTime.now().toString()}.jpg');
//       final uploadTask = storageRef.putFile(_imageFile!);

//       final snapshot = await uploadTask;
//       final imageUrl = await snapshot.ref.getDownloadURL();
//       imageUrlController.text = imageUrl;
//     } catch (e) {
//       // ignore: avoid_print
//       print('Imgeni Yuklashda xatolik: $e');
//     }
//   }

//   void submit() async {
//     if (_formKey.currentState!.validate()) {
//       await uploadImage();
//       userFirebaseServices.updateUser(
//         uid: FirebaseAuth.instance.currentUser!.uid,
//         name: nameController.text,
//         email: emailController.text,
//         imageUrl: imageUrlController.text,
//       );

//       showDialog(
//         // ignore: use_build_context_synchronously
//         context: context,
//         barrierDismissible: false,
//         builder: (ctx) {
//           return AlertDialog(
//             title: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.green[200],
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset("assets/icons/saved_icon.svg"),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Gap(20),
//                 const Text(
//                   "Congratulations!",
//                   style: TextStyle(fontFamily: 'Inter'),
//                 ),
//                 const Gap(10),
//                 const Text(
//                   textAlign: TextAlign.center,
//                   "Your account is ready to use. You will be redirected to the Home Page in 3 seconds...",
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (ctx) {
//                     return const Placeholder();
//                   }));
//                 },
//                 child: const Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tasks = context.read<AuthBloc>();
//     final userFirebaseServices = UserFirebaseServices();
//     Users userData = Users(id: "", name: "", email: "", imageUrl: "");

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Fill Your Profile",
//           style: TextStyle(
//             fontFamily: 'Inter',
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: userFirebaseServices.getUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.hasError) {
//             return Center(
//               child: Text('error: ${snapshot.error}'),
//             );
//           } else {
//             for (var each in snapshot.data!.docs) {
//               if (each['user-email'] ==
//                   FirebaseAuth.instance.currentUser!.email) {
//                 userData = Users.fromJson(each);
//               }
//             }
//             return SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Stack(
//                           children: [
//                             Container(
//                               width: 160,
//                               height: 160,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey[300],
//                                 image: _imageFile != null
//                                     ? DecorationImage(
//                                         image: FileImage(_imageFile!),
//                                         fit: BoxFit.cover,
//                                       )
//                                     : null,
//                               ),
//                               child: _imageFile == null
//                                   ? const Center(
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 150,
//                                         color: Colors.grey,
//                                       ),
//                                     )
//                                   : null,
//                             ),
//                             Positioned(
//                               left: 133,
//                               bottom: 0,
//                               child: InkWell(
//                                 onTap: () async {
//                                   await pickImage(ImageSource.gallery);
//                                 },
//                                 child: const Icon(
//                                   Icons.add_a_photo,
//                                   size: 27,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 25),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.90,
//                       child: TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: const Color(0xffF9FAFB),
//                           contentPadding: const EdgeInsets.all(12),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           labelText: "Your Name",
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return "Please enter your name";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     const SizedBox(height: 80),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ZoomTapAnimation(
//                           onTap: submit,
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 0.90,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: const Color.fromARGB(255, 0, 72, 255),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/data/models/user_model.dart';
import 'package:exam4/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:exam4/services/user_firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? dateOfBirth;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final UserFirebaseServices userFirebaseServices = UserFirebaseServices();
  File? _imageFile;

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 30,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().toString()}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      imageUrlController.text = imageUrl;
    } catch (e) {
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload error: $e')),
      );
    }
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      await uploadImage();
      await userFirebaseServices.updateUser(
        uid: FirebaseAuth.instance.currentUser!.uid,
        name: nameController.text,
        email: emailController.text,
        imageUrl: imageUrlController.text,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[200],
                      ),
                      child: Center(
                        child: SvgPicture.asset("assets/icons/saved_icon.svg"),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const Text(
                  "Congratulations!",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                const Gap(10),
                const Text(
                  textAlign: TextAlign.center,
                  "Your account is ready to use. You will be redirected to the Home Page in 3 seconds...",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (ctx) {
                  //   return const HomeScreen(); // Replace with your actual HomeScreen
                  // }));
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill Your Profile",
          style: TextStyle(
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userFirebaseServices.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Users userData = Users(id: "", name: "", email: "", imageUrl: "");

            for (var each in snapshot.data!.docs) {
              if (each['user-email'] ==
                  FirebaseAuth.instance.currentUser!.email) {
                userData = Users.fromJson(each);
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.all(16.0), // Add padding to avoid overlap
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Stack(
                        clipBehavior:
                            Clip.none, // Ensure widgets do not overflow
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              image: _imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _imageFile == null
                                ? const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 150,
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            left: 120,
                            bottom: 0,
                            child: InkWell(
                              onTap: () async {
                                await pickImage(ImageSource.gallery);
                              },
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 27,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity, // Make sure it fits properly
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Your Name",
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(height: 80), // Adjust spacing
                      ZoomTapAnimation(
                        onTap: submit,
                        child: Container(
                          width: double.infinity, // Make sure it fits properly
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 0, 72, 255),
                          ),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

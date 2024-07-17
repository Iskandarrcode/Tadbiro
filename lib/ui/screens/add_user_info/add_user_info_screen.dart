// import 'dart:io';

// import 'package:exam4/services/user_firebase_services.dart';
// import 'package:exam4/ui/screens/home_screen/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gap/gap.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// class UserInfoScreen extends StatefulWidget {
//   const UserInfoScreen({super.key});

//   @override
//   State<UserInfoScreen> createState() => _UserInfoScreenState();
// }

// class _UserInfoScreenState extends State<UserInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? dateOfBirth;
//   final TextEditingController _dobController = TextEditingController();

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

//   void submit() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       showDialog(
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
//                   "Your account is ready to use. You will be redirected to the Home Page in a 3 seconds...",
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
//                     return const HomeScreen();
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

//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController imageUrlController = TextEditingController();

//   final userFirebaseServices = UserFirebaseServices();
//   File? _imageFile;

//   @override
//   void dispose() {
//     _dobController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Fill Your Profile",
//           style: TextStyle(
//             color: Color(0xff374151),
//             fontFamily: 'Inter',
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         width: 160,
//                         height: 160,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey[300],
//                           image: _imageFile != null
//                               ? DecorationImage(
//                                   image: FileImage(_imageFile!),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                         ),
//                         child: _imageFile == null
//                             ? const Center(
//                                 child: Icon(
//                                   Icons.person,
//                                   size: 150,
//                                   color: Colors.grey,
//                                 ),
//                               )
//                             : null,
//                       ),
//                       Positioned(
//                         left: 133,
//                         bottom: 0,
//                         child: InkWell(
//                           onTap: () async {
//                             await pickImage(ImageSource.gallery);
//                           },
//                           child: const Icon(
//                             Icons.add_a_photo,
//                             size: 27,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 25),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.90,
//                 child: TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xffF9FAFB),
//                     contentPadding: const EdgeInsets.all(12),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     labelText: "Your Name",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter you name";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const SizedBox(height: 80),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ZoomTapAnimation(
//                     onTap: () {
//                       if (_formKey.currentState!.validate()) {
//                         userFirebaseServices.addUser(
//                           nameController.text,
//                           _imageFile.toString(),
//                         );
//                         nameController.clear();
//                         emailController.clear();
//                         imageUrlController.clear();
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return const HomeScreen();
//                             },
//                           ),
//                         );
//                       }

//                       // ignore: use_build_context_synchronously
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.90,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Colors.amber.shade900,
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Save",
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:exam4/services/user_firebase_services.dart';
import 'package:exam4/ui/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? dateOfBirth;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final userFirebaseServices = UserFirebaseServices();
  File? _imageFile;

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 30,
      requestFullMetadata: false,
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
      print('Imgeni Yuklashda xatolik: $e');
    }
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      await uploadImage();
      userFirebaseServices.addUser(
        nameController.text,
        imageUrlController.text,
      );

      showDialog(
        // ignore: use_build_context_synchronously
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) {
                    return const HomeScreen();
                  }));
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
  void dispose() {
    _dobController.dispose();
    nameController.dispose();
    emailController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill Your Profile",
          style: TextStyle(
            color: Color(0xff374151),
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
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
                        left: 133,
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
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffF9FAFB),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Your Name",
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
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomTapAnimation(
                    onTap: submit,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.amber.shade900,
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
            ],
          ),
        ),
      ),
    );
  }
}

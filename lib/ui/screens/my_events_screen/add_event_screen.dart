import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam4/services/event_firebase_services.dart';
import 'package:exam4/services/location_services.dart';
import 'package:exam4/services/sharedPreferences_services.dart';
import 'package:exam4/ui/widgets/text_form_fild_widget.dart';
import 'package:exam4/utils/app_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TimeOfDay? _timeOfDay;
  DateTime? _dateTime;
  File? _imageFile;

  final EventFirebaseServices eventService = EventFirebaseServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eNameController = TextEditingController();
  final TextEditingController _eDescriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  late YandexMapController mapController;

  final _searchController = TextEditingController();
  List<MapObject>? polylines;
  List<PlacemarkMapObject> makers = [];

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    mapController = controller;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: najotTalim,
          zoom: 20,
        ),
      ),
    );
    setState(() {});
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finished,
  ) async {
    myCurrentLocation = position.target;
  }

  void _goToMyLocation() async {
    if (myLocation != null) {
      await mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLocation!,
            zoom: 20,
          ),
        ),
      );
    } else {
      // Handle case where location is not available
      print("Current location not available");
    }
  }

  void onSaveTap() async {
    if (_formKey.currentState!.validate() &&
        _dateTime != null &&
        _timeOfDay != null &&
        location != null) {
      final String userID = await SharedPreferencesServices().getUserId();
      await uploadImage();

      try {
        eventService.addEvent(
          userID,
          _eNameController.text,
          Timestamp.fromDate(
            AppFunctions.combineDateTimeAndTimeOfDay(_dateTime!, _timeOfDay!),
          ),
          GeoPoint(location!.latitude, location!.longitude),
          _eDescriptionController.text,
          imageUrlController.text,
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        print("Shared Preference ga saqlashda xatolik");
      }
    }
  }

  Point? myLocation;

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
          .child('event_images/${DateTime.now().toString()}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      imageUrlController.text = imageUrl;
    } catch (e) {
      print('Imgeni Yuklashda xatolik: $e');
    }
  }

  Future<SuggestSessionResult> _suggest() async {
    final resultWithSession = await YandexSuggest.getSuggestions(
      text: _searchController.text,
      boundingBox: const BoundingBox(
        northEast: Point(latitude: 56.0421, longitude: 38.0284),
        southWest: Point(latitude: 55.5143, longitude: 37.24841),
      ),
      suggestOptions: const SuggestOptions(
        suggestType: SuggestType.geo,
        suggestWords: true,
        userPosition: Point(latitude: 56.0321, longitude: 38),
      ),
    );

    return await resultWithSession.$2;
  }

  Future<void> _requestLocation() async {
    bool hasPermission = await LocationService.checkPermissions();
    if (hasPermission) {
      Position? position = await LocationService.determinePosition();
      if (position != null) {
        myLocation = Point(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        setState(() {});
      }
    } else {
      print("Location permissions not granted");
    }
  }

  @override
  void initState() {
    super.initState();
    _requestLocation();

    LocationService.determinePosition().then(
      (value) {
        if (value != null) {
          myLocation = Point(
            latitude: value.latitude,
            longitude: value.longitude,
          );
          setState(() {});
        }
      },
    );
  }

  Point? location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hintText: 'Event name',
                          isObscure: false,
                          validator: (p0) =>
                              p0!.isEmpty ? 'Enter event name' : null,
                          textEditingController: _eNameController,
                          isMaxLines: true,
                        ),
                        const Gap(15),
                        CustomTextFormField(
                          hintText: 'Description about event',
                          isObscure: false,
                          validator: (p0) =>
                              p0!.isEmpty ? 'Enter description' : null,
                          textEditingController: _eDescriptionController,
                          isMaxLines: true,
                        ),
                        const Gap(15),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final DateTime? chosenDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          if (chosenDate != null) {
                            setState(() {
                              _dateTime = chosenDate;
                            });
                          }
                        },
                        label: const Text('Date'),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.access_time_rounded),
                        onPressed: () async {
                          final TimeOfDay? chosenTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (chosenTime != null) {
                            setState(() {
                              _timeOfDay = chosenTime;
                            });
                          }
                        },
                        label: const Text('Time'),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => pickImage(ImageSource.camera),
                        label: const Text('Camera'),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose location',
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2 + 50,
                    // yandex map placeholder
                    child: Stack(
                      children: [
                        YandexMap(
                          onMapLongTap: (argument) async {
                            //! Joylashuvni olish
                            location = argument;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Color.fromARGB(163, 0, 0, 0),
                                  title: Padding(
                                    padding: const EdgeInsets.all(50),
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color.fromARGB(
                                            138, 27, 35, 191),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            print(location);
                          },
                          onMapCreated: onMapCreated,
                          onCameraPositionChanged: onCameraPositionChanged,
                          nightModeEnabled: true,
                          mapObjects: [
                            PlacemarkMapObject(
                              mapId: const MapObjectId("najotTalim"),
                              point: najotTalim,
                              onTap: (mapObject, point) {
                                // Handle tap
                              },
                              icon: PlacemarkIcon.single(
                                PlacemarkIconStyle(
                                  image: BitmapDescriptor.fromAssetImage(
                                    "assets/route_start.png",
                                  ),
                                ),
                              ),
                            ),
                            ...makers,
                            ...?polylines,
                          ],
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: ZoomTapAnimation(
                            onTap: _goToMyLocation,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(132, 0, 0, 0),
                              ),
                              child: const Icon(
                                Icons.my_location_rounded,
                                size: 35,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomTapAnimation(
        onTap: () {
          onSaveTap();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2 + 150,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(236, 14, 62, 235),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

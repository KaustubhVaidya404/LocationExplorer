import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locationexplorer/view/ui/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/app_colors.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.image});
  final XFile image;

  @override
  State<AddressScreen> createState() => _AddressScreenState(image);
}

class _AddressScreenState extends State<AddressScreen> {
  late XFile addressimage;
  _AddressScreenState(XFile image) {
    addressimage = image;
  }

  var db = FirebaseFirestore.instance;
  String? email;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController placename = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future uploadImage() async {
      XFile image = addressimage;
      File fileName = File(image.name);
      File file = File(image.path);
      String placenamestr = placename.text;
      final path = 'images/$email/$placenamestr/$fileName';
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
    }

    navigation() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }

    sendLocation(Position position) {
      if (placename.text.isEmpty) {
        const SnackBar error = SnackBar(content: Text('Cancel'));
        ScaffoldMessenger.of(context).showSnackBar(error);
      } else {
        final locationData = {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "fav": false
        };
        uploadImage();
        db.collection(email!).doc(placename.text).set(locationData);
      }
    }

    sendManualLocation(Location location) {
      final locationData = {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "fav": false
      };
      uploadImage();
      db.collection(email!).doc(placename.text).set(locationData);
      navigation();
    }

    actionFunction() async {
      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          email = FirebaseAuth.instance.currentUser!.email;
        });
      }

      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        sendLocation(position);
      }).then((_) => navigation());
    }

    const SnackBar reuiredSnack =
        SnackBar(content: Text('All feilds are mandatory'));

    actionManual() async {
      if (street.text.isNotEmpty &&
          landmark.text.isNotEmpty &&
          city.text.isNotEmpty &&
          state.text.isNotEmpty &&
          country.text.isNotEmpty) {
        List<Location> locationsList = await locationFromAddress(
            '${street.text},${landmark.text},${city.text},${state.text},${country.text}');
        final Location location = locationsList[0];
        sendManualLocation(location);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(reuiredSnack);
      }
    }

    dialogFunPick() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: dialogBC,
                actions: [
                  const Center(
                    child: Text(
                      'Save location as?',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: placename,
                    decoration: const InputDecoration(
                        hintText: "eg. Favourite Place, Sweet Home"),
                  ),
                  TextButton(
                      onPressed: () {
                        actionFunction();
                        Navigator.pop(context);
                      },
                      child: const Text('OK')),
                ],
              ));
    }

    dialogFunManual() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: dialogBC,
                actions: [
                  const Center(
                    child: Text(
                      'Save location as?',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: placename,
                    decoration: const InputDecoration(
                        hintText: "eg. Favourite Place, Sweet Home"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        actionManual();
                      },
                      child: const Text('OK')),
                ],
              ));
    }

    const SnackBar errorsnackBar =
        SnackBar(content: Text("All feilds are mandatory"));
    return Scaffold(
      backgroundColor: backGroundBlue,
      appBar: AppBar(
        backgroundColor: backGroundBlue,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              const Text(
                'Location Explorer',
                style: TextStyle(fontSize: 25, color: appBarFontBlack),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (await Permission.location.isGranted) {
                      if (placename.text.isNotEmpty) {
                        actionFunction();
                      } else {
                        dialogFunPick();
                      }
                    } else {
                      await Geolocator.requestPermission();
                      if (await Permission.location.isDenied) {
                        await Geolocator.requestPermission();
                      }
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(elevatedButtonColor)),
                  child: const Text('📍️ Pin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(18),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Add location manually',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: street,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Street"),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: landmark,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "landmark"),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: city,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "city"),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: state,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "state"),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: country,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "country"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(sliderDeleteColor)),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25))),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser != null) {
                          setState(() {
                            email = FirebaseAuth.instance.currentUser!.email;
                          });
                        }
                        if (placename.text.isNotEmpty) {
                          actionManual();
                          if (street.text.isNotEmpty ||
                              landmark.text.isNotEmpty ||
                              city.text.isNotEmpty ||
                              state.text.isNotEmpty ||
                              country.text.isNotEmpty) {
                            actionManual();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(errorsnackBar);
                          }
                        } else {
                          dialogFunManual();
                        }
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(elevatedButtonColor)),
                      child: const Text('Proceed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

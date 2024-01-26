import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/view/ui/home_screen.dart';
import 'package:locationexplorer/view/ui/map_address.dart';

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
    this.addressimage = image;
  }

  var db = FirebaseFirestore.instance;
  String? email;
  var latitude;
  var longitude;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController placename = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipcode = TextEditingController();
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

    final SnackBar errorsnackBar =
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
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddressOnMap()));
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(elevatedButtonColor)),
                  child: const Text('Open Map',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ],
          ),
        ),
      ),
      body: Container(
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
              controller: zipcode,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "zipcode"),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    setState(() {
                      email = FirebaseAuth.instance.currentUser!.email;
                    });
                  }
                  if (placename.text.isNotEmpty) {
                    if (street.text.isNotEmpty ||
                        landmark.text.isNotEmpty ||
                        city.text.isNotEmpty ||
                        state.text.isNotEmpty ||
                        zipcode.text.isNotEmpty) {
                      final addressData = {
                        "street": street.text,
                        "landmark": landmark.text,
                        "city": city.text,
                        "state": state.text,
                        "zipcode": zipcode.text,
                      };
                      db
                          .collection(email!)
                          .doc(placename.text)
                          .set(addressData);
                      uploadImage();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(errorsnackBar);
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: dialogBC,
                              actions: [
                                const Center(
                                  child: Text(
                                    'Save location as?',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  controller: placename,
                                  decoration: const InputDecoration(
                                      hintText:
                                          "eg. Favourite Place, Sweet Home"),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK')),
                              ],
                            ));
                  }
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(elevatedButtonColor)),
                child: const Text('Proceed',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          ],
        ),
      ),
    );
  }
}

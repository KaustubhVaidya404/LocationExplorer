import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_colors.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.image});
  final XFile image;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
                onPressed: () {},
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

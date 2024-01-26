import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/view/ui/camera_screen.dart';
import 'package:locationexplorer/view/ui/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String? email;
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        email = FirebaseAuth.instance.currentUser!.email;
      });
    } else {}
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
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(backGroundBlue)),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          await availableCameras().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => CameraScreen(
                        camera: value,
                      ))));
        },
        backgroundColor: floatingActionButtonColor,
        child: const Icon(Icons.add_location_alt_outlined),
      ),
      drawer: Drawer(
          shadowColor: Colors.black,
          backgroundColor: drawerBC,
          child: ListView(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Icons.person),
                title: Text(
                  "$email",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Sign out',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setBool('state', false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
              ),
            ],
          )),
    );
  }
}

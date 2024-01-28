import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/view/ui/camera_screen.dart';
import 'package:locationexplorer/view/ui/sign_up_screen.dart';
import 'package:locationexplorer/view/widgets/store_item_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;

  navigator() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  late Stream firestoreData;

  @override
  void initState() {
    super.initState();
    firestoreData = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        email = FirebaseAuth.instance.currentUser!.email;
      });
    }

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
        child: const Icon(Icons.camera),
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
                  navigator();
                },
              ),
            ],
          )),
      body: StreamBuilder(
        stream: firestoreData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text(
                'Something went wrong, please check your internet connection');
          }
          if (snapshot.connectionState == ConnectionState.active) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listQueryDocSnapshot =
                querySnapshot.docs;

            return ListView.separated(
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot doc = listQueryDocSnapshot[index];
                  return StoreListItems(documentSnapshot: doc);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: listQueryDocSnapshot.length);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

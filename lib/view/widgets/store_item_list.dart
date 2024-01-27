import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/config/app_colors.dart';

class StoreListItems extends StatefulWidget {
  QueryDocumentSnapshot<Object?> documentSnapshot;
  StoreListItems({super.key, required this.documentSnapshot});

  @override
  State<StoreListItems> createState() => _StoreListItemsState(documentSnapshot);
}

class _StoreListItemsState extends State<StoreListItems> {
  late QueryDocumentSnapshot _documentSnapshot;
  _StoreListItemsState(QueryDocumentSnapshot<Object?> documentSnapshot) {
    _documentSnapshot = documentSnapshot;
  }

  var db = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString());

  late bool favstate;
  @override
  void initState() {
    favstate = _documentSnapshot['fav'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 3),
        tileColor: tileColor,
        onTap: () {
          //TODO: navigate to map and photo screen
        },
        title: Text(_documentSnapshot.id.toString()),
        trailing: ElevatedButton(
            style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(tileColor)),
            onPressed: () {
              if (_documentSnapshot['fav'] == false) {
                db.doc(_documentSnapshot.id.toString()).update({'fav': true});
                setState(() {
                  favstate = !favstate;
                });
              }
              if (_documentSnapshot['fav'] == true) {
                db.doc(_documentSnapshot.id.toString()).update({'fav': false});
                setState(() {
                  favstate = !favstate;
                });
              }
            },
            child: favstate == true
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border)),
      ),
    );
  }
}

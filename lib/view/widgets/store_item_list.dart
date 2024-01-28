import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locationexplorer/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreListItems extends StatefulWidget {
  QueryDocumentSnapshot<Object?> documentSnapshot;
  StoreListItems({super.key, required this.documentSnapshot});

  @override
  // ignore: no_logic_in_create_state
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

  String? imageurl;

  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    favstate = _documentSnapshot['fav'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Slidable(
              endActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (_) {
                    db.doc(_documentSnapshot.id.toString()).delete();
                  },
                  icon: Icons.delete,
                  backgroundColor: sliderDeleteColor,
                )
              ]),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                tileColor: tileColor,
                onTap: () {
                  _launchURL(_documentSnapshot['latitude'],
                      _documentSnapshot['longitude']);
                },
                title: Text(_documentSnapshot.id.toString()),
                trailing: ElevatedButton(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(tileColor)),
                    onPressed: () {
                      if (_documentSnapshot['fav'] == false) {
                        db
                            .doc(_documentSnapshot.id.toString())
                            .update({'fav': true});
                        setState(() {
                          favstate = !favstate;
                        });
                      }
                      if (_documentSnapshot['fav'] == true) {
                        db
                            .doc(_documentSnapshot.id.toString())
                            .update({'fav': false});
                        setState(() {
                          favstate = !favstate;
                        });
                      }
                    },
                    child: favstate == true
                        ? const Icon(
                            Icons.favorite,
                            color: favColor,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: favBorderColor,
                          )),
              ),
            )));
  }

  _launchURL(var latitude, var longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps?z=12&t=m&q=loc:$latitude,$longitude');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

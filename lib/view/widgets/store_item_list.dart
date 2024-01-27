import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        //TODO: navigate to map and photo screen
      },
      title: Text(_documentSnapshot.id.toString()),
    );
  }
}

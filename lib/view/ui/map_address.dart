import 'package:flutter/material.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';

class AddressOnMap extends StatefulWidget {
  const AddressOnMap({super.key});

  @override
  State<AddressOnMap> createState() => _AddressOnMapState();
}

class _AddressOnMapState extends State<AddressOnMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
        onPicked: (markdata) {},

        // buttonColor: mapColorConfig,
        // locationPinIconColor: locationPickColor,
      ),
    );
  }
}

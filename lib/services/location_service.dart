import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/models/location.dart';

Future<List<Location>> getAvailableLocations() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('locations')
      .get();

  return querySnapshot.docs
      .map((doc) => Location.fromJson(doc.data()))
      .toList();
}

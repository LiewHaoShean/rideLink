import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'create_ride_home_widget.dart' show CreateRideHomeWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_link_carpooling/models/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/services/ride_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_link_carpooling/models/trip.dart';

class CreateRideHomeModel extends FlutterFlowModel<CreateRideHomeWidget> {
  final _rideService = RideService();
  
  ///  Local state fields for this page.
  int? seatNumber = 1;

  /// State fields
  Location? _selectedLocation1;
  Location? get selectedLocation1 => _selectedLocation1;
  set selectedLocation1(Location? val) => _selectedLocation1 = val;
  String? Function(BuildContext, Location?)? location1Validator;

  Location? _selectedLocation2;
  Location? get selectedLocation2 => _selectedLocation2;
  set selectedLocation2(Location? val) => _selectedLocation2 = val;
  String? Function(BuildContext, Location?)? location2Validator;

  DateTime? datePicked1;
  DateTime? datePicked2;
  
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  /// Method to create ride in Firestore
  
  Future<DocumentReference?> createRide() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      final trip = Trip(
        rideId: '',
        creatorId: user.uid,
        origin: selectedLocation1?.name ?? '',
        destination: selectedLocation2?.name ?? '',
        departureTime: datePicked1!,
        availableSeats: seatNumber ?? 0,
        pricePerSeat: double.tryParse(textController3?.text.trim() ?? '') ?? 0.0,
        passengers: [],
        status: 'scheduled',
      );

      final docRef = await FirebaseFirestore.instance.collection('trips').add(trip.toJson());
      return docRef;
    } catch (e) {
      debugPrint('Error creating trip: $e');
      return null;
    }
  }


  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}

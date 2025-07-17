import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as dateFormat;
import 'package:timeago/timeago.dart' as timeFormat;

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'search_ride_pending_ride_model.dart';
export 'search_ride_pending_ride_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRidePendingRideWidget extends StatefulWidget {
  final String? rideId;
  final String? creatorId;
  final String? carId;
  final int? seatNeeded;

  const SearchRidePendingRideWidget({
    super.key,
    this.rideId,
    this.creatorId,
    this.carId,
    this.seatNeeded,
  });

  static String routeName = 'searchRidePendingRide';
  static String routePath = '/searchRidePendingRide';

  @override
  State<SearchRidePendingRideWidget> createState() => _SearchRidePendingRideWidgetState();
}

class _SearchRidePendingRideWidgetState extends State<SearchRidePendingRideWidget> {
  bool? isPassenger; // null = loading, true = in ride, false = not in ride
  bool isLoading = true;
  late SearchRidePendingRideModel _model;
  Map<String, dynamic>? rideData;
  Map<String, dynamic>? creatorData;
  Map<String, dynamic>? carData;
  List<Map<String, dynamic>> usersInRide = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> matchedTrips = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchRidePendingRideModel());
    _fetchUserTrips();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final trips = await _fetchUserTrips();
    setState(() {
      matchedTrips = trips;
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchUserTrips() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      print('[DEBUG] No user signed in — returning empty list.');
      return [];
    }

    print('[DEBUG] Fetching trips for user: $currentUserId');

    final tripSnapshot = await FirebaseFirestore.instance.collection('trips')
    .where('status', whereNotIn: ['ongoing', 'finished']).get();

    print('[DEBUG] Total trips fetched from Firestore: ${tripSnapshot.docs.length}');

    final matchedTrips = <Map<String, dynamic>>[];

    for (final doc in tripSnapshot.docs) {
      final tripData = doc.data();
      final passengers = tripData['passengers'] as List<dynamic>? ?? [];

      for (final p in passengers) {
        final map = p as Map<String, dynamic>;
        if (map['passengerId'] == currentUserId &&
            (map['status'] == 'joined' || map['status'] == 'accepted')) {
          print('[DEBUG] Trip ${doc.id} matched for user.');

          final creatorId = tripData['creatorId'];
          String creatorName = 'Unknown Driver';

          try {
            final userDoc = await FirebaseFirestore.instance.collection('users').doc(creatorId).get();
            if (userDoc.exists) {
              creatorName = userDoc.data()?['name'] ?? 'Unknown Driver';
            }
          } catch (e) {
            print('[ERROR] Failed to fetch creatorName for $creatorId: $e');
          }

          final departureTimestamp = tripData['departureTime'];
          DateTime? departureTime;
          if (departureTimestamp is Timestamp) {
            departureTime = departureTimestamp.toDate();
          }

          matchedTrips.add({
            'tripId': doc.id,
            'status': map['status'],
            'origin': tripData['origin'],
            'destination': tripData['destination'],
            'departureTime': departureTime,
            'creatorName': creatorName,
          });
        }
      }
    }

    print('[DEBUG] Total matched trips for user: ${matchedTrips.length}');
    return matchedTrips;
  }

  Future<void> _cancelBooking(String tripId, String passengerId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('trips').doc(tripId);

      final tripDoc = await docRef.get();
      if (!tripDoc.exists) {
        print('Trip not found');
        return;
      }

      final data = tripDoc.data();
      List<dynamic> passengers = data?['passengers'] ?? [];

      passengers = passengers.where((p) {
        final map = p as Map<String, dynamic>;
        return map['passengerId'] != passengerId;
      }).toList();

      await docRef.update({'passengers': passengers});

      print('Booking cancelled for $passengerId in Trip $tripId');

      setState(() {
        usersInRide = passengers.cast<Map<String, dynamic>>();
        isPassenger = false;
      });

      // Show success dialog
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Your booking has been cancelled.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );

        await _loadTrips(); // Refresh trip list 
      }

    } catch (e) {
      print('Error cancelling booking: $e');

      // Optional: show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to cancel booking. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allPassengers = matchedTrips.expand((trip) {
      final passengers = trip['passengers'] as List<dynamic>? ?? [];
      return passengers.map((p) {
        final map = p as Map<String, dynamic>;
        map['tripId'] = trip['tripId'];
        return map;
      });
    }).toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 1, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderRadius: 8,
                                            buttonSize: 40,
                                            fillColor: Color(0xFFE5E5E5),
                                            icon: Icon(
                                              Icons.arrow_back_ios_new,
                                              color: Color(0xFF00275C),
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              context
                                                  .pushNamed('dashboardHome');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300.0,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 327.6,
                                                    height: 36.04,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Requested Ride',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmall
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        width: 394.5,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(


                          children: matchedTrips.map((trip) {
                            final isCurrentUser = true; // because this trip is already filtered for current user
                            final status = trip['status'] ?? 'unknown';
                            final tripId = trip['tripId'];
                            final origin = trip['origin'] ?? 'Unknown Origin';
                            final destination = trip['destination'] ?? 'Unknown Destination';
                            final departureTime = trip['departureTime'] as DateTime?;
                            final date = departureTime != null ? dateFormat.format(departureTime) : 'Unknown Date';
                            final time = departureTime != null ? timeFormat.format(departureTime) : 'Unknown Time';
                            final creatorName = trip['creatorName'] ?? 'Unknown Driver';

                            return Container(
                              width: 350,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00275C),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF00275C), width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date: $date',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Time: $time',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'From: $origin',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'To: $destination',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Driver: $creatorName',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Status: $status',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    if (isCurrentUser)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              await _cancelBooking(tripId, FirebaseAuth.instance.currentUser!.uid);
                                            },
                                            text: 'Cancel Request',
                                            options: FFButtonOptions(
                                              width: 300,
                                              height: 40,
                                              color: const Color(0xFFFF5963), // custom button color
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                ),
                              );
                          }).toList(),

                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

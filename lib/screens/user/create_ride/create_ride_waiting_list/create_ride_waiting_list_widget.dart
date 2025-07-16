import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'create_ride_waiting_list_model.dart';
export 'create_ride_waiting_list_model.dart';

class CreateRideWaitingListWidget extends StatefulWidget {
  final String rideId;

  const CreateRideWaitingListWidget({
    super.key,
    required this.rideId,
  });

  static String routeName = 'createRideWaitingList';
  static String routePath = '/createRideWaitingList';

  @override
  State<CreateRideWaitingListWidget> createState() => _CreateRideWaitingListWidgetState();
}

class _CreateRideWaitingListWidgetState extends State<CreateRideWaitingListWidget> with WidgetsBindingObserver {
  bool isLoading = true;
  late CreateRideWaitingListModel _model;
  late Future<DocumentSnapshot<Map<String, dynamic>>> _rideFuture;
  List<Map<String, dynamic>> allPassengers = [];
  List<Map<String, dynamic>> matchedTrips = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize the ride future to fetch ride details
    _rideFuture = FirebaseFirestore.instance
      .collection('trips')
      .doc(widget.rideId)
      .get();
    _model = createModel(context, () => CreateRideWaitingListModel());
    _loadTrips();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _deleteTrip();
    }
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

    final tripSnapshot = await FirebaseFirestore.instance.collection('trips').get();

    print('[DEBUG] Total trips fetched from Firestore: ${tripSnapshot.docs.length}');

    final matchedTrips = <Map<String, dynamic>>[];

    for (final doc in tripSnapshot.docs) {
      final tripData = doc.data();
      final passengers = tripData['passengers'] as List<dynamic>? ?? [];

      for (final p in passengers) {
        final map = p as Map<String, dynamic>;
        if (map['status'] == 'joined' || map['status'] == 'accepted') {
          print('[DEBUG] Trip ${doc.id} matched for user.');

          final creatorId = tripData['creatorId'];
          String creatorName = 'Unknown Driver';

          try {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(creatorId)
                .get();
            if (userDoc.exists) {
              creatorName = userDoc.data()?['name'] ?? 'Unknown Driver';
            }
          } catch (e) {
            print('[ERROR] Failed to fetch creatorName for $creatorId: $e');
          }

          // 👇 Enrich each passenger with name
          final enrichedPassengers = <Map<String, dynamic>>[];

          for (final passenger in passengers) {
            final passengerMap = passenger as Map<String, dynamic>;
            final passengerId = passengerMap['passengerId'];

            String passengerName = 'Unknown Passenger';

            if (passengerId != null) {
              try {
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(passengerId)
                    .get();
                if (userDoc.exists) {
                  passengerName = userDoc.data()?['name'] ?? 'Unknown Passenger';
                }
              } catch (e) {
                print('[ERROR] Failed to fetch name for passengerId $passengerId: $e');
              }
            }

            // Important: clone to avoid mutating the original map
            final enrichedMap = Map<String, dynamic>.from(passengerMap);
            enrichedMap['name'] = passengerName;

            enrichedPassengers.add(enrichedMap);
          }

          matchedTrips.add({
            'tripId': doc.id,
            'status': map['status'],
            'origin': tripData['origin'],
            'destination': tripData['destination'],
            'departureTime': tripData['departureTime'],
            'creatorName': creatorName,
            'passengers': enrichedPassengers,
          });

          // Important: break so you don’t duplicate the same trip for each passenger
          break;
        }
      }
    }


    print('[DEBUG] Total matched trips for user: ${matchedTrips.length}');
    return matchedTrips;
  }

  Future<void> _deleteTrip() async {
    final docRef = FirebaseFirestore.instance.collection('trips').doc(widget.rideId);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final creatorId = doc['creatorId'];
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == creatorId) {
      await docRef.delete();
      print('[DEBUG] Trip deleted');
    } else {
      print('[DEBUG] You cannot delete a trip you did not create!');
    }
  }

  Future<void> _updatePassengerStatus(String passengerId, String rideId, String newStatus) async {
    final tripRef = FirebaseFirestore.instance.collection('trips').doc(rideId);

    final tripDoc = await tripRef.get();
    if (!tripDoc.exists) {
      debugPrint('[ERROR] Trip not found for ID: $rideId');
      return;
    }

    final tripData = tripDoc.data();
    if (tripData == null) {
      debugPrint('[ERROR] Trip data is null for ID: $rideId');
      return;
    }

    final passengers = (tripData['passengers'] as List<dynamic>?) ?? [];

    final updatedPassengers = passengers.map((p) {
      final map = Map<String, dynamic>.from(p as Map);
      if (map['passengerId'] == passengerId) {
        map['status'] = newStatus;
      }
      return map;
    }).toList();

    await tripRef.update({'passengers': updatedPassengers});

    debugPrint('[SUCCESS] Updated passenger $passengerId to status: $newStatus');
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Back button
                                FlutterFlowIconButton(
                                  borderRadius: 8,
                                  buttonSize: 40,
                                  fillColor: const Color(0xFFE5E5E5),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Color(0xFF00275C),
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    final shouldExit = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text('Do you really want to quit? This ride will be discarded.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Quit'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (shouldExit == true) {
                                      // Delete the ride
                                      await FirebaseFirestore.instance
                                          .collection('trips')
                                          .doc(widget.rideId)
                                          .delete();
                                      // Then pop
                                      if (context.mounted) {
                                        context.safePop();
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Diplay locations details

                                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        future: _rideFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          }

                                          if (!snapshot.hasData || !snapshot.data!.exists) {
                                            return const Text('Ride not found');
                                          }

                                          final rideData = snapshot.data!.data()!;
                                          final originName = rideData['origin'] ?? '';
                                          final destinationName = rideData['destination'] ?? '';

                                          // 🔗 Now lookup FROM location in `locations`
                                          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                            future: FirebaseFirestore.instance
                                                .collection('locations')
                                                .where('name', isEqualTo: originName)
                                                .limit(1)
                                                .get(),
                                            builder: (context, fromSnap) {
                                              if (fromSnap.connectionState == ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              }

                                              final fromDoc = fromSnap.data?.docs.isNotEmpty == true ? fromSnap.data!.docs.first : null;
                                              final fromAddress = fromDoc?.data()['addressLine'] ?? originName;

                                              // 🔗 Now lookup TO location in `locations`
                                              return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                future: FirebaseFirestore.instance
                                                    .collection('locations')
                                                    .where('name', isEqualTo: destinationName)
                                                    .limit(1)
                                                    .get(),
                                                builder: (context, toSnap) {
                                                  if (toSnap.connectionState == ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  }

                                                  final toDoc = toSnap.data?.docs.isNotEmpty == true ? toSnap.data!.docs.first : null;
                                                  final toAddress = toDoc?.data()['addressLine'] ?? destinationName;

                                                  return Text(
                                                    '$fromAddress to $toAddress',
                                                    style: FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .override(
                                                        font: GoogleFonts.interTight(
                                                          fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                          fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Display seat number details
                                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        future: _rideFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}');
                                          }

                                          if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return Text('Ride not found');
                                          }

                                          final data = snapshot.data!.data()!;
                                          final seatCount = data['availableSeats'] ?? 0;

                                          return Text(
                                            '$seatCount seat${seatCount == 1 ? '' : 's'} left',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('trips')
                        .doc(widget.rideId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                          child: Text('Trip not found'),
                        );
                      }

                      final tripData = snapshot.data!.data()!;
                      final passengers = tripData['passengers'] as List<dynamic>? ?? [];
                      // Horizontal scrollable passenger cards
                      if (allPassengers.isNotEmpty) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: allPassengers.map((passenger) {
                              final passengerId = passenger['passengerId'] ?? 'Unknown';
                              final status = passenger['status'] ?? 'unknown';

                              return Container(
                                width: 365,
                                height: 100,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 69, 56, 254),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Avatar/Icon
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                    // Info
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${passenger['name'] ?? 'Unknown'}',
                                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Status: $status',
                                             style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Accept/Reject
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        FFButtonWidget(
                                          onPressed: () async {
                                            debugPrint('Accept pressed for $passengerId');
                                            await _updatePassengerStatus(passengerId, widget.rideId, 'accepted');
                                          },
                                          text: 'Accept',
                                          options: FFButtonOptions(
                                            height: 35,
                                            color: const Color(0xFF00275C),
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                                  color: Colors.white,
                                                ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),

                                        FFButtonWidget(
                                          onPressed: () async {
                                            debugPrint('Reject pressed for $passengerId');
                                            await _updatePassengerStatus(passengerId, widget.rideId, 'rejected');
                                          },
                                          text: 'Reject',
                                          options: FFButtonOptions(
                                            height: 30,
                                            color: const Color(0xFFEF393C),
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return SizedBox(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'No Passengers Found',
                                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      }
                      
                    },
                  ),
                ],
              ),
      
              
              
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 500,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed(
                                      CreateRideStartRideWidget.routeName);
                                },
                                text: 'Complete',
                                options: FFButtonOptions(
                                  height: 46.7,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF00275C),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
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
    );
  }
}

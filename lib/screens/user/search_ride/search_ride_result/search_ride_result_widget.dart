import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/models/trip.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_ride_result_model.dart';
export 'search_ride_result_model.dart';
import 'package:ride_link_carpooling/models/location.dart';
import 'package:ride_link_carpooling/screens/user/search_ride/ride_card.dart';
import 'package:ride_link_carpooling/services/ride_service.dart';

class SearchRideResultWidget extends StatefulWidget {
  const SearchRideResultWidget({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.seats,
  });

  final Location from;
  final Location to;
  final DateTime date;
  final DateTime time;
  final int seats;

  static String routeName = 'searchRideResult';
  static String routePath = '/searchRideResult';

  @override
  State<SearchRideResultWidget> createState() => _SearchRideResultWidgetState();
}

class _SearchRideResultWidgetState extends State<SearchRideResultWidget> {
  late SearchRideResultModel _model;
  bool isLoading = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Trip> trips = [];
  StreamSubscription<QuerySnapshot>? _tripsSubscription;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchRideResultModel());
    _fetchTrips();
  }

  void _fetchTrips() {
    print('[DEBUG] Setting up Firestore stream for scheduled trips at ${DateTime.now()}');
    _tripsSubscription = FirebaseFirestore.instance
        .collection('trips')
        .where('status', isEqualTo: 'scheduled')
        .snapshots()
        .listen((snapshot) async {
      try {
        List<Trip> tripsToShow = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['rideId'] = doc.id;
          return Trip.fromJson(data);
        }).toList();

        // Enrich each Trip with creator details
        final List<Trip> enrichedTrips = [];
        for (final trip in tripsToShow) {
          final creatorUid = trip.creatorId;
          String creatorName = 'Unknown';
          String creatorGender = 'male';

          if (creatorUid.isNotEmpty) {
            try {
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(creatorUid)
                  .get();
              if (userDoc.exists) {
                creatorName = userDoc.data()?['name'] ?? 'Unknown';
                creatorGender = userDoc.data()?['gender'] ?? 'male';
              }
            } catch (e) {
              print('[ERROR] Failed to fetch creator details for $creatorUid: $e at ${DateTime.now()}');
            }
          }

          // Keep rideId when copying trip
          final enrichedTrip = Trip(
            rideId: trip.rideId,
            creatorId: trip.creatorId,
            origin: trip.origin,
            destination: trip.destination,
            departureTime: trip.departureTime,
            availableSeats: trip.availableSeats,
            pricePerSeat: trip.pricePerSeat,
            passengers: trip.passengers,
            status: trip.status,
          );

          enrichedTrips.add(enrichedTrip);
        }

        setState(() {
          trips = enrichedTrips;
          isLoading = false;
          print('[DEBUG] Stream updated with ${trips.length} scheduled trips at ${DateTime.now()}');
        });
      } catch (e) {
        print('[ERROR] Error processing stream snapshot: $e at ${DateTime.now()}');
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (error) {
      print('[ERROR] Stream error: $error at ${DateTime.now()}');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tripsSubscription?.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (trips.isEmpty) {
      return const Center(child: Text('No scheduled rides found.'));
    }

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
            children: [
              // Header section
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  children: [
                    Container(
                      width: 42.16,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              fillColor: Color(0xFFE5E5E5),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFF00275C),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 85.5,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.from.name,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                  ),
                                  Text(
                                    ' to ',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                  ),
                                  Text(
                                    widget.to.name,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
              ),
              // Content section
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: trips.length,
                            itemBuilder: (context, index) {
                              final trip = trips[index];
                              final String formattedTime = TimeOfDay.fromDateTime(trip.departureTime).format(context);

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('users').doc(trip.creatorId).get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 80,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return const SizedBox(
                                      height: 80,
                                      child: Center(child: Text('Error loading driver info')),
                                    );
                                  }

                                  final userData = snapshot.data?.data() as Map<String, dynamic>?;
                                  final creatorName = userData?['name'] ?? 'Unknown';
                                  final creatorGender = userData?['gender'] ?? 'male';

                                  return RideCard(
                                    tripId: trip.rideId,
                                    time: formattedTime,
                                    fromName: trip.origin,
                                    toName: trip.destination,
                                    driverName: creatorName,
                                    gender: creatorGender,
                                    price: trip.pricePerSeat,
                                    creatorId: trip.creatorId,
                                    seatNeeded: widget.seats,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
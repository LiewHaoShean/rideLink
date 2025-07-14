import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<Map<String, dynamic>> rides = [];

  @override
  void initState() {
    super.initState();
    final RideService _rideService = RideService();
    late Future<List<Map<String, dynamic>>> _searchResults;

    _model = createModel(context, () => SearchRideResultModel());
    _fetchRides();
    _searchResults = _rideService.searchRides(
      from: widget.from,
      to: widget.to,
      date: widget.date,
      time: widget.time,
      seatsNeeded: widget.seats,
    );
  }

  Future<void> _fetchRides() async {
    try {
      final result = await RideService().searchRides(
        from: widget.from,
        to: widget.to,
        date: widget.date,
        time: widget.time,
        seatsNeeded: widget.seats,
      );

      List<Map<String, dynamic>> ridesToShow;

      if (result.isEmpty) {
        // Fallback: ALL rides
        final allRidesSnapshot =
            await FirebaseFirestore.instance.collection('temp_rides').get();

        ridesToShow = allRidesSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['rideId'] = doc.id;
          return data;
        }).toList();
      } else {
        ridesToShow = result;
      }

      // Enrich each ride with creator info
      final List<Map<String, dynamic>> enrichedRides = [];

      for (final ride in ridesToShow) {
        final creatorUid = ride['creatorId'] as String?;
        if (creatorUid != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(creatorUid)
              .get();
          ride['creatorName'] = userDoc.exists ? userDoc['name'] ?? 'Unknown' : 'Unknown';
          ride['creatorGender'] = userDoc.exists ? userDoc['gender'] ?? 'male' : 'male';
        } else {
          ride['creatorName'] = 'Unknown';
          ride['creatorGender'] = 'male';
        }

        enrichedRides.add(ride);
      }

      setState(() {
        rides = enrichedRides;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

    if (rides.isEmpty) {
      return const Center(child: Text('No rides found.'));
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
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
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
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.from.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    ' to ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    widget.to.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
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
                            shrinkWrap:
                                true, // needed if inside another scroll view, else remove
                            physics:
                                const NeverScrollableScrollPhysics(), // needed if parent scrolls, else remove
                            itemCount: rides.length,
                            itemBuilder: (context, index) {
                              final ride = rides[index];

                              // Convert Firestore Timestamp safely
                              final Timestamp timeStamp = ride['time'] as Timestamp;
                              final DateTime time = timeStamp.toDate();
                              final String formattedTime = TimeOfDay.fromDateTime(time).format(context);

                              return RideCard(
                                time: formattedTime ?? 'N/A',
                                from: ride['from'] != null ? Location.fromJson(ride['from']) : Location.empty(),
                                to: ride['to'] != null ? Location.fromJson(ride['to']) : Location.empty(),
                                driverName: ride['creatorName'] ?? 'Unknown',
                                gender: ride['creatorGender'] ?? 'male',
                                price: (ride['price'] ?? 0).toDouble(),
                                creatorId: ride['creatorId'] ?? 'Unknown',
                                rideId: ride['rideId'] ?? '',
                                seatNeeded: widget.seats ?? 0,
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

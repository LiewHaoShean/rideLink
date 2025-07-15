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
  late SearchRidePendingRideModel _model;
  Map<String, dynamic>? rideData;
  Map<String, dynamic>? creatorData;
  Map<String, dynamic>? carData;
  List<Map<String, dynamic>> usersInRide = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchRidePendingRideModel());
    _loadRideDetails();
    _fetchUsersInRide();
  }

  /// Load the ride + driver + car in one go
  Future<void> _loadRideDetails() async {
    if (widget.rideId == null) return;

    try {
      // Get the ride doc
      final rideDoc = await FirebaseFirestore.instance
          .collection('temp_rides')
          .doc(widget.rideId)
          .get();

      if (!rideDoc.exists) {
        return;
      }

      final ride = rideDoc.data();
      if (ride == null) return;

      // Get creator info
      final creatorUid = ride['creatorId'] as String?;
      String creatorName = 'Unknown';
      String creatorGender = 'male';

      if (creatorUid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(creatorUid)
            .get();

        if (userDoc.exists) {
          creatorName = userDoc['name'] ?? 'Unknown';
          creatorGender = userDoc['gender'] ?? 'male';
        }
      }

      // Get car info
      Map<String, dynamic>? carInfo;
      if (creatorUid != null) {
        final carQuery = await FirebaseFirestore.instance
            .collection('cars')
            .where('ownerId', isEqualTo: creatorUid)
            .where('isVerified', isEqualTo: true)
            .limit(1)
            .get();

        if (carQuery.docs.isNotEmpty) {
          final doc = carQuery.docs.first;
          carInfo = {
            'carBrand': doc['brand'] ?? 'Unknown',
            'carModel': doc['model'] ?? 'Unknown',
            'carColor': doc['color'] ?? 'Unknown',
            'carPlate': doc['plateNumber'] ?? 'Unknown',
            'carVin': doc['vin'] ?? 'Unknown',
            'carYear': doc['year']?.toString() ?? 'Unknown',
            'carId': doc.id,
          };
        }
      }

      // 4️⃣ Format timestamps
      String formattedDate = 'N/A';
      String formattedTime = 'N/A';

      final gender = creatorData?['gender'] ?? 'male';
      final date = ride['date'] as Timestamp?;
      final time = ride['time'] as Timestamp?;

      if (date != null) {
        formattedDate = DateFormat('EEE, d MMM yyyy').format(date.toDate());
      }

      if (time != null) {
        formattedTime = DateFormat('hh:mm a').format(time.toDate());
      }

      // 5️⃣ Store all in state
      setState(() {
        rideData = {
          'from': ride['from'] ?? '',
          'to': ride['to'] ?? '',
          'price': ride['price'] ?? 0,
          'seats': ride['seats'] ?? 0,
          'formattedDate': formattedDate,
          'formattedTime': formattedTime,
        };
        creatorData = {
          'name': creatorName,
          'gender': creatorGender,
        };
        carData = carInfo;
      });
    } catch (e) {
      print('Error loading ride details: $e');
    }
  }

  Future<void> _fetchUsersInRide() async {
    final doc = await FirebaseFirestore.instance
        .collection('rides')
        .doc(widget.rideId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final users = data?['users'] as List<dynamic>? ?? [];
      setState(() {
        usersInRide = users.cast<Map<String, dynamic>>();
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
                                              context.pushNamed('dashboardHome');
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
                  children: usersInRide.map((user) {
                    return Container(
                      width: 394.5,
                      height: 641,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 10),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                        SearchRidePendingRideWidget.routeName);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 267.4,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF00275C),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 12,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0,
                                                  5,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  SearchRideWaitingDriverWidget
                                                      .routeName);
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 108,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Container(
                                                                  width: 97.9,
                                                                  height: 108,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            rideData?['formattedDate'] ??
                                                                                'N/A',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            rideData?['formattedTime'] ??
                                                                                'N/A',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Container(
                                                                  width: 23.7,
                                                                  height: 108,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 55.5,
                                                                              height: 16.3,
                                                                              decoration: BoxDecoration(),
                                                                              child: Icon(
                                                                                Icons.circle_outlined,
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                size: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 45,
                                                                              child: VerticalDivider(
                                                                                thickness: 2,
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 55.5,
                                                                              height: 16.3,
                                                                              decoration: BoxDecoration(),
                                                                              child: Icon(
                                                                                Icons.circle_outlined,
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                size: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        249.7,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                rideData?['from']?['name'] ?? 'Unknown',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                rideData?['to']?['name'] ?? 'Unknown',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 79.3,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFF00275C),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      0, 0, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Flexible(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            51.1,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFF00275C),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            FaIcon(
                                                                              FontAwesomeIcons.userCircle,
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              size: 40,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          214.6,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xFF00275C),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: 193.41,
                                                                                  height: 28.3,
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            creatorData?['name'] ?? 'Unknown',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  font: GoogleFonts.inter(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                  fontSize: 18,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.male_outlined,
                                                                                              color: FlutterFlowTheme.of(context).secondary,
                                                                                              size: 24,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
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
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          92.2,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Pending',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                  fontSize: 16,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 75.8,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 77.1,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF00275C),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              width: 350,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () {
                                                                                        print('Button pressed ...');
                                                                                      },
                                                                                      text: 'Cancel',
                                                                                      options: FFButtonOptions(
                                                                                        height: 45.66,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                        color: FlutterFlowTheme.of(context).error,
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0,
                                                                                        borderRadius: BorderRadius.circular(8),
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
            ],
          ),
        ),
      ),
    );
  }
}

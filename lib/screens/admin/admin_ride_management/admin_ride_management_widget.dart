import 'package:ride_link_carpooling/providers/trip_provider.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_ride_management_model.dart';
export 'admin_ride_management_model.dart';
import 'package:ride_link_carpooling/services/user_service.dart';
import 'package:ride_link_carpooling/models/user.dart';

class AdminRideManagementWidget extends StatefulWidget {
  const AdminRideManagementWidget({super.key});

  static String routeName = 'adminRideManagement';
  static String routePath = '/adminRideManagement';

  @override
  State<AdminRideManagementWidget> createState() =>
      _AdminRideManagementWidgetState();
}

class _AdminRideManagementWidgetState extends State<AdminRideManagementWidget> {
  late AdminRideManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminRideManagementModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    loadTrips();
  }

  Future<void> loadTrips() async {
    await context.read<TripProvider>().loadTrips();
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 44.0,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Color(0xFF00265C),
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Ride Management',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 360.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              width: 200.0,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  hintText: 'Search Ride',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFEDEDED),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                textAlign: TextAlign.center,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 360.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: FlutterFlowDropDown<String>(
                      controller: _model.dropDownValueController ??=
                          FormFieldController<String>(null),
                      options: ['Ongoing', 'Upcoming', 'Completed', 'Cancel'],
                      onChanged: (val) =>
                          safeSetState(() => _model.dropDownValue = val),
                      width: 200.0,
                      height: 40.0,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      hintText: 'Select...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      elevation: 2.0,
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        width: 100.0,
                        height: 594.57,
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Placeholder content for ride management
                              Consumer<TripProvider>(
                                  builder: (context, tripProvider, child) {
                                if (tripProvider.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (tripProvider.error != null) {
                                  return Center(
                                    child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                        Text(
                                          'Error: ${tripProvider.error}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                            onPressed: () => loadTrips(),
                                            child: Text('Retry')),
                                      ],
                                    ),
                                  );
                                }

                                if (tripProvider.trips.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No trips found',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  );
                                }

                                List filteredTrips = tripProvider.trips;
                                if (_model.textController.text.isEmpty) {
                                  filteredTrips = tripProvider
                                      .searchTrips(_model.textController.text);
                                }

                                return SingleChildScrollView(
                                  child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                      ...filteredTrips.map((trip) => Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 5.0),
                                                    child: Container(
                                              width: double.infinity,
                                              height: 80.0,
                                                      decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                            .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  width: 1.0,
                                                ),
                                                      ),
                                                      child: Padding(
                                                padding: EdgeInsetsDirectional
                                                                .fromSTEB(
                                                        16.0, 12.0, 16.0, 12.0),
                                                        child: Row(
                                                          children: [
                                                    CircleAvatar(
                                                      radius: 25.0,
                                                      backgroundColor:
                                                          Color(0xFFDDDEE0),
                                                      child: Icon(
                                                        Icons.drive_eta,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 30.0,
                                                      ),
                                                    ),
                                                    SizedBox(width: 16.0),
                                                  Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                          children: [
                                                            Text(
                                                            'Sample Ride',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          SizedBox(height: 4.0),
                                                            Text(
                                                            'Ride management content will go here',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                  font:
                                                                      GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                    ),
                                                                Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                      size: 16.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'search_ride_home_widget.dart' show SearchRideHomeWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ride_link_carpooling/models/location.dart';

class SearchRideHomeModel extends FlutterFlowModel<SearchRideHomeWidget> {
  ///  Local state fields for this page.

  int? seatNumber = 1;

  ///  State fields for stateful widgets in this page.
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

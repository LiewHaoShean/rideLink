import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'dashboard_home_widget.dart' show DashboardHomeWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_link_carpooling/models/user.dart';

class DashboardHomeModel extends FlutterFlowModel<DashboardHomeWidget> {
  ///  State fields for stateful widgets in this page.
  UserModel? currentUserProfile;

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      currentUserProfile =
          UserModel.fromJson(snapshot.data()!);
    }
  }

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex => tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex => tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}

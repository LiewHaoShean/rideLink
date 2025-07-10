import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dashboard_security_widget.dart' show DashboardSecurityWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardSecurityModel extends FlutterFlowModel<DashboardSecurityWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailTextField widget.
  FocusNode? emailTextFieldFocusNode;
  TextEditingController? emailTextFieldTextController;
  String? Function(BuildContext, String?)?
      emailTextFieldTextControllerValidator;
  // State field(s) for passwordTextField widget.
  FocusNode? passwordTextFieldFocusNode1;
  TextEditingController? passwordTextFieldTextController1;
  String? Function(BuildContext, String?)?
      passwordTextFieldTextController1Validator;
  // State field(s) for passwordTextField widget.
  FocusNode? passwordTextFieldFocusNode2;
  TextEditingController? passwordTextFieldTextController2;
  String? Function(BuildContext, String?)?
      passwordTextFieldTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailTextFieldFocusNode?.dispose();
    emailTextFieldTextController?.dispose();

    passwordTextFieldFocusNode1?.dispose();
    passwordTextFieldTextController1?.dispose();

    passwordTextFieldFocusNode2?.dispose();
    passwordTextFieldTextController2?.dispose();
  }
}

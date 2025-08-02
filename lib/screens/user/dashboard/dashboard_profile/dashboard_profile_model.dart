import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'dashboard_profile_widget.dart' show DashboardProfileWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardProfileModel extends FlutterFlowModel<DashboardProfileWidget> {
  ///  State fields for stateful widgets in this page.
  FocusNode? emailTextFieldFocusNode;
  TextEditingController? emailTextFieldTextController;
  String? Function(BuildContext, String?)?
      emailTextFieldTextControllerValidator;

  FocusNode? firstNameTextFieldFocusNode;
  TextEditingController? firstNameTextFieldTextController;
  String? Function(BuildContext, String?)?
      firstNameTextFieldTextControllerValidator;

  FocusNode? lastNameTextFieldFocusNode;
  TextEditingController? lastNameTextFieldController;
  String? Function(BuildContext, String?)?
      lastNameTextFieldTextControllerValidator;

  FocusNode? nicTextFieldFocusNode;
  TextEditingController? nicTextFieldTextController;
  String? Function(BuildContext, String?)? nicTextFieldTextControllerValidator;

  FocusNode? phoneTextFieldFocusNode;
  TextEditingController? phoneTextFieldTextController2;
  String? Function(BuildContext, String?)?
      phoneTextFieldTextControllerValidator;

  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailTextFieldFocusNode?.dispose();
    emailTextFieldTextController?.dispose();

    firstNameTextFieldFocusNode?.dispose();
    firstNameTextFieldTextController?.dispose();

    lastNameTextFieldFocusNode?.dispose();
    lastNameTextFieldController?.dispose();

    nicTextFieldFocusNode?.dispose();
    nicTextFieldTextController?.dispose();

    phoneTextFieldFocusNode?.dispose();
    phoneTextFieldTextController2?.dispose();
  }
}

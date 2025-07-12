import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'user_profile_page_widget.dart' show UserProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfilePageModel extends FlutterFlowModel<UserProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailTextField widget.
  FocusNode? emailTextFieldFocusNode1;
  TextEditingController? emailTextFieldTextController1;
  String? Function(BuildContext, String?)? emailTextFieldTextController1Validator;
  // State field(s) for emailTextField widget.
  FocusNode? emailTextFieldFocusNode2;
  TextEditingController? emailTextFieldTextController2;
  String? Function(BuildContext, String?)? emailTextFieldTextController2Validator;
  // State field(s) for passwordlTextField widget.
  FocusNode? passwordlTextFieldFocusNode1;
  TextEditingController? passwordlTextFieldTextController1;
  String? Function(BuildContext, String?)? passwordlTextFieldTextController1Validator;
  // State field(s) for passwordlTextField widget.
  FocusNode? passwordlTextFieldFocusNode2;
  TextEditingController? passwordlTextFieldTextController2;
  String? Function(BuildContext, String?)? passwordlTextFieldTextController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailTextFieldFocusNode1?.dispose();
    emailTextFieldTextController1?.dispose();

    emailTextFieldFocusNode2?.dispose();
    emailTextFieldTextController2?.dispose();

    passwordlTextFieldFocusNode1?.dispose();
    passwordlTextFieldTextController1?.dispose();

    passwordlTextFieldFocusNode2?.dispose();
    passwordlTextFieldTextController2?.dispose();
  }
}

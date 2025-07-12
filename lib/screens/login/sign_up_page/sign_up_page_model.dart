import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'sign_up_page_widget.dart' show SignUpPageWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPageModel extends FlutterFlowModel<SignUpPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailTextField widget.
  FocusNode? emailTextFieldFocusNode;
  TextEditingController? emailTextFieldTextController;
  String? Function(BuildContext, String?)? emailTextFieldTextControllerValidator;
  // State field(s) for passwordlTextField widget.
  FocusNode? passwordlTextFieldFocusNode1;
  TextEditingController? passwordlTextFieldTextController1;
  late bool passwordlTextFieldVisibility1;
  String? Function(BuildContext, String?)? passwordlTextFieldTextController1Validator;
  // State field(s) for passwordlTextField widget.
  FocusNode? passwordlTextFieldFocusNode2;
  TextEditingController? passwordlTextFieldTextController2;
  late bool passwordlTextFieldVisibility2;
  String? Function(BuildContext, String?)?
      passwordlTextFieldTextController2Validator;

  @override
  void initState(BuildContext context) {
    passwordlTextFieldVisibility1 = false;
    passwordlTextFieldVisibility2 = false;
  }

  @override
  void dispose() {
    emailTextFieldFocusNode?.dispose();
    emailTextFieldTextController?.dispose();

    passwordlTextFieldFocusNode1?.dispose();
    passwordlTextFieldTextController1?.dispose();

    passwordlTextFieldFocusNode2?.dispose();
    passwordlTextFieldTextController2?.dispose();
  }
}

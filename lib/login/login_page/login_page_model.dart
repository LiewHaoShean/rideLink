import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailTextField widget.
  FocusNode? emailTextFieldFocusNode;
  TextEditingController? emailTextFieldTextController;
  String? Function(BuildContext, String?)?
      emailTextFieldTextControllerValidator;
  // State field(s) for passwordlTextField widget.
  FocusNode? passwordlTextFieldFocusNode;
  TextEditingController? passwordlTextFieldTextController;
  late bool passwordlTextFieldVisibility;
  String? Function(BuildContext, String?)?
      passwordlTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordlTextFieldVisibility = false;
  }

  @override
  void dispose() {
    emailTextFieldFocusNode?.dispose();
    emailTextFieldTextController?.dispose();

    passwordlTextFieldFocusNode?.dispose();
    passwordlTextFieldTextController?.dispose();
  }
}

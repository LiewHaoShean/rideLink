import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'dashboard_top_up_widget.dart' show DashboardTopUpCreditWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardTopUpCreditModel
    extends FlutterFlowModel<DashboardTopUpCreditWidget> {
  ///  Local state fields for this page.

  int? amount = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for amountTextField widget.
  FocusNode? amountTextFieldFocusNode;
  TextEditingController? amountTextFieldTextController;
  String? Function(BuildContext, String?)?
      amountTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    amountTextFieldFocusNode?.dispose();
    amountTextFieldTextController?.dispose();
  }
}

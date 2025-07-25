import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'dashboard_withdraw_profit_widget.dart'
    show DashboardWithdrawProfitWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardWithdrawProfitModel
    extends FlutterFlowModel<DashboardWithdrawProfitWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for BankDropDown widget.
  String? bankDropDownValue;
  FormFieldController<String>? bankDropDownValueController;
  // State field(s) for BankAccNumberTextField widget.
  FocusNode? bankAccNumberTextFieldFocusNode;
  TextEditingController? bankAccNumberTextFieldTextController;
  String? Function(BuildContext, String?)?
      bankAccNumberTextFieldTextControllerValidator;
  // State field(s) for bankHolderNameTextField widget.
  FocusNode? bankHolderNameTextFieldFocusNode;
  TextEditingController? bankHolderNameTextFieldTextController;
  String? Function(BuildContext, String?)?
      bankHolderNameTextFieldTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    bankAccNumberTextFieldFocusNode?.dispose();
    bankAccNumberTextFieldTextController?.dispose();

    bankHolderNameTextFieldFocusNode?.dispose();
    bankHolderNameTextFieldTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController3?.dispose();
  }
}

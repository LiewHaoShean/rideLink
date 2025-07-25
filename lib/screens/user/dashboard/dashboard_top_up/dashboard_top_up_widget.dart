import 'package:ride_link_carpooling/models/transaction.dart';

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
import 'package:ride_link_carpooling/providers/card_provider.dart';
import 'package:ride_link_carpooling/providers/user_provider.dart';
import 'package:ride_link_carpooling/providers/transaction_provider.dart';

import 'dashboard_top_up_model.dart';
export 'dashboard_top_up_model.dart';

class DashboardTopUpCreditWidget extends StatefulWidget {
  final String userId;
  const DashboardTopUpCreditWidget({Key? key, required this.userId})
      : super(key: key);

  static String routeName = 'dashboardTopUpCredit';
  static String routePath = '/dashboardTopUpCredit';

  @override
  State<DashboardTopUpCreditWidget> createState() =>
      _DashboardTopUpCreditWidgetState();
}

class _DashboardTopUpCreditWidgetState
    extends State<DashboardTopUpCreditWidget> {
  late DashboardTopUpCreditModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Add a state variable to track selected amount
  int _selectedAmount = 0;
  List<String> _cardNumbers = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardTopUpCreditModel());

    _model.amountTextFieldTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      _model.amount?.toString(),
      '0',
    ));
    _model.amountTextFieldFocusNode ??= FocusNode();
    loadCards();
  }

  String maskCardNumber(String cardNumber) {
    // Remove spaces just in case
    String clean = cardNumber.replaceAll(' ', '');
    if (clean.length < 4) return 'Invalid';

    // Extract last 4 digits
    String last4 = clean.substring(clean.length - 4);

    // Return masked version
    return 'XXXX XXXX XXXX $last4';
  }

  Future<void> loadCards() async {
    final cardProvider = context.read<CardProvider>();
    await cardProvider.fetchCardsByUserId(widget.userId);

    // Now access cards from provider and convert
    _cardNumbers = cardProvider.cards
        .map((card) => maskCardNumber(card.cardNumber))
        .toList();
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
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8,
                        buttonSize: 44,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Color(0xFF00265C),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DashboardWalletWidget(userId: widget.userId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'Top Up Credit',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterFlowDropDown<String>(
                        controller: _model.dropDownValueController ??=
                            FormFieldController<String>(null),
                        options: _cardNumbers,
                        onChanged: (val) =>
                            safeSetState(() => _model.dropDownValue = val),
                        width: 360,
                        height: 56,
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
                          size: 24,
                        ),
                        fillColor: Color(0xFFE0E3E7),
                        elevation: 2,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        borderRadius: 8,
                        margin: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 360,
                      height: 56,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.amount = 10;
                                _selectedAmount = 10;
                                _model.amountTextFieldTextController.text =
                                    _model.amount.toString();
                              });
                            },
                            text: '10',
                            options: FFButtonOptions(
                              width: 60,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: _selectedAmount == 10
                                  ? Color(0xFF00265C)
                                  : Color(0xFFE0E3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _selectedAmount == 10
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: Color(0xFF00265C),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.amount = 20;
                                _selectedAmount = 20;
                                _model.amountTextFieldTextController.text =
                                    _model.amount.toString();
                              });
                            },
                            text: '20',
                            options: FFButtonOptions(
                              width: 60,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: _selectedAmount == 20
                                  ? Color(0xFF00265C)
                                  : Color(0xFFE0E3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _selectedAmount == 20
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: Color(0xFF00265C),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.amount = 50;
                                _selectedAmount = 50;
                                _model.amountTextFieldTextController.text =
                                    _model.amount.toString();
                              });
                            },
                            text: '50',
                            options: FFButtonOptions(
                              width: 60,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: _selectedAmount == 50
                                  ? Color(0xFF00265C)
                                  : Color(0xFFE0E3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _selectedAmount == 50
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: Color(0xFF00265C),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.amount = 100;
                                _selectedAmount = 100;
                                _model.amountTextFieldTextController.text =
                                    _model.amount.toString();
                              });
                            },
                            text: '100',
                            options: FFButtonOptions(
                              width: 60,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: _selectedAmount == 100
                                  ? Color(0xFF00265C)
                                  : Color(0xFFE0E3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _selectedAmount == 100
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: Color(0xFF00265C),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                _model.amount = 200;
                                _selectedAmount = 200;
                                _model.amountTextFieldTextController.text =
                                    _model.amount.toString();
                              });
                            },
                            text: '200',
                            options: FFButtonOptions(
                              width: 60,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: _selectedAmount == 200
                                  ? Color(0xFF00265C)
                                  : Color(0xFFE0E3E7),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _selectedAmount == 200
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: Color(0xFF00265C),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 360,
                      height: 56,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: AlignmentDirectional(-1, 0),
                      child: Container(
                        width: 360,
                        child: TextFormField(
                          key: ValueKey(_model.amount!.toString()),
                          controller: _model.amountTextFieldTextController,
                          focusNode: _model.amountTextFieldFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                            hintText: 'Amount',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).alternate,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model
                              .amountTextFieldTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Container(
                    width: 345,
                    height: 54,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            final cardNumber =
                                _model.dropDownValue?.trim() ?? '';

                            final amount = _model
                                .amountTextFieldTextController.text
                                .trim();

                            if (cardNumber.isEmpty ||
                                amount.isEmpty ||
                                int.parse(amount) == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please fill out all fields!')));
                              return;
                            }

                            try {
                              await context
                                  .read<UserProvider>()
                                  .addCredit(widget.userId, int.parse(amount));
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Success"),
                                        content: Text('Top-Up successfully!'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Ok'))
                                        ],
                                      ));
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Failed to Top-Up. Please try again.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Try Again'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final transactionModel = TransactionModel(
                              transactionId: '',
                              userId: widget.userId,
                              amount: int.parse(amount),
                              type: 'Top-up',
                              timestamp: DateTime.now(),
                            );
                            await context
                                .read<TransactionProvider>()
                                .createTransaction(transactionModel);
                          },
                          text: 'Top Up',
                          options: FFButtonOptions(
                            width: 345,
                            height: 54,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: Color(0xFF00265C),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ride_link_carpooling/providers/message_provider.dart';
import 'package:ride_link_carpooling/providers/message_provider.dart';
import 'package:ride_link_carpooling/providers/user_provider.dart';
import 'package:ride_link_carpooling/providers/vehicle_provider.dart';
import 'package:ride_link_carpooling/models/car_information.dart';
import 'package:ride_link_carpooling/models/message.dart';
import 'package:nanoid/nanoid.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'admin_customer_service_details_model.dart';
export 'admin_customer_service_details_model.dart';

class AdminCustomerServiceDetailsWidget extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;

  const AdminCustomerServiceDetailsWidget(
      {Key? key,
      required this.chatId,
      required this.senderId,
      required this.receiverId})
      : super(key: key);

  static String routeName = 'adminCustomerServiceDetails';
  static String routePath = '/adminCustomerServiceDetails';

  @override
  State<AdminCustomerServiceDetailsWidget> createState() =>
      _AdminCustomerServiceDetailsWidgetState();
}

class _AdminCustomerServiceDetailsWidgetState
    extends State<AdminCustomerServiceDetailsWidget> {
  late AdminCustomerServiceDetailsModel _model;
  var _receiver;
  CarInformation? _receiverVehicle;
  String? _hoveredMessageId;
  String? _tappedMessageId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminCustomerServiceDetailsModel());
    _model.textController ??= TextEditingController();
    loadReceiverDetails();
    loadMessages();
  }

  Future<void> loadMessages() async {
    await context.read<MessageProvider>().loadMessagesByChatId(widget.chatId);
  }

  Future<void> loadReceiverDetails() async {
    await context.read<UserProvider>().loadUsers();
    final receiver =
        context.read<UserProvider>().getUserById(widget.receiverId);
    setState(() {
      _receiver = receiver;
    });
    await context.read<VehicleProvider>().loadVehicles();
    final receiverVehicle =
        await context.read<VehicleProvider>().getUserVehicle(widget.receiverId);
    setState(() {
      _receiverVehicle = receiverVehicle;
    });
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8,
                      buttonSize: 40,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Color(0xFF00275C),
                        size: 30,
                      ),
                      onPressed: () {
                        context.safePop();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 370,
                      height: 30,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Text(
                        _receiver?.name ?? "Unknown",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 22,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 370,
                    height: 22,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Text(
                      _receiverVehicle != null
                          ? "${_receiverVehicle?.plateNumber ?? "No Plate Number"}, ${_receiverVehicle?.brand ?? "No brand"} ${_receiverVehicle?.model ?? "No model"}, ${_receiverVehicle?.color ?? "No Color"}"
                          : "",
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: Color(0xFF8C8C8C),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
              Consumer<MessageProvider>(
                builder: (context, messageProvider, child) {
                  if (messageProvider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (messageProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${messageProvider.error}',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => messageProvider
                                .loadMessagesByChatId(widget.chatId),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (messageProvider.messages.isEmpty) {
                    return Container(
                      width: 370.2,
                      height: 579.3,
                      child: Center(
                        child: Text(
                          'No messages found',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    );
                  }

                  var newMessage;
                  if (_model.textController.text.isNotEmpty) {
                    newMessage = _model.textController.text;
                  }

                  return Container(
                    width: 370.2,
                    height: 579.3,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          ...messageProvider.messages.map((message) {
                            if (message.senderId != widget.senderId &&
                                !message.isRead) {
                              // Mark as read if not already
                              context
                                  .read<MessageProvider>()
                                  .markMessageAsRead(message.messageId);
                            }
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_tappedMessageId == message.messageId) {
                                    _tappedMessageId = null;
                                  } else {
                                    _tappedMessageId = message.messageId;
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          message.senderId != widget.senderId
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: message.senderId !=
                                                  widget.senderId
                                              ? Color(0xFFB2B2B2)
                                              : Color(0xFF00265C),
                                          borderRadius: message.senderId !=
                                                  widget.senderId
                                              ? BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                )
                                              : BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(12),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              message.senderId !=
                                                      widget.senderId
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              message.text,
                                              style: TextStyle(
                                                color: message.senderId !=
                                                        widget.senderId
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                            ),
                                            if (_tappedMessageId ==
                                                message.messageId)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                  message.isRead
                                                      ? "Seen"
                                                      : "Sent",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 370,
                    height: 80,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 320,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Enter message',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
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
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            if (_model.textController.text.isNotEmpty) {
                              final newMessageText = _model.textController.text;
                              // Create a new Message object
                              final newMessage = Message(
                                messageId: nanoid(),
                                senderId: widget.senderId,
                                receiverId: widget.receiverId,
                                text: newMessageText,
                                sentAt: DateTime.now(),
                                isRead: false,
                                chatId: widget.chatId,
                              );
                              await context
                                  .read<MessageProvider>()
                                  .createMessage(newMessage);
                              _model.textController?.clear();
                            }
                          },
                          text: 'Button',
                          icon: Icon(
                            Icons.send,
                            size: 25,
                          ),
                          options: FFButtonOptions(
                            width: 50,
                            height: 40,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconAlignment: IconAlignment.start,
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            iconColor: Color(0xFF00265C),
                            color: Colors.white,
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

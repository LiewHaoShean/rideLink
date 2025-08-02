import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_driver_verification_details_model.dart';
export 'admin_driver_verification_details_model.dart';
import 'package:ride_link_carpooling/models/license.dart';
import 'package:ride_link_carpooling/providers/license_provider.dart';
import 'package:ride_link_carpooling/models/car_information.dart';
import 'package:ride_link_carpooling/providers/vehicle_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/models/user.dart';
import 'package:ride_link_carpooling/providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// Admin Driver Verification Details Widget
///
/// This widget allows admins to view driver verification details including:
/// - PDF license document viewer using flutter_pdfview with local download
/// - Vehicle information display
/// - Accept/Reject verification actions
///
/// The PDF viewer supports:
/// - Downloading PDF from URL and caching locally
/// - In-app PDF viewing using flutter_pdfview
/// - External PDF opening using device's default PDF viewer
/// - Loading states and error handling
/// - URL validation for security
class AdminDriverVerificationDetailsWidget extends StatefulWidget {
  final String licenseId;
  const AdminDriverVerificationDetailsWidget({Key? key, required this.licenseId})
      : super(key: key);

  static String routeName = 'adminDriverVerificationDetails';
  static String routePath = '/adminDriverVerificationDetails';

  @override
  State<AdminDriverVerificationDetailsWidget> createState() =>
      _AdminDriverVerificationDetailsWidgetState();
}

class _AdminDriverVerificationDetailsWidgetState
    extends State<AdminDriverVerificationDetailsWidget> {
  late AdminDriverVerificationDetailsModel _model;
  License? _license;
  CarInformation? _userVehicle;
  bool _isLoading = false;
  bool _isPdfLoading = false;
  bool _pdfLoadError = false;
  String? _localPdfPath;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDriverVerificationDetailsModel());
    _fetchLicenseDetails();
  }

  Future<void> _fetchLicenseDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final licenseProvider = context.read<LicenseProvider>();
      final license = await licenseProvider.getLicenseByLicenseId(widget.licenseId);

      setState(() {
        _license = license;
      });

      final vehicleProvider = context.read<VehicleProvider>();
      final vehicle = await vehicleProvider.getUserVehicle(license?.userId ?? '');
      setState(() {
        _userVehicle = vehicle;
      });

      // Load PDF if available
      if (_license?.pdfUrl != null && _license!.pdfUrl!.isNotEmpty) {
        await _loadPdfFromUrl();
      }
    } catch (e) {
      print('Error fetching license details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading license details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPdfFromUrl() async {
    if (_license?.pdfUrl == null || _license!.pdfUrl!.isEmpty) {
      return;
    }

    setState(() {
      _isPdfLoading = true;
      _pdfLoadError = false;
    });

    try {
      // Get local directory
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'license_${_license!.licenseId}.pdf';
      final filePath = '${dir.path}/$fileName';

      // Download the file using Dio
      await Dio().download(_license!.pdfUrl!, filePath);

      setState(() {
        _localPdfPath = filePath;
        _isPdfLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _pdfLoadError = true;
        _isPdfLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _retryPdfLoading() async {
    await _loadPdfFromUrl();
  }

  Future<void> _handleAccept() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final licenseProvider = context.read<LicenseProvider>();

      await licenseProvider.updateLicenseStatus(
          _license?.licenseId ?? '', 'verified');

      await licenseProvider.changeLicenseInformedStatus(
          _license?.userId ?? '', false);

      await FirebaseFirestore.instance
          .collection('cars')
          .doc(_license?.vehicleId ?? '')
          .update({'isVerified': true});

      await context
          .read<UserProvider>()
          .changeUserRole(_license?.userId ?? '', 'driver');

      // Reload the license details to reflect changes
      await _fetchLicenseDetails();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Driver verification accepted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error accepting driver verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting verification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleReject() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final licenseProvider = context.read<LicenseProvider>();

      await licenseProvider.updateLicenseStatus(
          _license?.licenseId ?? '', 'rejected');

      await licenseProvider.changeLicenseInformedStatus(
          _license?.userId ?? '', false);

      // Reload the license details to reflect changes
      await _fetchLicenseDetails();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Driver verification rejected successfully!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      print('Error rejecting driver verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting verification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openPdfInExternalViewer() async {
    if (_license?.pdfUrl == null || _license!.pdfUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No PDF available to open'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(_license!.pdfUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open PDF'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isValidPdfUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Widget _buildPdfViewer() {
    if (_license?.pdfUrl == null || !_isValidPdfUrl(_license!.pdfUrl)) {
      return Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf, size: 64.0, color: FlutterFlowTheme.of(context).secondaryText),
              SizedBox(height: 16.0),
              Text(
                'No PDF Document Available',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'The license document has not been uploaded yet.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_isPdfLoading) {
      return Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00265C)),
              ),
              SizedBox(height: 16.0),
              Text(
                'Downloading PDF...',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (_pdfLoadError) {
      return Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.0, color: Colors.red),
              SizedBox(height: 16.0),
              Text(
                'Failed to load PDF',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'The PDF document could not be downloaded.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FFButtonWidget(
                    onPressed: _retryPdfLoading,
                    text: 'Retry',
                    options: FFButtonOptions(
                      width: 100.0,
                      height: 40.0,
                      color: Color(0xFF00265C),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  FFButtonWidget(
                    onPressed: _openPdfInExternalViewer,
                    text: 'Open Externally',
                    options: FFButtonOptions(
                      width: 140.0,
                      height: 40.0,
                      color: Colors.green,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (_localPdfPath != null) {
      return PDFView(
        filePath: _localPdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
      );
    }

    return Container(
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Center(
        child: Text(
          'PDF not loaded',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      ),
    );
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
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 44.0,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Color(0xFF00265C),
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'License Verification',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                          font: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 10.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                  child: _isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00265C)),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Loading license details...',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : _license?.pdfUrl != null &&
                              _license!.pdfUrl!.isNotEmpty &&
                              _isValidPdfUrl(_license!.pdfUrl)
                          ? Column(
                              children: [
                                // PDF Header
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Color(0xFF00265C),
                                        size: 24.0,
                                      ),
                                      SizedBox(width: 12.0),
                                      Expanded(
                                        child: Text(
                                          _license?.fileName ?? 'License Document',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 36.0,
                                        fillColor: Color(0xFF00265C),
                                        icon: Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onPressed: _openPdfInExternalViewer,
                                      ),
                                    ],
                                  ),
                                ),
                                // PDF Viewer
                                Expanded(
                                  child: _buildPdfViewer(),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'No PDF Document Available',
                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      fontFamily: 'Inter',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'The license document has not been uploaded yet.',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
              // ... rest of your existing UI code for vehicle details and buttons
              // (Keep all the existing vehicle details and buttons code as is)
            ],
          ),
        ),
      ),
    );
  }
}
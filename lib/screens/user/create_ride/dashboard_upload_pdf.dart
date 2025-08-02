import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/main.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/storage_service.dart';
import '/index.dart';
import 'package:ride_link_carpooling/models/license.dart';
import 'package:ride_link_carpooling/providers/license_provider.dart';

class DashboardUploadPdfWidget extends StatefulWidget {
  final String userId;
  final String vehicleId;
  const DashboardUploadPdfWidget(
      {Key? key, required this.userId, required this.vehicleId})
      : super(key: key);

  static String routeName = 'dashboardUploadPdf';
  static String routePath = '/dashboardUploadPdf';

  @override
  State<DashboardUploadPdfWidget> createState() =>
      _DashboardUploadPdfWidgetState();
}

class _DashboardUploadPdfWidgetState extends State<DashboardUploadPdfWidget> {
  final StorageService _storageService = StorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedPdfFile;
  String? _uploadedPdfUrl;
  bool _isUploading = false;
  bool _isUploaded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    _titleController.text = 'Driver License';
    _descriptionController.text = 'Requesting to be a driver.';
  }

  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedPdfFile = File(result.files.single.path!);
          _isUploaded = false;
          _uploadedPdfUrl = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF selected: ${result.files.single.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking PDF file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadPdf() async {
    if (_selectedPdfFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a PDF file first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title for the document'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Upload PDF to Firebase Storage
      final String downloadUrl = await _storageService.uploadPdf(
        pdfFile: _selectedPdfFile!,
        folder: 'licenses',
        customFileName: 'license_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final license = License(
          licenseId: '',
          vehicleId: widget.vehicleId,
          userId: widget.userId,
          status: 'pending',
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          pdfUrl: downloadUrl,
          fileName: _selectedPdfFile!.path.split('/').last,
          isInformed: true);

      // Store PDF information in Firestore
      await context.read<LicenseProvider>().createLicense(license);

      setState(() {
        _uploadedPdfUrl = downloadUrl;
        _isUploaded = true;
      });

      // Hide loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'PDF uploaded successfully! It might take a while for approval!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavBarPage(
            initialPage: 'dashboardHome',
          ),
        ),
      );

      // Clear form
      _clearForm();
    } catch (e) {
      // Hide loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _selectedPdfFile = null;
      _titleController.clear();
      _descriptionController.clear();
      _isUploaded = false;
      _uploadedPdfUrl = null;
    });
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
              // Header
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 44.0,
                        fillColor: Color(0xFFE5E5E5),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Upload License PDF',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PDF Selection Section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedPdfFile != null
                                  ? Colors.green
                                  : FlutterFlowTheme.of(context).secondaryText,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    color: Color(0xFF00265C),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Select PDF File',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Upload your license or any relevant document in PDF format',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: FFButtonWidget(
                                      onPressed:
                                          _isUploading ? null : _pickPdfFile,
                                      text: _selectedPdfFile != null
                                          ? 'Change PDF'
                                          : 'Choose PDF File',
                                      icon: Icon(
                                        Icons.file_present,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50,
                                        color: Color(0xFF00265C),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              color: Colors.white,
                                            ),
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_selectedPdfFile != null) ...[
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedPdfFile!.path
                                              .split('/')
                                              .last,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Title Input
                        Text(
                          'Document Title *',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText:
                                'Enter document title (e.g., Driver License)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),

                        SizedBox(height: 16),

                        // Description Input
                        Text(
                          'Description (Optional)',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter description or additional notes',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),

                        SizedBox(height: 32),

                        // Upload Button
                        Row(
                          children: [
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: _isUploading ? null : _uploadPdf,
                                text: _isUploading
                                    ? 'Uploading...'
                                    : 'Upload PDF',
                                icon: _isUploading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Icon(
                                        Icons.cloud_upload,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 56,
                                  color: _isUploading
                                      ? FlutterFlowTheme.of(context)
                                          .secondaryText
                                      : Color(0xFF00265C),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: Colors.white,
                                      ),
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_isUploaded && _uploadedPdfUrl != null) ...[
                          SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Upload Successful!',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            color: Colors.green,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Your PDF has been uploaded successfully. You can view it in your documents.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          // Navigate to PDF viewer or open URL
                                          // You can implement PDF viewing functionality here
                                        },
                                        text: 'View PDF',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 40,
                                          color: Colors.green,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: _clearForm,
                                        text: 'Upload Another',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 40,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

import 'dart:async';
import 'package:ride_link_carpooling/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'search_ride_waiting_driver_model.dart';
export 'search_ride_waiting_driver_model.dart';

class SearchRideWaitingDriverWidget extends StatefulWidget {
  final String rideId;

  const SearchRideWaitingDriverWidget({
    super.key,
    required this.rideId,
  });

  static String routeName = 'searchRideWaitingDriver';
  static String routePath = '/searchRideWaitingDriver';

  @override
  State<SearchRideWaitingDriverWidget> createState() =>
      _SearchRideWaitingDriverWidgetState();
}

class _SearchRideWaitingDriverWidgetState
    extends State<SearchRideWaitingDriverWidget> {
  late SearchRideWaitingDriverModel _model;
  List<Map<String, dynamic>> _userTrips = [];
  bool isLoading = true;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  StreamSubscription<DocumentSnapshot>? _tripSubscription;
  bool _hasNavigated = false;
  String? _userRole;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = SearchRideWaitingDriverModel();
    _initializeData();
  }

  @override
  void dispose() {
    _tripSubscription?.cancel();
    _model.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('[DEBUG] No user signed in at ${DateTime.now()}');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        _userRole = userDoc.data()?['userRole']?.toString().toLowerCase();
        print(
            '[DEBUG] User role: $_userRole for UID: ${user.uid} at ${DateTime.now()}');
      } else {
        print(
            '[DEBUG] User doc does not exist for UID: ${user.uid} at ${DateTime.now()}');
      }
    } catch (e) {
      print('[ERROR] Failed to fetch user role: $e at ${DateTime.now()}');
    }

    final trips = await _fetchUserTrips();
    setState(() {
      _userTrips = trips;
      isLoading = false;
      _updateMapMarkers();
    });

    if (_userRole == 'passenger') {
      _setupTripStatusListener();
    }
  }

  void _setupTripStatusListener() {
    print(
        '[DEBUG] Setting up Firestore listener for trip ${widget.rideId} at ${DateTime.now()}');
    _tripSubscription = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.rideId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        print(
            '[DEBUG] Trip ${widget.rideId} does not exist or has no data at ${DateTime.now()}');
        return;
      }
      final tripData = snapshot.data()!;
      print(
          '[DEBUG] Trip ${widget.rideId} status: ${tripData['status']} at ${DateTime.now()}');
      if (tripData['status'] == 'finished' && !_hasNavigated) {
        print(
            '[DEBUG] Triggering dialog for finished trip ${widget.rideId} at ${DateTime.now()}');
        _hasNavigated = true;
        _showTripFinishedAlert();
      }
    }, onError: (error) {
      print(
          '[ERROR] Trip listener error for ${widget.rideId}: $error at ${DateTime.now()}');
    });
  }

  void _showTripFinishedAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ride Completed'),
        content: const Text('The driver has completed the ride!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pushNamed(
                SearchRideCompleteWidget.routeName,
                queryParameters: {'rideId': widget.rideId},
              ).then((_) {
                print(
                    '[DEBUG] Successfully navigated to SearchRideCompleteWidget with rideId: ${widget.rideId} at ${DateTime.now()}');
              }).catchError((error) {
                print('[ERROR] Navigation failed: $error at ${DateTime.now()}');
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUserTrips() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      print(
          '[DEBUG] No user signed in — returning empty list at ${DateTime.now()}');
      return [];
    }

    print(
        '[DEBUG] Fetching trip ${widget.rideId} for user: $currentUserId at ${DateTime.now()}');
    final doc = await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.rideId)
        .get();

    if (!doc.exists) {
      print('[DEBUG] Trip ${widget.rideId} not found at ${DateTime.now()}');
      return [];
    }

    final tripData = doc.data()!;
    final passengers = tripData['passengers'] as List<dynamic>? ?? [];
    Map<String, dynamic>? matchedTrip;

    for (final p in passengers) {
      final map = p as Map<String, dynamic>;
      if (map['passengerId'] == currentUserId &&
          (map['status'] == 'joined' || map['status'] == 'accepted')) {
        print('[DEBUG] Trip ${doc.id} matched for user at ${DateTime.now()}');
        final creatorId = tripData['creatorId'];
        String creatorName = 'Unknown Driver';

        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(creatorId)
              .get();
          if (userDoc.exists) {
            creatorName = userDoc.data()?['name'] ?? 'Unknown Driver';
          }
        } catch (e) {
          print(
              '[ERROR] Failed to fetch creatorName for $creatorId: $e at ${DateTime.now()}');
        }

        Map<String, dynamic>? carData;
        try {
          final carQuery = await FirebaseFirestore.instance
              .collection('cars')
              .where('ownerId', isEqualTo: creatorId)
              .limit(1)
              .get();
          if (carQuery.docs.isNotEmpty) {
            carData = carQuery.docs.first.data();
          }
        } catch (e) {
          print(
              '[ERROR] Failed to fetch car data for $creatorId: $e at ${DateTime.now()}');
        }

        LatLng? originLatLng;
        try {
          final originQuery = await FirebaseFirestore.instance
              .collection('locations')
              .where('name', isEqualTo: tripData['origin'])
              .limit(1)
              .get();
          if (originQuery.docs.isNotEmpty) {
            final originData = originQuery.docs.first.data();
            originLatLng = LatLng(
              (originData['latitude'] as num).toDouble(),
              (originData['longitude'] as num).toDouble(),
            );
          }
        } catch (e) {
          print(
              '[ERROR] Failed to fetch origin coordinates for ${tripData['origin']}: $e at ${DateTime.now()}');
        }

        LatLng? destinationLatLng;
        try {
          final destinationQuery = await FirebaseFirestore.instance
              .collection('locations')
              .where('name', isEqualTo: tripData['destination'])
              .limit(1)
              .get();
          if (destinationQuery.docs.isNotEmpty) {
            final destinationData = destinationQuery.docs.first.data();
            destinationLatLng = LatLng(
              (destinationData['latitude'] as num).toDouble(),
              (destinationData['longitude'] as num).toDouble(),
            );
          }
        } catch (e) {
          print(
              '[ERROR] Failed to fetch destination coordinates for ${tripData['destination']}: $e at ${DateTime.now()}');
        }

        final departureTimestamp = tripData['departureTime'];
        DateTime? departureTime;
        if (departureTimestamp is Timestamp) {
          departureTime = departureTimestamp.toDate();
        }

        matchedTrip = {
          'tripId': doc.id,
          'status': map['status'],
          'origin': tripData['origin'],
          'destination': tripData['destination'],
          'departureTime': departureTime,
          'creatorName': creatorName,
          'car': carData,
          'originLatLng': originLatLng,
          'destinationLatLng': destinationLatLng,
        };
        break;
      }
    }

    return matchedTrip != null ? [matchedTrip] : [];
  }

  void _updateMapMarkers() {
    final markers = <Marker>{};
    if (_userTrips.isNotEmpty) {
      final trip = _userTrips[0];
      if (trip['originLatLng'] != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: trip['originLatLng'] as LatLng,
            infoWindow: InfoWindow(title: trip['origin']),
          ),
        );
      }
      if (trip['destinationLatLng'] != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: trip['destinationLatLng'] as LatLng,
            infoWindow: InfoWindow(title: trip['destination']),
          ),
        );
      }
    }
    setState(() {
      _markers = markers;
    });

    if (_mapController != null && _markers.isNotEmpty) {
      final bounds = _computeBounds();
      if (bounds != null) {
        _mapController!
            .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
      } else if (_userTrips.isNotEmpty &&
          _userTrips[0]['originLatLng'] != null) {
        _mapController!.animateCamera(
            CameraUpdate.newLatLng(_userTrips[0]['originLatLng'] as LatLng));
      }
    }
  }

  LatLngBounds? _computeBounds() {
    if (_userTrips.isEmpty ||
        _userTrips[0]['originLatLng'] == null ||
        _userTrips[0]['destinationLatLng'] == null) {
      return null;
    }
    final origin = _userTrips[0]['originLatLng'] as LatLng;
    final destination = _userTrips[0]['destinationLatLng'] as LatLng;
    final southWest = LatLng(
      origin.latitude < destination.latitude
          ? origin.latitude
          : destination.latitude,
      origin.longitude < destination.longitude
          ? origin.longitude
          : destination.longitude,
    );
    final northEast = LatLng(
      origin.latitude > destination.latitude
          ? origin.latitude
          : destination.latitude,
      origin.longitude > destination.longitude
          ? origin.longitude
          : destination.longitude,
    );
    return LatLngBounds(southwest: southWest, northeast: northEast);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                child: Row(
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: const Color(0xFFE5E5E5),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF00275C),
                        size: 24.0,
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('trips')
                              .doc(widget.rideId)
                              .update({
                            'status': 'scheduled',
                          });
                          Navigator.of(context).pop();
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text('Failed to update trip status: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Starting The Ride',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Inter Tight',
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20.0)),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400.0,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _userTrips.isNotEmpty &&
                                            _userTrips[0]['originLatLng'] !=
                                                null
                                        ? _userTrips[0]['originLatLng']
                                            as LatLng
                                        : const LatLng(3.1390, 101.6869),
                                    zoom: 14.0,
                                  ),
                                  markers: _markers,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController = controller;
                                    _updateMapMarkers();
                                  },
                                  trafficEnabled: false,
                                  myLocationEnabled: false,
                                  compassEnabled: false,
                                ),
                        ),
                        const Divider(
                          thickness: 2.0,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 55.0,
                                height: 55.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _userTrips.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _userTrips[0]['creatorName'] ??
                                                    'Unknown Driver',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Text(
                                                _userTrips[0]['car'] != null
                                                    ? '${_userTrips[0]['car']['plateNumber']}, ${_userTrips[0]['car']['brand']} ${_userTrips[0]['car']['model']}, ${_userTrips[0]['car']['color']}'
                                                    : 'Car info unavailable',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 14.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          )
                                        : const Text('Loading...'),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00275C),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Text(
                                  _userRole == 'driver'
                                      ? 'Driver'
                                      : 'Passenger',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: () =>
                                      print('Message button pressed'),
                                  text: 'Message to Driver',
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    color: const Color(0xFFF6F7FA),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: const Color(0xFF9D9FA0),
                                          letterSpacing: 0.0,
                                        ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              FlutterFlowIconButton(
                                borderRadius: 100.0,
                                buttonSize: 40.0,
                                fillColor: const Color(0xFFF6F7FA),
                                icon: const Icon(
                                  Icons.phone_enabled,
                                  color: Color(0xFF00275C),
                                  size: 24.0,
                                ),
                                onPressed: () => print('Phone button pressed'),
                              ),
                            ],
                          ),
                        ),
                        if (_userRole == 'driver')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('trips')
                                      .doc(widget.rideId)
                                      .update({
                                    'status': 'finished',
                                  });
                                  context.pushNamed(
                                    CreateRideCompleteWidget.routeName,
                                    queryParameters: {
                                      'rideId': widget.rideId,
                                    },
                                  ).then((_) {
                                    print(
                                        '[DEBUG] Successfully navigated to CreateRideCompleteWidget with rideId: ${widget.rideId} at ${DateTime.now()}');
                                  }).catchError((error) {
                                    print(
                                        '[ERROR] Navigation failed: $error at ${DateTime.now()}');
                                  });
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Error'),
                                      content: Text(
                                          'Failed to update trip status: $e'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              text: 'Complete',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
                                color: const Color.fromARGB(255, 49, 94, 255),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      letterSpacing: 0.0,
                                    ),
                                borderRadius: BorderRadius.circular(8.0),
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
        ),
      ),
    );
  }
}

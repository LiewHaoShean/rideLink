import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:ride_link_carpooling/providers/chat_provider.dart';
import 'package:ride_link_carpooling/providers/message_provider.dart';
import 'package:ride_link_carpooling/providers/trip_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/vehicle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches.map((e) => getRoute(e)).toList();

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RideLink Carpooling',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'searchRideHome';
  late Widget? _currentPage;
  StreamSubscription<QuerySnapshot>? _tripSubscription;
  StreamSubscription<User?>? _authSubscription;
  final Set<String> _navigatedTrips = {};

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
    _setupAuthListener();
  }

  @override
  void dispose() {
    _tripSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  void _setupAuthListener() {
    print('[DEBUG] Setting up auth state listener at ${DateTime.now()}');
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      print('[DEBUG] Auth state changed: ${user?.uid ?? "No user"} at ${DateTime.now()}');
      _tripSubscription?.cancel();
      if (user != null) {
        _startTripStatusListener(user);
      } else {
        print('[DEBUG] No user signed in — skipping trip status listener at ${DateTime.now()}');
      }
    }, onError: (error) {
      print('[ERROR] Auth state listener error: $error at ${DateTime.now()}');
    });
  }

  void _startTripStatusListener(User user) {
    print('[DEBUG] Fetching user role for UID: ${user.uid} at ${DateTime.now()}');
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((userDoc) {
      if (!userDoc.exists || userDoc.data()?['userRole']?.toString().toLowerCase() != 'passenger') {
        print('[DEBUG] User is not a passenger or doc does not exist: ${userDoc.data()?.toString() ?? "No data"} at ${DateTime.now()}');
        return;
      }

      print('[DEBUG] Setting up Firestore listener for passenger trips at ${DateTime.now()}');
      _tripSubscription = FirebaseFirestore.instance
          .collection('trips')
          .where('passengers', arrayContainsAny: [
            {'passengerId': user.uid, 'status': 'accepted'}
          ])
          .snapshots()
          .listen((snapshot) {
        print('[DEBUG] Snapshot received with ${snapshot.docChanges.length} changes at ${DateTime.now()}');
        for (var change in snapshot.docChanges) {
          final tripData = change.doc.data();
          if (tripData == null) {
            print('[DEBUG] Trip data is null for doc: ${change.doc.id} at ${DateTime.now()}');
            continue;
          }

          print('[DEBUG] Trip ${change.doc.id} status: ${tripData['status']} at ${DateTime.now()}');
          if (tripData['status'] == 'ongoing' && !_navigatedTrips.contains(change.doc.id)) {
            print('[DEBUG] Triggering dialog for trip ${change.doc.id} at ${DateTime.now()}');
            _navigatedTrips.add(change.doc.id);
            _showTripStartedAlert(change.doc.id);
          }
        }
      }, onError: (error) {
        print('[ERROR] Trip listener error: $error at ${DateTime.now()}');
      });
    }).catchError((error) {
      print('[ERROR] Failed to fetch user role: $error at ${DateTime.now()}');
    });
  }

  void _showTripStartedAlert(String rideId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ride Started'),
        content: const Text('The driver has started the ride!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pushNamed(
                SearchRideWaitingDriverWidget.routeName,
                queryParameters: {'rideId': rideId},
              ).then((_) {
                print('[DEBUG] Successfully navigated to SearchRideWaitingDriverWidget with rideId: $rideId at ${DateTime.now()}');
              }).catchError((error) {
                print('[ERROR] Navigation failed: $error at ${DateTime.now()}');
                MyApp.of(context)._router.pushNamed(
                  SearchRideWaitingDriverWidget.routeName,
                  queryParameters: {'rideId': rideId},
                );
                print('[DEBUG] Fallback navigation attempted with rideId: $rideId at ${DateTime.now()}');
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().userId ?? '';
    final tabs = {
      'searchRideHome': const SearchRideHomeWidget(),
      'createRideHome': const CreateRideHomeWidget(),
      'messageMain': MessageMainWidget(senderId: userId),
      'dashboardHome': const DashboardHomeWidget(),
      'searchRidePendingRide': const SearchRidePendingRideWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        selectedItemColor: const Color(0xFF00275C),
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 24.0),
            label: 'Search',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 24.0),
            label: 'Add',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 24.0),
            label: 'Message',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined, size: 24.0),
            label: 'profile',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta, size: 24.0),
            label: 'Ride',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}
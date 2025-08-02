import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:ride_link_carpooling/models/location.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => HomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => HomePageWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: LoginPageWidget.routeName,
          path: LoginPageWidget.routePath,
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: SignUpPageWidget.routeName,
          path: SignUpPageWidget.routePath,
          builder: (context, params) => SignUpPageWidget(),
        ),
        FFRoute(
          name: VerificationPageWidget.routeName,
          path: VerificationPageWidget.routePath,
          builder: (context, params) => VerificationPageWidget(
            type: params.getParam('type', ParamType.String),
            email: params.getParam('email', ParamType.String),
            password: params.getParam('password', ParamType.String),
          ),
        ),
        FFRoute(
          name: UserProfilePageWidget.routeName,
          path: UserProfilePageWidget.routePath,
          builder: (context, params) => UserProfilePageWidget(),
        ),
        FFRoute(
          name: SuccessPageWidget.routeName,
          path: SuccessPageWidget.routePath,
          builder: (context, params) => SuccessPageWidget(
            title: params.getParam(
              'title',
              ParamType.String,
            ),
            description: params.getParam(
              'description',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: SearchRideHomeWidget.routeName,
          path: SearchRideHomeWidget.routePath,
          builder: (context, params) =>
              NavBarPage(initialPage: 'searchRideHome'),
        ),
        FFRoute(
          name: CreateRideHomeWidget.routeName,
          path: CreateRideHomeWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'createRideHome')
              : CreateRideHomeWidget(),
        ),
        FFRoute(
          name: SearchRideResultWidget.routeName,
          path: SearchRideResultWidget.routePath,
          builder: (context, params) {
            final fromJson =
                jsonDecode(params.getParam('from', ParamType.String) ?? '{}')
                    as Map<String, dynamic>;
            final toJson =
                jsonDecode(params.getParam('to', ParamType.String) ?? '{}')
                    as Map<String, dynamic>;

            return SearchRideResultWidget(
              from: Location.fromJson(fromJson),
              to: Location.fromJson(toJson),
              date: DateTime.parse(params.getParam('date', ParamType.String)!),
              time: DateTime.parse(params.getParam('time', ParamType.String)!),
              seats: int.parse(params.getParam('seats', ParamType.String)!),
            );
          },
        ),
        FFRoute(
          name: SearchRideDetailsWidget.routeName,
          path: SearchRideDetailsWidget.routePath,
          builder: (context, params) => SearchRideDetailsWidget(
            rideId: params.getParam('rideId', ParamType.String),
            creatorId: params.getParam('creatorId', ParamType.String),
            seatNeeded: int.tryParse(
                params.getParam('seatNeeded', ParamType.String) ?? '0'),
          ),
        ),
        FFRoute(
          name: CreateRideWaitingListWidget.routeName,
          path: CreateRideWaitingListWidget.routePath,
          builder: (context, params) => CreateRideWaitingListWidget(
            rideId: params.getParam('rideId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: CreateRideStartRideWidget.routeName,
          path: CreateRideStartRideWidget.routePath,
          builder: (context, params) => CreateRideStartRideWidget(
            rideId: params.getParam('rideId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: CreateRideCompleteWidget.routeName,
          path: CreateRideCompleteWidget.routePath,
          builder: (context, params) => CreateRideCompleteWidget(
            rideId: params.getParam('rideId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: DashboardUploadPdfWidget.routeName,
          path: DashboardUploadPdfWidget.routePath,
          builder: (context, params) => DashboardUploadPdfWidget(
              userId: params.getParam('userId', ParamType.String) ?? '',
              vehicleId: params.getParam('vehicleId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: MessageMainWidget.routeName,
          path: MessageMainWidget.routePath,
          builder: (context, params) => MessageMainWidget(
            senderId: params.getParam('userId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: MessageDetailsWidget.routeName,
          path: MessageDetailsWidget.routePath,
          builder: (context, params) => MessageDetailsWidget(
            senderId: params.getParam('userId', ParamType.String) ?? '',
            chatId: params.getParam('chatId', ParamType.String) ?? '',
            receiverId: params.getParam('receiverId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: NotificationDetailWidget.routeName,
          path: NotificationDetailWidget.routePath,
          builder: (context, params) => NotificationDetailWidget(),
        ),
        FFRoute(
          name: DashboardHomeWidget.routeName,
          path: DashboardHomeWidget.routePath,
          builder: (context, params) => DashboardHomeWidget(
              userId: params.getParam('userId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: DashboardSecurityWidget.routeName,
          path: DashboardSecurityWidget.routePath,
          builder: (context, params) => DashboardSecurityWidget(),
        ),
        FFRoute(
          name: DashboardWalletWidget.routeName,
          path: DashboardWalletWidget.routePath,
          builder: (context, params) => DashboardWalletWidget(
            userId: params.getParam('userId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: DashboardAddCardWidget.routeName,
          path: DashboardAddCardWidget.routePath,
          builder: (context, params) => DashboardAddCardWidget(
              userId: params.getParam('userId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: DashboardTransactionsWidget.routeName,
          path: DashboardTransactionsWidget.routePath,
          builder: (context, params) => DashboardTransactionsWidget(
              userId: params.getParam('userId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: DashboardTransactionDetailsWidget.routeName,
          path: DashboardTransactionDetailsWidget.routePath,
          builder: (context, params) => DashboardTransactionDetailsWidget(
              transactionId:
                  params.getParam('transactionId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: DashboardChangePasswordWidget.routeName,
          path: DashboardChangePasswordWidget.routePath,
          builder: (context, params) => DashboardChangePasswordWidget(),
        ),
        FFRoute(
          name: DashboardVehicleWidget.routeName,
          path: DashboardVehicleWidget.routePath,
          builder: (context, params) => DashboardVehicleWidget(),
        ),
        FFRoute(
          name: DashboardEditVehicleWidget.routeName,
          path: DashboardEditVehicleWidget.routePath,
          builder: (context, params) => DashboardEditVehicleWidget(),
        ),
        FFRoute(
          name: DriverRegisterWidget.routeName,
          path: DriverRegisterWidget.routePath,
          builder: (context, params) => DriverRegisterWidget(),
        ),
        FFRoute(
          name: VehicleRegisterWidget.routeName,
          path: VehicleRegisterWidget.routePath,
          builder: (context, params) => VehicleRegisterWidget(),
        ),
        FFRoute(
          name: LicenseVerificationWidget.routeName,
          path: LicenseVerificationWidget.routePath,
          builder: (context, params) => LicenseVerificationWidget(),
        ),
        FFRoute(
          name: ProcessingPageWidget.routeName,
          path: ProcessingPageWidget.routePath,
          builder: (context, params) => ProcessingPageWidget(),
        ),
        FFRoute(
          name: FailPageWidget.routeName,
          path: FailPageWidget.routePath,
          builder: (context, params) => FailPageWidget(
              title: params.getParam('title', ParamType.String) ?? '',
              description:
                  params.getParam('description', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: SearchRideWaitingDriverWidget.routeName,
          path: SearchRideWaitingDriverWidget.routePath,
          builder: (context, params) => SearchRideWaitingDriverWidget(
              rideId: params.getParam('rideId', ParamType.String) ?? '',
              senderId: params.getParam('senderId', ParamType.String) ?? '',
              receiverId:
                  params.getParam('receiverId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: SearchRidePendingRideWidget.routeName,
          path: SearchRidePendingRideWidget.routePath,
          builder: (context, params) => SearchRidePendingRideWidget(
            rideId: params.getParam('rideId', ParamType.String),
            creatorId: params.getParam('creatorId', ParamType.String),
            carId: params.getParam('carId', ParamType.String),
            seatNeeded: params.getParam('seatNeeded', ParamType.int),
          ),
        ),
        FFRoute(
          name: SearchRideCompleteWidget.routeName,
          path: SearchRideCompleteWidget.routePath,
          builder: (context, params) => SearchRideCompleteWidget(
            rideId: params.getParam('rideId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (context, params) => HomeWidget(),
        ),
        FFRoute(
          name: AdminUserManagementWidget.routeName,
          path: AdminUserManagementWidget.routePath,
          builder: (context, params) => AdminUserManagementWidget(),
        ),
        FFRoute(
          name: AdminUserDetailsWidget.routeName,
          path: AdminUserDetailsWidget.routePath,
          builder: (context, params) => AdminUserDetailsWidget(
            userId: params.getParam<String>('userId', ParamType.String)!,
          ),
        ),
        FFRoute(
          name: AdminRideManagementWidget.routeName,
          path: AdminRideManagementWidget.routePath,
          builder: (context, params) => AdminRideManagementWidget(),
        ),
        FFRoute(
          name: AdminRideDetailsWidget.routeName,
          path: AdminRideDetailsWidget.routePath,
          builder: (context, params) => AdminRideDetailsWidget(
            tripId: params.getParam('rideId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: AdminDriverVerificationWidget.routeName,
          path: AdminDriverVerificationWidget.routePath,
          builder: (context, params) => AdminDriverVerificationWidget(),
        ),
        FFRoute(
          name: AdminDriverVerificationDetailsWidget.routeName,
          path: AdminDriverVerificationDetailsWidget.routePath,
          builder: (context, params) => AdminDriverVerificationDetailsWidget(
              licenseId: params.getParam('licenseId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: AdminFinanceWidget.routeName,
          path: AdminFinanceWidget.routePath,
          builder: (context, params) => AdminFinanceWidget(),
        ),
        FFRoute(
          name: AdminCustomerServiceWidget.routeName,
          path: AdminCustomerServiceWidget.routePath,
          builder: (context, params) => AdminCustomerServiceWidget(
              senderId: params.getParam('userId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: AdminCustomerServiceDetailsWidget.routeName,
          path: AdminCustomerServiceDetailsWidget.routePath,
          builder: (context, params) => AdminCustomerServiceDetailsWidget(
            senderId: params.getParam('userId', ParamType.String) ?? '',
            chatId: params.getParam('chatId', ParamType.String) ?? '',
            receiverId: params.getParam('receiverId', ParamType.String) ?? '',
          ),
        ),
        FFRoute(
          name: AdminSecurityWidget.routeName,
          path: AdminSecurityWidget.routePath,
          builder: (context, params) => AdminSecurityWidget(
              userId: params.getParam('userId', ParamType.String) ?? ''),
        ),
        FFRoute(
          name: AdminChangePasswordWidget.routeName,
          path: AdminChangePasswordWidget.routePath,
          builder: (context, params) => AdminChangePasswordWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: ConfirmEmailWidget.routeName,
          path: ConfirmEmailWidget.routePath,
          builder: (context, params) => ConfirmEmailWidget(),
        ),
        FFRoute(
          name: DashboardProfileWidget.routeName,
          path: DashboardProfileWidget.routePath,
          builder: (context, params) => DashboardProfileWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

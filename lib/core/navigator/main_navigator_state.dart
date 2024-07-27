part of 'main_navigator.dart';

/// The MainNavigatorState class is the state associated with the MainNavigator
/// widget. It includes methods and properties for managing navigation within
/// the application.
class MainNavigatorState extends State<MainNavigator> with MainNavigationMixin {
  static final GlobalKey<NavigatorState> _navigationKey =
      GlobalKey<NavigatorState>();
  static final List<NavigatorObserver> _navigatorObservers = [];

  /// The initial route for the navigator.
  static String get initialRoute => RouteNames.splash;

  /// A global key for accessing the navigator state.
  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  /// A list of navigator observers for monitoring navigation events.
  static List<NavigatorObserver> get navigatorObservers => _navigatorObservers;

  /// A getter for accessing the current state of the navigator.
  NavigatorState get navigator => _navigationKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return TextScaleFactor(
      child: widget.child ?? const SizedBox.shrink(),
    );
  }

  /// A static method for generating routes based on the given [settings]. It
  /// maps route names to the corresponding widget builders.
  ///
  /// If the route name does not match any of the defined routes, it defaults
  /// to the SplashScreen.
  ///
  /// Example route settings:
  /// ```dart
  /// RouteSettings(name: RouteNames.login)
  /// ```
  static Route? onGenerateRoute(RouteSettings settings) {
    final strippedPath = settings.name?.replaceFirst('/', '');
    final routes = <String, WidgetBuilder>{
      // Splash Screens
      '': (context) => const SplashScreen(),
      RouteNames.splash: (context) => const SplashScreen(),

      // Auth Screens
      //RouteNames.login: (context) => const LoginScreen(),
      //RouteNames.signup: (context) => const SignupScreen(),
      //RouteNames.otp: (context) => const OtpScreen(),

      // Home Screens
      RouteNames.dashboard: (context) => const DashboardScreen(),
    };

    SplashScreen defaultRoute(context) => const SplashScreen();

    WidgetBuilder? getRouteBuilder(String routeName) {
      if (routes.containsKey(routeName)) {
        return routes[routeName];
      } else {
        return defaultRoute;
      }
    }

    MaterialPageRoute<void> createMaterialPageRoute(
      WidgetBuilder builder,
      RouteSettings settings,
    ) {
      return MaterialPageRoute<void>(
        builder: builder,
        settings: settings,
      );
    }

    final routeBuilder = getRouteBuilder(strippedPath!);
    if (routeBuilder != null) {
      return createMaterialPageRoute(routeBuilder, settings);
    } else {
      return null;
    }
  }
}

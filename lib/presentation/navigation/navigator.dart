import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venues/main.dart';
import 'package:venues/presentation/navigation/screens.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/views/splash/splash_screen.dart';
import 'package:venues/views/venues/favorite_venues_view.dart';
import 'package:venues/views/venues/venue_details_view.dart';

/// Used to defines application's routes and to centralize navigation
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Screens.splash.path,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Screens.splash.path,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            name: Screens.home.name,
            path: Screens.home.path,
            builder: (context, state) {
              return const HomePage();
            },
            routes: <RouteBase>[
              GoRoute(
                name: Screens.venueDetails.name,
                path: Screens.venueDetails.path,
                builder: (context, state) {
                  final venue = state.extra as Venue;
                  print('venue: $venue');
                  return VenueDetailsView(venue: venue);
                },
              ),
            ],
          ),
          GoRoute(
            name: Screens.favoriteVenues.name,
            path: Screens.favoriteVenues.path,
            builder: (context, state) {
              return const FavoriteVenuesView();
            },
          ),
        ],
      ),
    ],
  );
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            label: 'Favorites',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) {
          _onItemTapped(idx, context);
        },
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String? routePath = GoRouterState.of(context).uri.path;
    if (routePath == null) return 0;

    if (routePath.startsWith(Screens.home.path)) {
      return 0;
    }
    if (routePath.startsWith(Screens.favoriteVenues.path)) {
      return 1;
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(Screens.home.name);
        break;
      case 1:
        context.goNamed(Screens.favoriteVenues.name);
        break;
    }
  }
}

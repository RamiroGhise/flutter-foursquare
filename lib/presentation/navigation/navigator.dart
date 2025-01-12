import 'package:go_router/go_router.dart';
import 'package:venues/main.dart';
import 'package:venues/presentation/navigation/screens.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/views/venues/favorite_venues_view.dart';
import 'package:venues/views/venues/venue_details_view.dart';

/// Used to defines application's routes and to centralize navigation
class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Screens.home.path,
    routes: <RouteBase>[
      GoRoute(
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


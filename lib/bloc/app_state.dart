// Application's state
import 'package:venues/services/location/venue.dart';

class AppState {
  final bool isLoading;
  final List<Venue>? venues;
  final Object? error;

  const AppState({
    required this.isLoading,
    required this.venues,
    required this.error,
  });

  const AppState.empty()
      : isLoading = false,
        venues = null,
        error = null;
}
// Application's state
import 'package:flutter/foundation.dart';
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

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      listEquals(venues, other.venues) &&
      error == other.error;

  @override
  int get hashCode => Object.hash(
        isLoading,
        venues,
        error,
      );

  @override
  String toString() {
    return 'AppState, isLoading: $isLoading, error: $error, venues: $venues';
  }
}

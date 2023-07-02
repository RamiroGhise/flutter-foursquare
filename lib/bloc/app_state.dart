// Application's state
import 'package:flutter/foundation.dart';
import 'package:venues/crud/database_venue_model.dart';
import 'package:venues/services/location/venue.dart';

class AppState {
  final bool isLoading;
  final List<Venue>? venues;
  final List<DatabaseVenue> bookmarks;
  final Object? error;

  const AppState({
    required this.isLoading,
    required this.venues,
    required this.bookmarks,
    required this.error,
  });

  AppState.empty()
      : isLoading = false,
        venues = null,
        bookmarks = List<DatabaseVenue>.empty(),
        error = null;

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      listEquals(venues, other.venues) &&
      listEquals(bookmarks, other.bookmarks) &&
      error == other.error;

  @override
  int get hashCode => Object.hash(
        isLoading,
        venues,
        bookmarks,
        error,
      );

  @override
  String toString() {
    return 'AppState, isLoading: $isLoading, error: $error, venues: $venues, bookmarks: $bookmarks';
  }
}

import 'package:flutter/cupertino.dart';
import 'package:venues/services/location/venue.dart';

typedef VenuesLoader = Future<List<Venue>> Function(
    {String? searchQuery, String? searchRadius});

// Base class for all actions that trigger a loading state.
// All these actions will be of type [LoadAction]
@immutable
abstract class LoadAction {
  const LoadAction();
}

// Used to trigger an initialization process
class InitializeBookmarksAction implements LoadAction {
  const InitializeBookmarksAction();
}

// The action takes an optional search text and an optional search radius.
// These will be used in the query made by the location provider.
class LoadVenuesAction implements LoadAction {
  final String? searchText;
  final String? searchRadius;
  final VenuesLoader loader;

  const LoadVenuesAction({
    this.searchText,
    this.searchRadius,
    required this.loader,
  });
}

// Action triggered by a successful fetching of venues.
class SuccessfullyLoadVenuesAction implements LoadAction {
  final List<Venue> venues;

  const SuccessfullyLoadVenuesAction({required this.venues});
}

// Action triggered when venues fetching has failed.
class FailedLoadVenuesAction implements LoadAction {
  final Object error;

  const FailedLoadVenuesAction({required this.error});
}

// Action triggered when the user bookmarks a venue
class AddOrRemoveVenueBookmarkAction implements LoadAction {
  final String venueId;

  AddOrRemoveVenueBookmarkAction({required this.venueId});
}

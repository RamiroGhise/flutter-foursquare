import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';

@immutable
abstract class Action {
  const Action();
}

// A signal to the store that the venues are loading
@immutable
class LoadVenuesAction extends Action {
  final String? searchText;
  final String? searchRadius;

  const LoadVenuesAction({this.searchText, this.searchRadius});
}

// A signal to the store that the venues were successfully fetched from the
// location provider.
@immutable
class SuccessfullyLoadVenuesAction extends Action {
  final List<Venue> venues;

  const SuccessfullyLoadVenuesAction({required this.venues});
}

// A signal to the store that there was an error while trying to fetch the venues.
@immutable
class FailedLoadVenuesAction extends Action {
  final Object error;

  const FailedLoadVenuesAction({required this.error});
}

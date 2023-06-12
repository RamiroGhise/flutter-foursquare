import 'package:flutter/cupertino.dart';
import 'package:venues/services/location/venue.dart';


// Base class for all actions related to fetching venues.
// All these actions will be of type [LoadAction]
@immutable
abstract class LoadAction {
  const LoadAction();
}


// The action takes an optional search text and an optional search radius.
// These will be used in the query made by the location provider.
class LoadVenuesAction implements LoadAction {
  final String? searchText;
  final String? searchRadius;

  const LoadVenuesAction({this.searchText, this.searchRadius});
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


import 'package:venues/services/location/venue.dart';

abstract class LocationProvider {
  Future<List<Venue>> getVenues({
    String? searchQuery,
    String? searchRadius,
  });
}

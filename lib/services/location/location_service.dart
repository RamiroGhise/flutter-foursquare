import 'dart:async';
import 'package:venues/services/location/foursquare_location_provider.dart';
import 'package:venues/services/location/location_provider.dart';
import 'package:venues/services/location/venue.dart';

class LocationService implements LocationProvider {
  final FoursquareLocationProvider provider;
  List<Venue> _venues = [];

  static final _venuesStreamController = StreamController<List<Venue>>.broadcast();

  LocationService(this.provider);

  factory LocationService.foursquare() {
    return LocationService(FoursquareLocationProvider());
  }

  Stream<List<Venue>> get venues => _venuesStreamController.stream;

  @override
  Future<List<Venue>> getVenues(
      {String? searchQuery, String? searchRadius}) async {
    final List<Venue> venues = await provider.getVenues(
      searchQuery: searchQuery,
      searchRadius: searchRadius,
    );

    _venues = venues;
    _venuesStreamController.sink.add(_venues);

    return venues;
  }
}

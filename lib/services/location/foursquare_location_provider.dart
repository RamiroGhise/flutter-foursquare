import 'dart:convert';
import 'dart:io';

import 'package:current_location/current_location.dart';
import 'package:venues/services/app_config.dart';
import 'package:venues/services/location/location_exceptions.dart';
import 'package:venues/services/location/location_provider.dart';
import 'package:venues/services/location/venue.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class FoursquareLocationProvider implements LocationProvider {
  final _currentLocation = CurrentLocation();
  final String _apiKey = AppConfig.foursquareApiKey;

  FoursquareLocationProvider();

  @override
  Future<List<Venue>> getVenues({
    String? searchQuery,
    String? searchRadius,
  }) async {
    double latitude = 0.0;
    double longitude = 0.0;
    final coordinates = await _currentLocation.getCoordinates();
    devtools.log('coordinates are: ${coordinates.toString()}');
    if (coordinates != null) {
      latitude = coordinates['latitude'] ?? 0.0;
      longitude = coordinates['longitude'] ?? 0.0;
    }
    if (latitude == 0 || longitude == 0) {
      // if the coordinates could not be fetched
      return [];
    }
    Map<String, dynamic> queryParameters = {};
    if (searchQuery != null) queryParameters['query'] = searchQuery;
    queryParameters['ll'] = "$latitude,$longitude";
    if (searchRadius != null) queryParameters['radius'] = searchRadius;
    queryParameters['fields'] =
        'fsq_id,name,distance,categories,photos,tastes,features,rating,stats,location,geocodes,description,tel,email,website,hours,price,menu';
    queryParameters['sort'] = 'DISTANCE';
    queryParameters['limit'] = '10';

    final url = Uri.https(
      "api.foursquare.com",
      "/v3/places/search",
      queryParameters,
    );
    devtools.log(url.toString());
    final headers = {
      "accept": "application/json",
      "Authorization": _apiKey,
    };

    List<Venue> venuesList = [];
    try {
      final http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 400) {
        final message = jsonDecode(response.body)['message'];
        throw BadRequestLocationException(message);
      } else if (response.statusCode == 401) {
        final message = jsonDecode(response.body)['message'];
        throw UnauthorizedLocationException(message);
      } else {
        final venuesJson = jsonDecode(response.body);
        var results = venuesJson['results'];
        for (final venueJson in results) {
          final venue = Venue.fromFoursquare(venueJson);
          venuesList.add(venue);
        }
        if (venuesList.isEmpty) {
          throw NoVenuesFoundLocationException();
        }

        return venuesList;
      }
    } on SocketException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

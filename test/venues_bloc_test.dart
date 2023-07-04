import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venues/bloc/actions.dart';
import 'package:venues/bloc/app_state.dart';
import 'package:venues/bloc/venues_bloc.dart';
import 'package:venues/services/location/venue.dart';

void main() {
  group('Testing BLoC', () {
    late VenuesBloc bloc;
    late List<Venue> foursquareVenues;
    // The setUp function is run once per test for every test in the group.
    // setUp() is not run once for all tests in the group but once before every test in the group.
    setUp(() async {
      bloc = VenuesBloc();
      foursquareVenues = await getVenuesFoursquareMock();
    });

    blocTest<VenuesBloc, AppState>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, AppState.empty()),
    );

    // fetch mock data (venues.json)
    blocTest(
      'Mock retrieving venues from Foursquare',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadVenuesAction(
          searchText: null,
          searchRadius: null,
          loader: getVenuesFoursquareMock,
        ));
      },
      wait: const Duration(seconds: 2),
      expect: () => [
        AppState(
          isLoading: true,
          venues: null,
          bookmarks: bloc.state.bookmarks,
          error: null,
        ),
        AppState(
          isLoading: false,
          venues: foursquareVenues,
          bookmarks: bloc.state.bookmarks,
          error: null,
        )
      ],
    );
  });
}

// Mock function used to fetch venues from Foursquare
Future<List<Venue>> getVenuesFoursquareMock({
  String? searchQuery,
  String? searchRadius,
}) async {
  final String httpResponseBody = await Future.delayed(
    const Duration(seconds: 2),
    () {
      return File('test/venues.json').readAsStringSync();
    },
  );
  final venuesJson = jsonDecode(httpResponseBody);
  List<Venue> venuesList = [];
  var results = venuesJson['results'];
  for (final venueJson in results) {
    final venue = Venue.fromFoursquare(venueJson);
    venuesList.add(venue);
  }

  return venuesList;
}

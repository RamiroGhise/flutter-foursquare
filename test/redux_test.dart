import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:venues/redux/actions.dart';
import 'package:venues/redux/app_state.dart';
import 'package:venues/redux/reducer.dart';
import 'package:venues/services/location/location_exceptions.dart';
import 'package:venues/services/location/venue.dart';

void main() {
  group('Testing reducer', () {
    test('testing response to loadVenuesAction', () {
      const initialState = AppState.empty();
      const action = LoadVenuesAction();
      final AppState state = reducer(initialState, action);
      const isLoadingState = AppState(
        isLoading: true,
        venues: null,
        error: null,
      );
      expect(state, isLoadingState);
    });

    test('testing response to FailedLoadVenuesAction', () {
      const isLoadingState = AppState(
        isLoading: true,
        venues: null,
        error: null,
      );
      const initialState = isLoadingState;
      final action = FailedLoadVenuesAction(
          error: BadRequestLocationException('bad request'));
      final AppState state = reducer(initialState, action);

      final failedLoadingState = AppState(
        isLoading: false,
        venues: initialState.venues,
        error: action.error,
      );

      expect(state.isLoading, failedLoadingState.isLoading);
      expect(state.venues, failedLoadingState.venues);
      expect(state.error, failedLoadingState.error);
      expect(state, isNot(failedLoadingState));
    });

    test('testing response to SuccessfullyLoadVenuesAction', () {
      const isLoadingState = AppState(
        isLoading: true,
        venues: null,
        error: null,
      );
      const initialState = isLoadingState;

      final venuesMock = File('test/venues.json');
      final venuesJson = jsonDecode(venuesMock.readAsStringSync());
      var results = venuesJson['results'];
      List<Venue> venuesList = [];
      for (final venueJson in results) {
        final venue = Venue.fromFoursquare(venueJson);
        venuesList.add(venue);
      }

      final action = SuccessfullyLoadVenuesAction(venues: venuesList);
      final state = reducer(initialState, action);

      final successfullyLoadVenuesState = AppState(
        isLoading: false,
        venues: state.venues,
        error: null,
      );

      expect(state.isLoading, successfullyLoadVenuesState.isLoading);
      expect(state.venues, successfullyLoadVenuesState.venues);
      expect(state.error, successfullyLoadVenuesState.error);
      expect(state, isNot(successfullyLoadVenuesState));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:venues/redux/actions.dart';
import 'package:venues/redux/app_state.dart';
import 'package:venues/redux/reducer.dart';
import 'package:venues/services/location/location_exceptions.dart';

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
      final action = FailedLoadVenuesAction(error: BadRequestLocationException('bad request'));
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
  });
}

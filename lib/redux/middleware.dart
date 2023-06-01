import 'package:redux/redux.dart';
import 'package:venues/redux/actions.dart';
import 'package:venues/redux/app_state.dart';
import 'package:venues/services/location/location_service.dart';
import 'dart:developer' as devtools show log;

void loadVenuesMiddleware(
  Store<AppState> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadVenuesAction) {
    LocationService.foursquare()
        .getVenues(
      searchQuery: action.searchText,
      searchRadius: action.searchRadius,
    )
        .then((venues) {
      // after the venues are successfully fetched, notify the reducer
      store.dispatch(SuccessfullyLoadVenuesAction(venues: venues));
    }).catchError((e) {
      store.dispatch(FailedLoadVenuesAction(error: e));
    });
  }
  // send the action to the next middleware and/or to the reducer
  next(action);
}

void logMiddleware(
  Store<AppState> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadVenuesAction) {
    devtools.log('User performed ${action.runtimeType}');
  } else if (action is SuccessfullyLoadVenuesAction) {
    devtools.log('Venues fetched ${action.venues}');
  } else if (action is FailedLoadVenuesAction) {
    devtools.log('An error occurred: ${action.error.toString()}');
  }

  // send the action to the next middleware and/or to the reducer
  next(action);
}
